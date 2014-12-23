function out = isNIFTI(imagefile)

try
    info = load_nii(imagefile);
    out  = 1;
catch
    out = 0;
end