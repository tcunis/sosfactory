classdef SpotSOSConstraints < sosfactory.spot.SpotConstraints
% SOS constraint class for SPOT toolbox.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2019-03-29
% * Changed:    2019-03-29
%
%%

methods
    %% Constructors
    function obj = SpotSOSConstraints(varargin)
        % Create new SOS constraint object.
        obj@sosfactory.spot.SpotConstraints(varargin{:});
    end
    
    function sosc = clone(obj)
        % Clone SOS constraint object.
        
        sosc = sosfactory.spot.SpotSOSConstraints(obj);
    end
    
    function q = symdecvar(obj,n)
        % Return symmetric n-by-n matrix of decision variables.
        
        [obj.prog,q] = newPSD(obj.prog,n);
    end
    
    function p = sosdecvar(obj,z)
        % Return SOS decision variable.
        
        Q = symdecvar(obj,length(z));
        p = z'*Q*z;
    end
    
    %% SOS Constraints
    function le(obj,a,b)
        % Add non-positivity constraint a <= b.
        
        if ~isFunctionOfX(obj,a-b)
            % scalar non-positivity
            obj.le@sosfactory.spot.SpotConstraints(a,b);
        else
            % polynomial non-positivity
            obj.prog = withSOS(obj.prog,b-a);
        end
    end
    
    function ge(obj,a,b)
        % Add non-negativity constraint a <= b.
        
        if ~isFunctionOfX(obj,a-b)
            % scalar non-negativity
            obj.ge@sosfactory.spot.SpotConstraints(a,b);
        else
            % polynomial non-negativity
            obj.prog = withSOS(obj.prog,a-b);
        end
    end    
end

end