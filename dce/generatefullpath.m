function fullpath = generatefullpath(handles);

batchdata = handles.batchdata;
numfile = 0;
for i = 1:numel(batchdata)
    files = batchdata(i).files;
    for j = 1:numel(files)
        
        if ~isempty(files{j})
            fullpath(numfile+1) = files(j);
            
            numfile = numfile + 1;
        end
    end
end