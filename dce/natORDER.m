function sortlist = natORDER(sortlist)

for i = 1:numel(sortlist)
    
    curpath = sortlist{i};
    sortlist{i} = natORDERhelper(curpath);
    
end