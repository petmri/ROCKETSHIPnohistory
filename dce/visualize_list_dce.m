
% Remove dir info to allow nice visualization, DCE version
function [handles, errormsg] = visualize_list_dce(handles, p1,p2,p3)
errormsg = '';
warning off

visual_listA = [];
visual_listB = [];
visual_listC = [];


LUT = handles.LUT
%subjectID = handles.subjectID;
filelist  = handles.filelist;
%sortlist  = handles.sortlist;
rootname  = handles.rootname;
filevolume= get(handles.filevolume, 'Value');

if numel(filelist) == 0
    
    set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
    set(handles.DCEfilesB, 'String', visual_listB, 'Value', 1, 'Enable', 'off');
    set(handles.DCEfilesC, 'String', visual_listC, 'Value', 1, 'Enable', 'off');
    set(handles.rootnameA, 'String', rootname);
    return;
end

sizer = longestfilename(filelist);

for i = 1:size(LUT,1)

    for j = 1:size(LUT,2)
    
        if LUT(i,j) > 0
            [~, namer, ~] = fileparts(filelist{LUT(i,j)});
            if numel(namer) < sizer
                namer = [namer blanks(sizer-numel(namer))];
            end
            
            if j == 1
                maxpad = numel(num2str(numel(filelist)));
                pad = [blanks(maxpad-numel(num2str(numel(find(LUT(i,:) > 0))))) num2str(numel(find(LUT(i,:) > 0)))];
                namerB = [namer ' --> ' pad ' files'];
                
                subsetnofiles(i) = numel(find(LUT(i,:) > 0));
                
                if isempty(visual_listB)
                    visual_listB = namerB;
                else
                    visual_listB = [visual_listB; namerB];
                end
            end
            if isempty(visual_listA)
                visual_listA = namer;
            else
                visual_listA = [visual_listA; namer];
            end
            
            if i == p2
                if isempty(visual_listC)
                    visual_listC = namer;
                else
                    visual_listC = [visual_listC; namer];
                end
            end
        end
    end
    
    
    
end

set(handles.DCEfilesA, 'String', visual_listA, 'Value', p1);
set(handles.DCEfilesB, 'String', visual_listB, 'Value', p2);
set(handles.DCEfilesC, 'String', visual_listC, 'Value', p3);
set(handles.rootnameA, 'String', rootname);

if size(LUT,2) > 1 && size(LUT, 1) > 1
    filevolume = 3;
    set(handles.filevolume, 'Value', 3);
elseif xor(size(LUT,1) > 1,size(LUT,2) > 1)
    filevolume = 2;
    set(handles.filevolume, 'Value', 2);
else
    filevolume = 1;
    set(handles.filevolume, 'Value', 1);
end

if filevolume < 2
    set(handles.DCEfilesB,  'Enable', 'off');
    set(handles.DCEfilesC,  'Enable', 'off');
    set(handles.DCEfilesBup, 'Enable', 'off');
    set(handles.DCEfilesBdown, 'Enable', 'off');
    set(handles.DCEfilesCup, 'Enable', 'off');
    set(handles.DCEfilesCdown, 'Enable', 'off');
elseif filevolume < 3
    set(handles.DCEfilesC,  'Enable', 'off');
    set(handles.DCEfilesCup, 'Enable', 'off');
    set(handles.DCEfilesCdown, 'Enable', 'off');
    set(handles.DCEfilesB,  'Enable', 'on');
    set(handles.DCEfilesBup, 'Enable', 'on');
    set(handles.DCEfilesBdown, 'Enable', 'on');
else
    set(handles.DCEfilesC,  'Enable', 'on');
    set(handles.DCEfilesCup, 'Enable', 'on');
    set(handles.DCEfilesCdown, 'Enable', 'on');
    set(handles.DCEfilesB,  'Enable', 'on');
    set(handles.DCEfilesBup, 'Enable', 'on');
    set(handles.DCEfilesBdown, 'Enable', 'on');
end



% Check if the subsets file numbers are same or different. Return error tag
% if not
for i = 2:numel(subsetnofiles)
    
    if subsetnofiles(i) ~= subsetnofiles(i-1)
        % Alert user that the subsets are different
        errormsg = 'Subsets have diff # of files';
        return
    else
        errormsg = '';
    end
end
%Check file volume % MAY NEED TO FIX THIS ERROR CHECK
% if filevolume == 1
%     if numel(subsetnofiles) > 1
%         errormsg = [errormsg '+ too many for file type'];
%     end
% elseif filevolume == 2
%     if sum(subsetnofiles) ~= subsetnofiles
%         errormsg = [errormsg '+ too many for file type'];
%     end
% elseif filevolume == 3
%     
%     if sum(subsetnofiles) == numel(subsetnofiles)
%         errormsg = [errormsg '+ too many for file type'];
%     end
% end





