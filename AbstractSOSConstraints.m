classdef (Abstract) AbstractSOSConstraints
% Abstract class for SOS constraints.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2019-03-11
% * Changed:    2019-03-11
%
%%

methods (Abstract)
    %% Copy-constructor
    sosc = clone(obj);
    
    %% Decision variables
    [sosc,a] = decvar(obj,n,m);
    [sosc,q] = symdecvar(obj,n);
    [sosc,p] = polydecvar(obj,w);
    [sosc,s] = sosdecvar(obj,z);
    
    [sosc,p] = polymdecvar(obj,w,n,m);
    [sosc,s] = sosmdecvar(obj,z,n,m);
    
    %% Fabric constraints
    sosc = eq(obj,a,b);
    sosc = le(obj,a,b);
    sosc = ge(obj,a,b);
    
    %% Optimization
    sol = optimize(obj,objective,opts);
    
end
    
end