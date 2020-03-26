function [tout,rout] = rose2Relative(varargin)
%ROSE   Angle histogram plot.
%   ROSE(THETA) plots the angle histogram for the angles in THETA.
%   The angles in the vector THETA must be specified in radians.
%
%   ROSE(THETA,N) where N is a scalar, uses N equally spaced bins
%   from 0 to 2*PI.  The default value for N is 20.
%
%   ROSE(THETA,X) where X is a vector, draws the histogram using the
%   bins specified in X.
%
%   ROSE(AX,...) plots into AX instead of GCA.
%
%   H = ROSE(...) returns a vector of line handles.
%
%   [T,R] = ROSE(...) returns the vectors T and R such that
%   POLAR(T,R) is the histogram.  No plot is drawn.
%
%   See also HIST, POLAR, COMPASS.

%   Clay M. Thompson 7-9-91
%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 5.14.4.4 $  $Date: 2005/04/28 19:56:53 $

[cax,args,nargs] = axescheck(varargin{:});
error(nargchk(1,2,nargs,'struct'));

theta = args{1};
if nargs > 1,
    x = args{2};
end

if ischar(theta)
    error(id('NonNumericInput'),'Input arguments must be numeric.');
end
theta = rem(rem(theta,2*pi)+2*pi,2*pi); % Make sure 0 <= theta <= 2*pi
if nargs==1,
    x = (0:19)*pi/10+pi/20;
    
elseif nargs==2,
    if ischar(x)
        error(id('NonNumericInput'),'Input arguments must be numeric.');
    end
    if length(x)==1,
        x = (0:x-1)*2*pi/x + pi/x;
    else
        x = sort(rem(x(:)',2*pi));
    end
    
end
if ischar(x) || ischar(theta)
    error(id('NonNumericInput'),'Input arguments must be numeric.');
end

% Determine bin edges and get histogram
edges = sort(rem([(x(2:end)+x(1:end-1))/2 (x(end)+x(1)+2*pi)/2],2*pi));
edges = [edges edges(1)+2*pi];
nn = histc(rem(theta+2*pi-edges(1),2*pi),edges-edges(1));
nn(end-1) = nn(end-1)+nn(end);
nn(end) = [];

% Perform percentage calculation
nn = 100*nn/sum(nn);

% Form radius values for histogram triangle
if min(size(nn))==1, % Vector
    nn = nn(:);
end
[m,n] = size(nn);
mm = 4*m;
r = zeros(mm,n);
r(2:4:mm,:) = nn;
r(3:4:mm,:) = nn;

% Form theta values for histogram triangle from triangle centers (xx)
zz = edges;

t = zeros(mm,1);
t(2:4:mm) = zz(1:m);
t(3:4:mm) = zz(2:m+1);

if nargout<2
    if ~isempty(cax)
        h = polar(cax,t,r);
    else
        h = polar(t,r);
    end
    [a,b] = pol2cart(t,r);  % convert histogram line to polar coordinates
    A = reshape(a,4,numel(x));    % reshape x vector into N columns
    B = reshape(b,4,numel(x));    % reshape y vector into N columns
    patch(A,B,[1 0 0])      % plot N patches based on the columns of A and B
    
    if nargout==1, tout = h; end
      
    % Change the view angle, 0 degrees at the top
    view(90,-90);
    
    %Get the radial tick labels
    hParent = get(h,'Parent');
    Percentlabels = cellstr(get(hParent,'XTickLabel'));
    
    % Add percent sign to each label and modify the position
    for i = 1:numel(Percentlabels)
        
        % Add percent label to the string
        Percentlabel{i} = strcat(Percentlabels{i}, '%');
        
        % Find the handle to the radial label
        h = findall(gcf,'String',['  ',Percentlabels{i}]);
        
        % Get the position of the radial label
        currentPosition = get(h,'Position');
        
        % If the position is a number
        if numel(currentPosition) > 0
            % create the new position
            newPosition = [-1.2 currentPosition(2) currentPosition(3)];
            % Set the new position
            set(h,'Position',newPosition)
        end
        % Set the label
        set(h,'String',Percentlabel{i})
    end
    
    % Add title
    limit = str2num(Percentlabels{end});
    % Add north
    hn = text(limit-1,0,'N');
    set(hn,'FontWeight','bold')
    % Add south
    hs = text(-(limit-1),0,'S');
    set(hs,'FontWeight','bold')
    % Add east
    he = text(0,limit-1,'E');
    set(he,'FontWeight','bold')
    % Add west
    hw = text(0,-(limit-1),'W');
    set(hw,'FontWeight','bold')
    
    return
end

if min(size(nn))==1,
    tout = t'; rout = r';
else
    tout = t; rout = r;
end

function str=id(str)
str = ['MATLAB:rose:' str];


