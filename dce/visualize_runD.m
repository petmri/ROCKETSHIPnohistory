function list = visualize_runD(list, filename);
newlist = '';
if strcmp(list, 'No files for batch processing')
    list = '';
end

newsize = numel(filename);

oldsize = size(list, 2);

larger  = max(newsize,oldsize);

for i = 1:size(list,1)
    
    curname = list(i,:);
    
    curname = [curname blanks(max(0, larger-oldsize))];
    
    newlist(i,:) = curname;
end

curname = [filename blanks(max(0, larger-newsize))];

newlist(end+1,:) = curname;

list = newlist;