function tempstr = natORDERhelper(curpath)

 % Change all dashes to underscore
    curpath = strrep(curpath, '-', '_');
    
    %Find all the numbers in the curpath
    numbers = regexp(curpath,['\d+'], 'match');
    
    % The maximum placeholder length is the larger of natdigits or the
    % longest continuous number string in the file name
    natdigits = 8;
    for k = 1:numel(numbers)
        natdigits = max(natdigits, numel(numbers{k}));
        natdigits = max(natdigits);
    end
    
    placeholder = rand(1)*10^natdigits;
    placeholder = num2str(placeholder);
    placeholder = placeholder(1:natdigits);
    
    tempstr = regexprep(curpath,['\d+'], placeholder);
    
    ind     = strfind(tempstr, placeholder);
    
    % Replace numbers
    for j = 1:numel(numbers)
        
        newnum = [num2str(zeros(1, natdigits-numel(numbers{j}))) numbers{j}];
        newnum = strrep(newnum,' ', '');
        
        tempstr(ind(j):(ind(j)+natdigits-1)) = newnum;
    end