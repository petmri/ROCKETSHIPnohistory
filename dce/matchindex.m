function id = matchindex(curname, filelist);

% find the index in the filelist that matches the curname

for i = 1:numel(filelist)
    [~, namer, ~] = fileparts(filelist{i});
    if strmatch(namer, curname, 'exact')
        id = i;
        return;
    end
end