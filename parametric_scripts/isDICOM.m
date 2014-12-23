function out = isDICOM(imagefile)

try
    info = dicominfo(imagefile);
    out  = 1;
catch
    out = 0;
end