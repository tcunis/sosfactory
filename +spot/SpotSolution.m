classdef (InferiorClasses = {?msspoly}) SpotSolution < sosfactory.AbstractSOSSolution
% Solution of SPOT optimization.
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
    sol;
end

properties (Dependent)
    solverinfo;
    feas;
    obj;
    
    primal;
    dual;
    
    % debug
    sizeLMI;
end

methods
    function obj = SpotSolution(sol)
        % Create new SPOT solution object.
        
        obj.sol = sol;
    end
    
    function sout = subs(s,obj)
        % Substitute solution.
        
        if obj.feas
            sout = obj.sol.eval(s);
        else
            sout = [];
        end
    end
    
    %% Getter
    function info = get.solverinfo(obj)
        % Info struct of SDP solver.
        
        info = obj.sol.info.solverInfo;
    end
    
    function feas = get.feas(obj)
        % Feasibility flag.
        
        feas = isDualFeasible(obj.sol);
    end
    
    function opt = get.obj(obj)
        % Optimal objective value.
        
        opt = double(subs(obj.sol.objective,obj));
    end
    
    function vars = get.primal(obj)
        % Primal decision variables.
        vars = obj.sol.x;
    end
    
    function vars = get.dual(obj)
        % Dual decision variables.
        vars = obj.sol.y;
    end
    
    function sz = get.sizeLMI(obj)
        % Size of generated LMI.
        sz = [length(obj.dual) length(obj.primal)];
    end
end

end