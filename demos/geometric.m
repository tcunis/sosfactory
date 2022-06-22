% Example of SOSFactory for a geometric problem using sosopt or SPOT.
%
% Here, we want to find the shortest distance betweenn a point (x0,y0) and 
% a curve C(x,y) = 0, that is,
%
%   r^2 := min (x - x0)^2 + (y - x0)^2 s.t. C(x,y) = 0
%
% This example is based on [Par03, Example 7.4].
%
% [Par03]   Parillo, P. A. (2003). Semidefinite programming relaxations for 
%           semialgebraic problems. Mathematical Programming, Series B, 
%           96(2), 293?320. doi:10.1007/s10107-003-0387-5
%

import sosfactory.sosopt.*
import sosfactory.spot.*

% All you need to do to switch between sosopt and SPOT is to toggle the
% following two lines!

% sosf = SosoptFactory;   % toggle comment for sosopt
sosf = SpotFactory;     % toggle comment for SPOT

x0 = 1;
y0 = 1;

[x,y] = polyvar(sosf,'z',2,1); % this creates a 2-by-1 polynomial variable 
                               % z and assigns its components to x and y.
P = (x - x0)^2 + (y - y0)^2;
C = x^3 - 8*x - 2*y;


%% Lower bound
% a lower bound G <= r^2 can be computed as sum-of-squares problem [Par03].
sosc1 = newconstraints(sosf,[x;y]);

[sosc1,G] = decvar(sosc1,1,1);       % scalar decision variable
[sosc1,f] = polydecvar(sosc1,[1;x]); % polynomial decision variable f = a + b*x

sosc1 = sosc1.ge(P - G + f*C, 0);
sosc1 = sosc1.ge(G, 0);

sol1 = optimize(sosc1, -G);  % we want to find max G

if sol1.feas    % check feasibility of sosc1
    % output optimal values
    G = subs(G, sol1); display(G)
    f = subs(f, sol1); display(f)
end

