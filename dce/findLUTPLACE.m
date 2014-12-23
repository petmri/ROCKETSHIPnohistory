function [row, col, NEW, DUP] = findLUTPLACE(LUT, sortlist, curname, cursubjectID, subjectID, rootname);
% We scroll through the LUT to find the right row with the same unique ID
% as the curname

row = 0;
col = 1;
NEW = 0;
DUP = 0;
cursubjectID = strrep(cursubjectID, rootname, '');

for j = 1:size(LUT,1)
    compID = subjectID{LUT(j,1)};
    compID = strrep(compID, rootname, '');
 
    [~, nomatch] = finduniqueIDhelperB(cursubjectID, compID);

    if ~nomatch
        row = j;
        comprow = LUT(j,:);
        
        for i = 1:numel(comprow)
            if LUT(row, i) ~= 0
                rownames{i} = sortlist{LUT(row,i)};
                
                if strcmp(rownames{i}, curname)
                    %Exact match,
                    row = j;
                    col = i;
                    DUP = 1;
                    return;
                end
            else
            end
        end
        
        rownames{end+1} = curname;
        
        [~, ind] = sort(rownames);
        
        col = find(ind == numel(ind));
        return;
        
    else
        
       subIDNAMES{j} = compID; 
    end
end

if nomatch
    % If subject is not part of the current set of IDs, we sort to find the
    % right place to put the new row.
    subIDNAMES{end+1} = cursubjectID;
    
    % Add digits to take care of natural order issues
    subIDNAMES = natORDER(subIDNAMES);
    
    
    [~, ind] = sort(subIDNAMES);
    
    NEW = 1;
    
    row = find(ind ==numel(ind));
end


    