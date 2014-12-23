function [subjectID, nomatch] = finduniqueIDhelper(current, pre)

nomatch = 0;


if isempty(pre)
    %initialize
    subjectID = current;
      IDlength = 1;
else
    
    %Search through the whole string of pre to find the longest contiguous
    %string that is found is current
    
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

if IDlength == 0
    %No match
    nomatch = 1;
    subjectID = '';
end
