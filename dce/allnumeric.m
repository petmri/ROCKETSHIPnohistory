function out = allnumeric(tempsort_list)

for i = 1:numel(tempsort_list)
    
    if isnumeric(str2num(tempsort_list{i}))
        out = 1;
    else
        out = 0;
        return;
    end
end