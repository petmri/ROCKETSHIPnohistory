function out = isDICOMhdr(hdr)

out = 1;

try 
    
    g = dicomread(hdr);
catch
    out = 0;
end