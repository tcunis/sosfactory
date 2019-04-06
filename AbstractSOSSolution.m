classdef (Abstract) AbstractSOSSolution
% Abstract class for SOS optimization solution.
%
%% About
%
% * Author:     Torbjoern Cunis
% * Email:      <mailto:torbjoern.cunis@onera.fr>
% * Created:    2019-03-11
% * Changed:    2019-03-11
%
%%

properties (Abstract)
    solverinfo;
    feas;
    obj;
end

methods (Abstract)
    sout = subs(obj,s);
    
end

end