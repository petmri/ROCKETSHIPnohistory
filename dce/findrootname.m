function rootname = findrootname(subjectID, subjectID_current);


rootname = finduniqueID(subjectID);

for i = 1:numel(subjectID_current)
    
    rootname = finduniqueIDhelper(subjectID_current{i}, rootname);
end

