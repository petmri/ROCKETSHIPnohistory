function [handles, errormsg] = update_segmentlist(handles, fullpath, levels)
%Depending on which listbox window (levels) is calling this,
%update_segmentlist will either attempt to sort through the fullpath and
%split the input files accordingly or update the file ordering.
errormsg = '';
% Adding files to the mix

filevolume = get(handles.filevolume, 'Value');

if levels == 1
    %Initialize
    if filevolume == 1
        % 4D volume, nothing to do, just update GUI
        
        handles.batchdata(1).files = fullpath;
        
        [visual_listA, ~, ~] = visualize_list_dce(handles, filevolume);
        set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
    elseif filevolume == 2
        % 3D volumes
        
        % Check if there are more than 1 file in the volume, if not, then
        % return
        
        if numel(fullpath) < 2 && numel(handles.batchdata) < 2
            errormsg = 'Not enough files defined for 3D volume.';
            return;
        end
        
        % Check if subject rootname defined, if not, then try to figure out
        % the root
        
        rootnameA = get(handles.rootnameA, 'Enable');
        
        if strcmp(rootnameA, 'off')
            
            [subjectID, handles] = sort_parse_3Dvol(fullpath, handles, '');
        else
            [subjectID, handles] = sort_parse_3Dvol(fullpath, handles, get(handles.rootnameA, 'String'));
        end
        
        [visual_listA, visual_listB, ~] = visualize_list_dce(handles,filevolume);
        
        set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
        set(handles.DCEfilesB, 'Enable', 'on');
        set(handles.DCEfilesB, 'String', visual_listB, 'Value', 1);
        set(handles.DCEfilesBup, 'Enable', 'on');
        set(handles.DCEfilesBdown, 'Enable', 'on');
        set(handles.rootnameA, 'Enable', 'on');
        set(handles.rootnameA, 'String', subjectID);
        
    elseif filevolume == 3
        % 2D volumes
        
         % Check if there are more than 1 file in the volume, if not, then
        % return
        
        if numel(fullpath) < 2 && numel(handles.batchdata) < 2
            errormsg = 'Not enough files defined for 2D volume.';
            return;
        end
        
        % Check if subject rootname defined, if not, then try to figure out
        % the root
        
        rootnameA = get(handles.rootnameA, 'Enable');
        
        if strcmp(rootnameA, 'off')
            [subjectIDA, handles, errormsg] = sort_parse_2Dvol(fullpath, handles, '', '');
        else
            [subjectIDA, handles, errormsg] = sort_parse_2Dvol(fullpath, handles, get(handles.rootnameA, 'String'));
        end
        
        [visual_listA, visual_listB, visual_listC] = visualize_list_dce(handles,filevolume);
        
        set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
        set(handles.DCEfilesB, 'Enable', 'on');
        set(handles.DCEfilesB, 'String', visual_listB, 'Value', 1);
        set(handles.DCEfilesBup, 'Enable', 'on');
        set(handles.DCEfilesBdown, 'Enable', 'on');
        set(handles.DCEfilesC, 'String', visual_listC, 'Value', 1);
        set(handles.DCEfilesCup, 'Enable', 'on');
        set(handles.DCEfilesCdown, 'Enable', 'on');
        set(handles.rootnameA, 'Enable', 'on');
        set(handles.rootnameA, 'String', subjectIDA);
    else
        % Selection error
        errormsg = 'Volume type undefined';
    end
elseif levels == 2
    
    % No need to sort, just prep to visualize
    
    if filevolume == 1
        % 4D volume, nothing to do, just update GUI
        
        [visual_listA, visual_listB, visual_listC] = visualize_list_dce(handles, filevolume);
        set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
        set(handles.DCEfilesB, 'String', visual_listB, 'Value', 1);
        set(handles.DCEfilesC, 'String', visual_listC, 'Value', 1);
        set(handles.DCEfilesB, 'Enable', 'off');
        set(handles.DCEfilesC, 'Enable', 'off');
    elseif filevolume == 2
        % 3D volumes
        
         % Check if there are more than 1 file in the volume, if not, then
        % return
        
        if numel(fullpath) < 2 && numel(handles.batchdata) < 2
            errormsg = 'Not enough files defined for 3D volume.';
            
            [visual_listA, visual_listB, visual_listC] = visualize_list_dce(handles, filevolume);
        set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
        set(handles.DCEfilesB, 'String', visual_listB, 'Value', 1);
        set(handles.DCEfilesC, 'String', visual_listC, 'Value', 1);
        set(handles.DCEfilesB, 'Enable', 'off');
 
            return;
        end

        [visual_listA, visual_listB, ~] = visualize_list_dce(handles,filevolume);
        
        set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
        set(handles.DCEfilesB, 'Enable', 'on');
        set(handles.DCEfilesB, 'String', visual_listB, 'Value', 1);
        set(handles.DCEfilesBup, 'Enable', 'on');
        set(handles.DCEfilesBdown, 'Enable', 'on');
        set(handles.rootnameA, 'Enable', 'on');
        set(handles.rootnameA, 'String', subjectID);
        
    elseif filevolume == 3
        % 2D volumes
        
         % Check if there are more than 1 file in the volume, if not, then
        % return
        
        if numel(fullpath) < 2 && numel(handles.batchdata) < 2
            errormsg = 'Not enough files defined for 2D volume.';
            
            [visual_listA, visual_listB, visual_listC] = visualize_list_dce(handles, filevolume);
        set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
        set(handles.DCEfilesB, 'String', visual_listB, 'Value', 1);
        set(handles.DCEfilesC, 'String', visual_listC, 'Value', 1);
        set(handles.DCEfilesB, 'Enable', 'off');

            return;
        end
        
        [visual_listA, visual_listB, visual_listC] = visualize_list_dce(handles,filevolume);
        
        set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
        set(handles.DCEfilesB, 'Enable', 'on');
        set(handles.DCEfilesB, 'String', visual_listB, 'Value', 1);
        set(handles.DCEfilesBup, 'Enable', 'on');
        set(handles.DCEfilesBdown, 'Enable', 'on');
        set(handles.DCEfilesC, 'String', visual_listC, 'Value', 1);
        set(handles.DCEfilesCup, 'Enable', 'on');
        set(handles.DCEfilesCdown, 'Enable', 'on');
        set(handles.rootnameA, 'Enable', 'on');
        set(handles.rootnameA, 'String', subjectIDA);
    else
        % Selection error
        errormsg = 'Volume type undefined';
    end
