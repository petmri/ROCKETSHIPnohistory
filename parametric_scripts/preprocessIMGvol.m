function [filename, fullpath, errormsg] = preprocessIMGvol()

errormsg = '';

[filename, pathname, filterindex] = uigetfile( ...
        { '*.nii','Nifti Files (*.nii)'; ...
        '*.hdr;*.img','Analyze Files (*.hdr, *.img)'; 'DICOM Files (*.dcm)';...
        '*.*',  'All Files (*.*)'}, ...
        'Pick files belonging to same image volume ', ...
        'MultiSelect', 'on');
    
    

    
    
   


