function subjectID = finduniqueID_B_helper(current, subjectIDA, pre);

if isempty(pre)
    %initialize
    subjectID = strrep(current, subjectIDA, '');
else
    %Search through the whole string of pre to find the longest contiguous
    %string that is found is current
    
    pre = strrep(pre, subjectIDA, '');
    current = strrep(current, subjectIDA, '');
    
    IDlength = 0;
    
    for i = 1:numel(pre)
        
        for j = i:numel(pre)
            
            compstr = pre(i:j);
            
            ans = strfind(current, compstr);
            
            if ~isempty(ans)
                ans = compstr;
            end
            
            if length(ans) > IDlength
                subjectID = ans;
                IDlength = length(ans);
            else
            end
        end
    end
end
    
    