function [image_3d, res, hdr, inputft, errormsg] = load_image_files(curfiles);
errormsg = '';
if numel(curfiles) == 1
    % Image volume
    imagefile = curfiles{1};
    
    % Read file and get header information
    [file_path, filename, ext]  = fileparts(imagefile);
    
    if strcmp(ext, '.nii')
        nii = load_untouch_nii(imagefile);
        res = nii.hdr.dime.pixdim;
        res = res(2:4);
        hdr = nii.hdr;
        image_3d = nii.img;
        
        inputft = 1;
    elseif strcmp(ext, '.img') || strcmp(ext, '.hdr')
        nii = load_untouch_nii(imagefile);
        res = nii.hdr.dime.pixdim;
        res = res(2:4);
        hdr = nii.hdr;
        image_3d = nii.img;
        
        inputft = 1;
    elseif isDICOM(imagefile)
        hdr = dicominfo(imagefile);
        res(1:2) = hdr.(dicomlookup('28', '30'));
        res(3)   = hdr.(dicomlookup('18', '50'));
        
        image_3d = dicomread(hdr);
        
        image_3d = rescaleDICOM(hdr, image_3d);
        inputft = 2;
    else
        errormsg = 'Unknown File type';
        return
    end
    
else
    % Need to combine all the slices
    
    for i = numel(curfiles):-1:1
        
        imagefile = curfiles{i};
        [file_path, filename, ext]  = fileparts(imagefile);
        if strcmp(ext, '.nii')
            nii = load_untouch_nii(imagefile);
            res = nii.hdr.dime.pixdim;
            res = res(2:4);
            hdr = nii.hdr;
            image_3d(:,:,i) = nii.img;
            inputft = 1;
        elseif strcmp(ext, '.img') || strcmp(ext, '.hdr')
            nii = load_untouch_nii(imagefile);
            res = nii.hdr.dime.pixdim;
            res = res(2:4);
            hdr = nii.hdr;
            image_3d(:,:,i) = nii.img;
            inputft = 1;
        elseif isDICOM(imagefile)
            hdr = dicominfo(imagefile);
            res(1:2) = hdr.(dicomlookup('28', '30'));
            res(3)   = hdr.(dicomlookup('18', '50'));
            
            if exist('hdr') && isfield(hdr, dicomlookup('20', '1041'))
                pos(i)   = hdr.(dicomlookup('20', '1041')); % Slice location
            else
                pos(i) = i;
            end
            %studyid(i)=hdr.(dicomlookup('20','10')); % Study ID
            
            image_3d(:,:,i) = dicomread(hdr);
            image_3d = rescaleDICOM(hdr, image_3d);
            inputft = 2;
        else
            errormsg = 'Unknown File type';
        end
    end
    
    % We assume NiFTI is slice ordered, but need to check DICOM
    
    if isDICOM(imagefile)
        
        sortpos = sort(pos);
        
        for i = 1:numel(curfiles)
            ind = pos == sortpos(i);
            newimage_3d(:,:,i) = image_3d(:,:,ind);
        end
        
        image_3d = newimage_3d;
        
        
    end
end





