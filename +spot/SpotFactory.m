classdef SpotFactory < sosfactory.AbstractSOSFactory
% Factory implementation for msspoly and SPOT toolbox.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2019-03-29
% * Changed:    2019-03-29
%
%%

properties
    type = 'SOS';
end

methods
    function obj = SpotFactory(type)
        % Create new factory object.
        
        if nargin > 0
            obj.type = type;
        end
    end
    
    %% msspoly constructor
    function varargout = polyvar(~,var,n,m)
        % Return multi-dimensional polynomial variable.
        
        if nargin < 3
            n = 1;
            m = max(nargout,1);
        elseif nargin < 4
            m = 1;
        end
        
        % ensure lower-case variable names for msspoly
        var = lower(var);
        
        X = cell(1,m);
        for i=0:m-1
            X{i+1} = msspoly(var,[n i*n]);
        end
        x = horzcat(X{:});
        
        if nargout > 1
            varargout = arrayfun(@(c) c, x, 'UniformOutput',false);
        else
            varargout = {x};
        end
    end
    
    %% msspoly checks
    function tf = ispolynomial(~,a)
        % Check if a is polynomial object.
        
        tf = isa(a, 'msspoly');
    end
    
    function tf = ispolyvar(~,a)
        % Check if a is polynomial variable.
        
        tf = issimple(a) && isfree(a);
    end
    
    function ismonomial(~,a)
        % Check if a is a (vector of) monomial(s).
        
        tf = all(a.coeff == 1);
    end
    
    function dg = degree(obj,f,m)
        % Return degrees of f.
        
        assert(ispolynomial(obj,f), 'Input must be compatible polynomial.');
        
        exp = sum(f.pow,2);
        dg = [min(exp) max(exp)];
        
        if nargin > 2
            assert(1 <= m && m <= 2, 'Argument must be between 1 and 2');
            dg = dg(m);
        end
    end
    
    %% msspoly operators
    function J = jacob(~,f,x)
        % Compute Jacobian matrix of f w.r.t. x.
        
        J = diff(msspoly(f),x);
    end
    
    function a = cleanp(~,a,tol,deg)
        % Clean-up polynomial.
        [x,p,M]=decomp(a);
        
        if ~isempty(tol)
            % remove coefficients < tol
            M(abs(M)<tol) = 0;
        end
        
        if nargin > 3 && ~isempty(deg)
            % remove terms > deg
            M(:,~any(sum(p,2)==deg,2)) = 0;
        end
        
        a=recomp(x,p,M,size(a));
    end
    
    %% SOS constraints & options
    function sosc = newconstraints(obj,x)
        % Return SOS constraint object.
        
        switch obj.type
            case 'SOS'
                sosc = sosfactory.spot.SpotSOSConstraints(x);
            case 'DSOS'
                sosc = sosfactory.spot.SpotDSOSConstraints(x);
            otherwise
                error('%s constraints not supported.', obj.type)
        end
    end
    
    function sopt = newoptions(~)
        % Return SOS options object.
        
        sopt = spot_sdp_default_options;
    end
end

end
