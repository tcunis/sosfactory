classdef (Abstract) SpotConstraints < sosfactory.AbstractSOSConstraints
% Abstract constraint class for SPOT toolbox.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2019-03-29
% * Changed:    2019-03-29
%
%%

properties (Access=protected)
    prog;
end

methods
    %% Constructors
    function obj = SpotConstraints(argin)
        % Create new SOS constraint object.
        
        if isa(argin, 'SpotConstraints')
            % clone
            obj.prog = argin.prog;
        elseif isfree(argin)
            % new
            obj.prog = spotsosprog;
            obj.prog = withIndeterminate(obj.prog, argin);
        else
            error('Input %s not supported.', class(argin));
        end
    end
    
    %% Decision variables
    function a = decvar(obj,n,m)
        % Return n-by-m matrix of decision variables.
        
        if nargin < 3
            m = n;
        end
        
        [obj.prog,a] = newFree(obj.prog,n,m);
    end
    
    function p = polydecvar(obj,w)
        % Return polynomial decision variable.
        
        [obj.prog,p] = newFreePoly(obj.prog,w);
    end
    
    %% SOS Constraints
    function eq(obj,a,b)
        % Add equality constraint a == b.
        
        if isFunctionOfX(obj,a-b)
            % polynomial equality
            % add a <= b & a >= b
            obj.le(a,b);
            obj.ge(a,b);
        else
            % scalar equality
            % add a == b
            obj.prog = withEqs(obj.prog,a-b);
        end
    end
    
    function le(obj,a,b)
        % Add non-positivity constraint a <= b.
        
        if isFunctionOfX(obj,a-b)
            % polynomial non-positivity
            error('Polynomial non-positivity not implemented here.');
        else
            % scalar non-positivity
            obj.prog = withPos(obj.prog,b-a);
        end
    end
    
    function ge(obj,a,b)
        % Add non-negativity constraint a >= b.
        
        if isFunctionOfX(obj,a-b)
            % polynomial non-negativity
            error('Polynomial non-negativity not implemented here.');
        else
            % scalar non-positivity
            obj.prog = withPos(obj.prog,a-b);
        end
    end
    
    %% Optimization
    function [sol,min] = optimize(obj,objective,opts)
        % Optimization
        
        if nargin < 2 || isempty(objective)
            objective = msspoly(1);
        end
        if nargin < 3
            opts = obj.prog.defaultOptions;
        end
        
        sossol = minimize(obj.prog,objective,@spot_sedumi,opts);
        
        sol = sosfactory.spot.SpotSolution(sossol);
        min = subs(objective,sol);
    end
end

methods (Access=protected)
    function tf = isFunctionOfX(obj,p)
        % Checks whether p is a function of the indeterminates.
        [~,~,M] = decomp(p,obj.prog.indeterminates);
        
        tf = ~isdouble(M);
    end
end
        

end