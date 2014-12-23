function [sortlist_fullpath, sortlist, sortlist_filename] = sort_parse_INPUTS(fullpath);

for i = 1:numel(fullpath)
    curpath = fullpath{i};
    
    [~, curpath, ~] = fileparts(curpath);
    
    original_filename{i} = curpath;
    
    
    
    sortlist{i} = natORDERhelper(curpath);
end


% Now sort the list

[sortlist, ind] = sort(sortlist);%, 'ascend');

for i = 1:numel(fullpath)
    sortlist_fullpath(i)   = fullpath(ind(i));
    sortlist_filename(i)= original_filename(ind(i));
end

