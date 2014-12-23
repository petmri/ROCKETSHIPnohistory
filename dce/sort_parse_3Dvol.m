function [subjectID, handles] = sort_parse_3Dvol(fullpath, handles, rootname);

if isempty(rootname)
    subjectID = finduniqueID(fullpath);
else
    subjectID = rootname;
end
%Either time or slices. We sort by first number after the subject ID

%number of digits to have in order to facilitate natural
%order sorting

natdigits = 6;

[sortedfullpath, sort_list] = sort_parse_3Dvol_helper(subjectID, fullpath, natdigits);

for i = 1:numel(sortedfullpath);
    handles.batchdata(i).files = sortedfullpath(i);
end







