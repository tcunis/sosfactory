classdef (Abstract) AbstractSOSFactory
% Abstract factory for polynomial and SOS toolboxes.
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
    %% Fabric constructors
    x = polyvar(obj,var,n,m,varargin);
    
    %% Fabric operators
    J = jacob(obj,f,x);
    p = cleanp(obj,tol,deg);
    
    %% Fabric checks & getters
    tf = ispolynomial(obj,a);
    tf = ispolyvar(obj,a);
    tf = ismonomial(obj,a);
    
    dg = degree(obj,f,m);
    
    %% Fabric SOS constraints & options
    sosc = newconstraints(obj,x);
    
    sopt = newoptions(obj,varargin);
    
end

end
