classdef SosoptConstraints < sosfactory.AbstractSOSConstraints
% SOS constraint class for sosopt toolbox.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2019-02-22
% * Changed:    2019-02-22
%
%%

properties (Access=protected)
    prefix = 'SOSCprefix';
    ndvars = 0;
    
    pcons = polyconstr;
    
    x;
end

methods
    %% Constructors
    function obj = SosoptConstraints(argin)
        % Create new SOS constraint object.
        
        if isa(argin, 'SosoptConstraints')
            % clone
            obj.ndvars = argin.ndvars;
            obj.pcons  = argin.pcons;
            obj.x      = argin.x;
        elseif ispvar(argin)
            % new
            obj.x = argin;
        else
            error('Input %s not supported.', class(argin));
        end
    end
    
    function sosc = clone(obj)
        % Clone SOS constraint object.
        
        sosc = SosoptConstraints(obj);
    end
    
    %% Decision variables
    function [obj,a] = decvar(obj,n,m)
        % Return n-by-m matrix of decision variables.
        
        if nargin < 3
            m = n(end);
            n = n(1);
        end
        
        [obj,a] = sosoptdecvar(obj,@mpvar,n,m);
    end
    
    function [obj,q] = symdecvar(obj,n)
        % Return symmetric n-by-n matrix of decision variables.
        
        [obj,q] = sosoptdecvar(obj,@mpvar,n,n,'s');
    end
    
    function [obj,p] = polydecvar(obj,w)
        % Return polynomial decision variable.
        
        [obj,p] = sosoptdecvar(obj,@polydecvar,w);
    end
    
    function [obj,s] = sosdecvar(obj,z)
        % Return SOS decision variable.
        
        [obj,s] = sosoptdecvar(obj,@sosdecvar,z);
    end
    
    %% SOS Constraints
    function obj = eq(obj,a,b)
        % Add equality constraint a == b.
        
        obj = addconstraint(obj,@eq,a,b);
    end
    
    function obj = le(obj,a,b)
        % Add non-positivity constraint a <= b.
        
        obj = addconstraint(obj,@le,a,b);
    end
    
    function obj = ge(obj,a,b)
        % Add non-negativity constraint a >= b.
        
        obj = addconstraint(obj,@ge,a,b);
    end
    
    %% Optimization
    function [sol,min] = optimize(obj,objective,opts)
        % SOS optimization.
        
        if nargin < 2
            objective = [];
        end
        if nargin < 3
            opts = sosoptions;
        end
        
        [info,dopt] = sosopt(obj.pcons,obj.x,objective,opts);
        
        sol = sosfactory.sosopt.SosoptSolution(info,dopt);
        
        min = info.obj;
    end
    
    function [sol,min] = goptimize(obj,objective,opts)
        % Quasi-convex optimization.
        
        if nargin < 3
            opts = gsosoptions;
        end
        
        if ispvar(-objective)
            % maximization problem
            objective = -objective;
            sosc = subs(obj.pcons,objective,-objective);
        else
            sosc = obj.pcons;
        end
        
        [info,dopt] = gsosopt(sosc,obj.x,objective,opts);
        
        sol = sosfactory.sosopt.SosoptSolution(info,dopt);
        
        min = info.tbnds;
    end
    
    %% various
    function varargout = size(obj,varargin)
        % See SIZE
        varargout = cell(1,max(1,nargout));
        [varargout{:}] = size(obj.pcons,varargin{:});
    end
    
    function obj = subs(obj,varargin)
        % Substitute variables.
        obj.pcons = subs(obj.pcons,varargin{:});
    end
end
   
methods (Access=private)
    function obj = addconstraint(obj,cmp,a,b)
        % Add constraint cmp(a,b).
        
        sosc = cmp(a,b);
        
        obj.pcons = vertcat(obj.pcons, sosc);
    end
    
    function [obj,v] = sosoptdecvar(obj,type,varargin)
        % Return generic sosopt decision variable.
    
        cstr = [obj.prefix num2str(obj.ndvars)];
        
        v = feval(type,cstr,varargin{:});
        
        obj.ndvars = obj.ndvars + 1;
    end
end

end