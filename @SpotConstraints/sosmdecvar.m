function s = sosmdecvar(obj, z, k)
% Returns k-by-1 vector of SOS decision variables.

s = msspoly(zeros(k,1));
for i=1:k
    s(i) = sosdecvar(obj,z);
end

end