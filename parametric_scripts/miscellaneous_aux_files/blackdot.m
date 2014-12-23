%Extract Black dots (Likely Plaques)
%Given an image and a corresponding roi, we try to determine the number of
%blackdots, or voxels under a threshold as defined in the roi of interest.

function [numplaque] = blackdot(imagename, roi);

%choose threshold
threshold = 12000;

numplaque = 0;

 %load the Analyze image
 [nii] = load_nii(imagename);
 image = nii.img;
 
 %load the ROI image
 [roi] = load_nii(roi);
 roiimage = roi.img;
 roisize = 0;
 
 sizeofroi = size(roiimage);
 
 filename = nii.fileprefix;
 x = sizeofroi(1);
 y = sizeofroi(2);
 z = sizeofroi(3);
 
 
 %Error check to make sure the ROI matches the image.
 %Scroll through all the pixels and extract if it is below the threshold.
 for i=1:x
     for j=1:y
         for k=1:z
             currentpixel = image(i,j,k);
             currentroi = roiimage(i,j,k);
             
             %match = xor(currentpixel, currentroi);
             
             if (currentroi ~= 0)
                 %There is a match we need to check if it's a darkspot!
                 if(currentpixel <= threshold)
                     numplaque = numplaque + 1;
                 else
                 end
             else%Disregard and make black
             end
            
         end
     end
 end
 
 
end
 
%Thomas Ng (thomasn@caltech.edu)
%14th December, 2006
 
 