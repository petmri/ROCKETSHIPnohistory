function fullpath = generatefullpath(handles);

batchdata = handles.batchdata;
fullpath = '';
for i = 1:numel(batchdata)
    files = batchdata(i).files;
    for j = 1:numel(files)
        
        fullpath(end+1) = files(j);
    end
end