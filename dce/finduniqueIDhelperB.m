function [subjectID, nomatch] = finduniqueIDhelperB(current, pre)

nomatch = 0;


if isempty(pre)
    %initialize
    subjectID = current;
    IDlength = 1;
else
    
    %Search through the whole string of pre from the front to find the longest contiguous
    %string that is found is current
    
    IDlength = 0;
    
    for i = 1:numel(pre)
        
        compstr = pre(1:i);
        
        if ~isempty(str2num(compstr))
            % string is just numbers, not counted as a filename match
        else
            
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
