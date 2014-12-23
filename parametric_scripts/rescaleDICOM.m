function newIMG = rescaleDICOM(hdr, image_3d)

try
    slope    = hdr.(dicomlookup('28', '1053'));
    inter    = hdr.(dicomlookup('28', '1052'));
    rescale = 1;
catch
    rescale = 0;
end

if rescale
    newIMG = double(image_3d.*slope+inter);
else
    newIMG = double(image_3d);
end
