function subsets = split2subsets(sortlist_origfilename, rootname);

tempsort_list = sortlist_origfilename;
subsettotal = 0;
subsets = [];


if numel(tempsort_list) == 1
    % There is only 1 file, no need to split any more
    subsets(1) = 1;
else
   
    while numel(tempsort_list) > 1
        
        pre = tempsort_list{1};
        post= tempsort_list{2};
        
        % Checks if the subject ID for each file is exactly the same as
        % rootname, if so, don't take out as there will be nothing to
        % compare.
        if ~strcmp(pre, rootname)
            pre = strrep(pre, rootname, '');
        end
        if ~strcmp(post, rootname)
            post= strrep(post, rootname, '');
        end
        
        % Find the unique string between the pre and pose filenames
        cursubjectID = finduniqueIDhelper(post, pre);
      
        % If the unique string is a number, most likely it's part of the
        % counter, so we reset cursubjectID to be '';
        
        if ~isempty(str2num(cursubjectID))
            cursubjectID = '';
        end

        if isempty(cursubjectID)
            % Empty, so pre and post belong to separate subsets
            subsets(end+1) = 1;
            subsettotal    = 0;
            tempsort_list(1) = [];
        else
            
            
            for i = 1:numel(tempsort_list)
                if ~isempty(strfind(tempsort_list{i}, cursubjectID))
                    subsettotal = subsettotal +1;
                end
            end
            subsets(end+1) = subsettotal;
            tempsort_list(1:subsettotal) = [];
            subsettotal = 0;
        end
    end
    
    % Add last one if still present
    if numel(tempsort_list) > 0
        subsets(end+1) = 1;
    end
    
end

            
    