%Squish Image

function [filename, roifilename, roiname] = squishimage(imagename);
 
 %load the Analyze image
 [nii] = load_nii(imagename);
 image = nii.img;
 
 %load the ROI image
 %[roi] = load_nii(roi);
 %roiimage = roi.img;
 %roisize = 0;
 
 sizeofimage = size(image);
 
 filename = nii.fileprefix;
 x = sizeofimage(1)
 y = sizeofimage(2)
 z = sizeofimage(3)
 
 %ROI extracted name
 roiname = strcat(imagename, 'compressed');
 roifilename = strcat(filename, 'compressed');
 
 extractedimage = zeros(x, floor(y/2),z);

 %Error check to make sure the ROI matches the image.
 %Scroll through all the pixels and extract if it is part of ROI.
 for i=1:x
     for k = 1:z
         for j=1:2:floor(y/2)*2 
             j;
             currentpixel = image(i,j,k);
             nextpixel = image(i,j+1 ,k);
             
             newpixel = (currentpixel + nextpixel)/2;
             
             extractedimage(i,ceil(j/2),k) = newpixel;
         end
     end
 end
 
 %Write the new image into the space and save
 newnii = make_nii(extractedimage);
 
 %roi.img = extractedimage;
 %roi.fileprefix = roifilename;
 %j = view_nii(roi);
 
 %Uncomment the following if you want to save the files in a new path:
 %roiname = strcat('INSERT PATH HERE', roiname);
 save_nii(newnii, roiname);
 

end
 
%Thomas Ng (thomasn@caltech.edu)
%13th December, 2006
 