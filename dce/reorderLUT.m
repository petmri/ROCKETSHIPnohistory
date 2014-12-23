function [handles] = reorderLUT(handles, up, dim);

LUT = handles.LUT;

if dim == 1
    % Switch up DCEB
     DCEB = get(handles.DCEfilesB, 'Value');
    
    if up
       
        if DCEB == 1
            % At the top, do nothing
        else
            currow = LUT(DCEB, :);
            uprow  = LUT(DCEB-1,:);
            
            LUT(DCEB-1,:) = currow;
            LUT(DCEB,:)   = uprow;
            set(handles.DCEfilesB, 'Value', DCEB-1);
        end
    else
        % Down
        if DCEB == size(LUT,1)
            % At the bottom, do nothing
        else
            currow = LUT(DCEB,:);
            downrow= LUT(DCEB+1,:);
            
            LUT(DCEB+1,:) = currow;
            LUT(DCEB,:)   = downrow;
             set(handles.DCEfilesB, 'Value', DCEB+1);
        end
    end
else
    % Switch up DCEC
    DCEB = get(handles.DCEfilesB, 'Value');
    DCEC = get(handles.DCEfilesC, 'Value');
    
    if up
        if DCEC == 1
            % At the top, do nothing
        else
       
            curind = LUT(DCEB, DCEC);
            upind  = LUT(DCEB, DCEC-1);
            
            LUT(DCEB, DCEC) = upind;
            LUT(DCEB, DCEC-1) = curind;
            set(handles.DCEfilesC, 'Value', DCEC-1);
        end
    else
        % Down
        
         if DCEC == size(LUT,2)
            % At the bottom, do nothing
         else
            
            curind = LUT(DCEB, DCEC);
            downind  = LUT(DCEB, DCEC+1);
            
            LUT(DCEB, DCEC) = downind;
            LUT(DCEB, DCEC+1) = curind;
            set(handles.DCEfilesC, 'Value', DCEC+1);
         end
    end
end
         
handles.LUT = LUT;       
       
        
        


