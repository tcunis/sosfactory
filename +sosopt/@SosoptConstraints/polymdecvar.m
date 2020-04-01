function [obj,s] = polymdecvar(obj, w, varargin)
% Returns k-by-m vector of polynomial decision variables.

sz = horzcat(varargin{:});

s = polynomial(zeros(sz));
for i=1:sz(1)
    for j=1:sz(end)
        [obj,s(i,j)] = polydecvar(obj,w);
    end
end

end