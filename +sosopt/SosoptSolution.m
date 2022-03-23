classdef (InferiorClasses = {?polynomial}) SosoptSolution < sosfactory.AbstractSOSSolution
% Solution of sosopt optimization.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2019-03-11
% * Changed:    2019-03-29
%
%%

properties (Access=protected)
    info;
    dopt;
end

properties (Dependent)
    solverinfo;
    feas;
    obj;
    
    primal;
    dual;
end

methods
    function obj = SosoptSolution(info,dopt)
        % Create new sosopt solution object.
        
        obj.info = info;
        obj.dopt = dopt;
    end
    
    function sout = subs(s,obj)
        % Substitute solution.
        
        sout = subs(s,obj.dopt);
    end
    
    %% Getter
    function info = get.solverinfo(obj)
        % Info struct of SDP solver.
        
        info = obj.info.sdpsol.solverinfo;
    end
    
    function feas = get.feas(obj)
        % Feasibility flag.
        
        feas = obj.info.feas;
    end
    
    function opt = get.obj(obj)
        % Optimal objective value.
        
        if isfield(obj.info,'tbnds')
            % Quasi-convex optimal bounds
            opt = obj.info.tbnds;
        else
            opt = obj.info.obj;
        end
    end
    
    function vars = get.primal(obj)
        % Primal decision variables.
        vars = obj.info.sdpsol.x;
    end
    
    function vars = get.dual(obj)
        % Dual decision variables.
        vars = obj.info.sdpsol.y;
    end
end

end