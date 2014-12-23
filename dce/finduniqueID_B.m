function subjectIDB = finduniqueID_B(fullpath, subjectIDA);

subjectIDB = '';

for i = 1:numel(fullpath)
    [~, filename, ~] = fileparts(fullpath{i});
    subjectIDB = finduniqueID_B_helper(filename, subjectIDA, subjectIDB);
end
