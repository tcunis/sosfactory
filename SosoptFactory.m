classdef SosoptFactory < AbstractSOSFactory
% Factory implementation for multipoly and sosopt toolbox.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2019-02-22
% * Changed:    2019-02-22
%
%%

methods
    %% Multipoly constructor
    function varargout = polyvar(~,var,n,varargin)
        % Return multi-dimensional polynomial variable.
    
        if nargin < 3
            n = max(nargout,1);
            varargin = {1};
        end
        
        x = mpvar(var,n,varargin{:});
        
        if nargout > 1
            varargout = arrayfun(@(c) c, x, 'UniformOutput',false);
        else
            varargout = {x};
        end
    end
    
    %% Multipoly checks
    function tf = ispolynomial(~,a)
        % Check if a is polynomial object.
        
        tf = isa(a, 'polynomial');
    end
    
    function tf = ispolyvar(~,a)
        % Check if a is polynomial variable.
        
        tf = ispvar(a);
    end
    
    function tf = ismonomial(~,a)
        % Check if a is a (vector of) monomial(s).
        
        tf = ismonom(a);
    end
    
    function dg = degree(obj,f,m)
        % Return degrees of f.
        
        assert(ispolynomial(obj,f), 'Input must be compatible polynomial.');
        
        dg = [f.mindeg f.maxdeg];
        
        if nargin > 2
            assert(1 <= m && m <= 2, 'Argument must be between 1 and 2');
            dg = dg(m);
        end
    end
    
    %% Multipoly operators
    function J = jacob(~,f,x)
        % Compute Jacobian matrix of f w.r.t. x.
        
        J = jacobian(f,x);
    end
    
    function p = cleanp(~,p,varargin)
        % Clean-up polynomial.
        
        p = cleanpoly(p,varargin{:});
    end
    
    %% SOS constraints & options
    function sosc = newconstraints(~,x)
        % Return SOS constraint object.
        
        sosc = SosoptConstraints(x);
    end
    
    function sopt = newoptions(~,varargin)
        % Return (g)SOS options object.
        
        sopt = gsosoptions(varargin{:});
    end
end

end