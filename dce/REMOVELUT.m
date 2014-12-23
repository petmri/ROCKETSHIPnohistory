function [handles, errormsg] = REMOVELUT(handles,  toberemoved);

errormsg = '';

LUT = handles.LUT;
subjectID = handles.subjectID;
filelist  = handles.filelist;
sortlist  = handles.sortlist;
%rootname  = handles.rootname;

if numel(find(LUT == 0)) == numel(LUT)
else
    
    for i = 1:size(toberemoved,1)
        
        curname = toberemoved(i,:);
        
        id = matchindex(curname, filelist);
        
        LUT = updateLUT(id,LUT);
        
        filelist(id) = [];
        sortlist(id) = [];
        subjectID(id)= [];
    end
    
    % Update rootname in case it has changed.
    rootname = findrootname(subjectID, '');
    handles.LUT = LUT;
    handles.subjectID = subjectID;
    handles.rootname = rootname;
    handles.filelist = filelist;
    handles.sortlist = sortlist;
end
