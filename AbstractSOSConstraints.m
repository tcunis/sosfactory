classdef (Abstract) AbstractSOSConstraints < handle
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
    a = decvar(obj,n,m);
    q = symdecvar(obj,n);
    p = polydecvar(obj,w);
    s = sosdecvar(obj,z);
    
    s = sosmdecvar(obj,z,k);
    
    %% Fabric constraints
    eq(obj,a,b);
    le(obj,a,b);
    ge(obj,a,b);
    
    %% Optimization
    sol = optimize(obj,objective,opts);
    
end
    
end