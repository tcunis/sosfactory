function [obj,s] = sosmdecvar(obj, z, varargin)
% Returns k-by-m vector of SOS decision variables.

sz = horzcat(varargin{:});

s = msspoly(zeros(sz));
for i=1:sz(1)
    for j=1:sz(end)
        [obj,s(i,j)] = sosdecvar(obj,z);
    end
end

end