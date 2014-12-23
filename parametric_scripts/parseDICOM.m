function [infodc, image_3d, res, sortedsliceloc] = parseDICOM(imagefile);

if isdir(imagefile)
    % 3D array list of files
    
    listfiles = dir(imagefile);
    
    %1. Load
    totaldicom = 0;
    firstid    = '';
    dicomnames = '';
    dicomsliceloc=[];
    res = [];
    
    for i = 1:numel(listfiles)
        
        try
            infodc = dicominfo(fullfile(imagefile, listfiles(i).name));
            
            % Is a dicom file
            totaldicom = totaldicom + 1;
            
            dicomnames(totaldicom).name = fullfile(imagefile, listfiles(i).name);
            
            twod = infodc.(dicomlookup('28', '30'));
            slice= infodc.(dicomlookup('18','50'));
            
            sliceloc = infodc.(dicomlookup('20', '1041'));
            
            infodes  = infodc.(dicomlookup('8', '1030'));
            
            curres(1,1) = twod(1);
            curres(1,2) = twod(2);
            curres(1,3) = slice;
            
            dicomsliceloc(totaldicom) = sliceloc;
            
            if isempty(firstid)
                % Assume first DICOM file is real
                firstid = infodes;
                res(1,1) = twod(1);
                res(1,2) = twod(2);
                res(1,3) = slice;
            else
                if strcmp(firstid, infodes) && isequal(res, curres)
                    % Seems to be part of same image volume
                else
                    dicomnames(totaldicom) = [];
                    dicomsliceloc(totaldicom)=[];
                    totaldicom = totaldicom -1;
                    
                end
            end
            
            
            
        catch
            
        end
    end
    
    % Sort sliceloc
    sortedsliceloc = sort(dicomsliceloc, 'ascend');
        
    for i = 1:numel(sortedsliceloc)
        ind = dicomsliceloc == sortedsliceloc(i);
        
        image_3d(:,:,i) = dicomread(dicomnames(ind).name);
    end
  
else
    %2D
    
    infodc = dicominfo(imagefile);
    
    twod = infodc.(dicomlookup('28', '30'));
    slice= infodc.(dicomlookup('18','50'));
    
    res(1,1) = twod(1);
    res(1,2) = twod(2);
    res(1,3) = slice;
    
    sortedsliceloc = infodc.(dicomlookup('20', '1041'));
    image_3d = dicomread(infodc);
end