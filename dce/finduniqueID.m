function [subjectID] = finduniqueID(fullpath)
errormsg = [];
subjectID = '';
for i = randperm(numel(fullpath)) % Randomly pick initializing file to minimize bias
    
    [~, filename, ~] = fileparts(fullpath{i});
    
    [subjectID, nomatch] = finduniqueIDhelper(filename, subjectID);
    
end

% if nomatch
%     fullpath(errormsg) = [];
%     errormsg = 'Files with no subject ID found, removed from queue';
% end