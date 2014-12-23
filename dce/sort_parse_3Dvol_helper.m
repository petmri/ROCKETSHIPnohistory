function [sortedfullpath, sort_list] = sort_parse_3Dvol_helper(subjectID, fullpath, natdigits)

for i = 1:numel(fullpath)
    curpath = fullpath{i};
    
    [~, filename, ~] = fileparts(curpath);
    
    curpath = strrep(filename, subjectID, '');
    
    %Find all the numbers in the curpath
    
    numbers = regexp(curpath,['\d+'], 'match');
    
   placeholder = num2str(round(rand(1)*10^natdigits));
    
    tempstr = regexprep(curpath,['\d+'], placeholder);
    
    ind     = strfind(tempstr, placeholder);
    
    % Replace numbers 
    for j = 1:numel(numbers)
        
        newnum = [num2str(zeros(1, natdigits-numel(numbers{j}))) numbers{j}];
        newnum = strrep(newnum,' ', '');

        tempstr(ind(j):(ind(j)+natdigits-1)) = newnum;
    end
    
    editlist{i} = [subjectID tempstr];
end

% Now sort the list

[sort_list, ind] = sort(editlist);%, 'ascend');

for i = 1:numel(fullpath)
    sortedfullpath(i) = fullpath(ind(i));
end





    
        
    
    
    
   
        
        
    
    