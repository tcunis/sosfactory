function [obj,p] = polymdecvar(obj, z, varargin)
% Returns k-by-m vector of polynomial decision variables.

sz = horzcat(varargin{:});

p = msspoly(zeros(sz));
for i=1:sz(1)
    for j=1:sz(end)
        [obj,p(i,j)] = polydecvar(obj,z);
    end
end

end