elseif levels == 3
    
    % Updated filevolume/rootname, need to redo the sort again
    
    fullpath = generatefullpath(handles);
    
     if filevolume == 1
        % 4D volume, nothing to do, just update GUI
        
        %handles.batchdata(1).files = fullpath;
        
        if numel(fullpath) > 1
            errormsg = 'More than 1 file present';
            return;
        end
        
        [visual_listA, visual_listB, visual_listC] = visualize_list_dce(handles, filevolume);
        set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
        set(handles.DCEfilesB, 'String', visual_listB, 'Value', 1);
        set(handles.DCEfilesC, 'String', visual_listC, 'Value', 1);
        set(handles.DCEfilesB, 'Enable', 'off');
        set(handles.DCEfilesC, 'Enable', 'off');
    elseif filevolume == 2
        % 3D volumes
         % Check if there are more than 1 file in the volume, if not, then
        % return
        
        if numel(fullpath) < 2 && numel(handles.batchdata) < 2
            errormsg = 'Not enough files defined for 3D volume.';
            
            return
            [visual_listA, visual_listB, visual_listC] = visualize_list_dce(handles, filevolume);
        set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
        set(handles.DCEfilesB, 'String', visual_listB, 'Value', 1);
        set(handles.DCEfilesC, 'String', visual_listC, 'Value', 1);
        set(handles.DCEfilesB, 'Enable', 'off');

            return;
        end
        
        % Check if subject rootname defined, if not, then try to figure out
        % the root
        
        rootnameA = get(handles.rootnameA, 'Enable');
        
        if strcmp(rootnameA, 'off')
            
            [subjectID, handles] = sort_parse_3Dvol(fullpath, handles, '');
        else
            [subjectID, handles] = sort_parse_3Dvol(fullpath, handles, get(handles.rootnameA, 'String'));
        end
        
        [visual_listA, visual_listB, ~] = visualize_list_dce(handles,filevolume);
        
        set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
        set(handles.DCEfilesB, 'Enable', 'on');
        set(handles.DCEfilesB, 'String', visual_listB, 'Value', 1);
        set(handles.DCEfilesBup, 'Enable', 'on');
        set(handles.DCEfilesBdown, 'Enable', 'on');
        set(handles.rootnameA, 'Enable', 'on');
        set(handles.rootnameA, 'String', subjectID);
        
    elseif filevolume == 3
        % 2D volumes
        
         % Check if there are more than 1 file in the volume, if not, then
        % return
        
        if numel(fullpath) < 2 && numel(handles.batchdata) < 2
            errormsg = 'Not enough files defined for 2D volume.';
     
            return
        elseif numel(handles.batchdata) < 2
            errormsg = 'Not enough files defined for 2D volume';
            return
        end
%             [visual_listA, visual_listB, visual_listC] = visualize_list_dce(handles, filevolume);
%         set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
%         set(handles.DCEfilesB, 'String', visual_listB, 'Value', 1);
%         set(handles.DCEfilesC, 'String', visual_listC, 'Value', 1);
            return;
        end
        % Check if subject rootname defined, if not, then try to figure out
        % the root
        
        rootnameA = get(handles.rootnameA, 'Enable');
        
        if strcmp(rootnameA, 'off')
            [subjectIDA, handles, errormsg] = sort_parse_2Dvol(fullpath, handles, '', '');
        else
            [subjectIDA, handles, errormsg] = sort_parse_2Dvol(fullpath, handles, get(handles.rootnameA, 'String'));
        end
        
        [visual_listA, visual_listB, visual_listC] = visualize_list_dce(handles,filevolume);
        
        set(handles.DCEfilesA, 'String', visual_listA, 'Value', 1);
        set(handles.DCEfilesB, 'Enable', 'on');
        set(handles.DCEfilesB, 'String', visual_listB, 'Value', 1);
        set(handles.DCEfilesBup, 'Enable', 'on');
        set(handles.DCEfilesBdown, 'Enable', 'on');
        set(handles.DCEfilesC, 'String', visual_listC, 'Value', 1);
        set(handles.DCEfilesCup, 'Enable', 'on');
        set(handles.DCEfilesCdown, 'Enable', 'on');
        set(handles.rootnameA, 'Enable', 'on');
        set(handles.rootnameA, 'String', subjectIDA);
    else
        % Selection error
        errormsg = 'Volume type undefined';
    end
    
    
    
end





