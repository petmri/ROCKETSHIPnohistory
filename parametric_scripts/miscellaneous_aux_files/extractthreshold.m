%Extract ROI
%Aim to extract ROI from an Analyze Image. 
%[roisize, mean1, filename,roifilename, roiname] = extractroi(imagename, roi)
% Given an NifTI image, and a NifTI image of the ROI in question, 
%extractroi writes a new file with only the extracted ROI in question
%removed from the original image file. The function also returns the number
%of pixels in this ROI, the mean intensity value, name of the original file
%and the name of the newly written file. (Uncomment below to write to a new
%path, otherwise the default is to write in the same directory as original
%file

function [roisize, mean1, filename, roifilename, roiname, stdev] = extractthreshold(imagename);
 
 %load the Analyze image
 [nii] = load_nii(imagename);
 image = nii.img;
 

 sizeofroi = size(image);
  roisize = 0;
 
 filename = nii.fileprefix;
 x = sizeofroi(1);
 y = sizeofroi(2);
 z = sizeofroi(3);
 
 %Threshold to include
 threshold = 0.9;
 
 %ROI extracted name
 roiname = strcat(imagename, 'roiextracted');
 roifilename = strcat(filename, 'roiextracted');
 
 extractedimage = zeros(x,y,z);

 %Error check to make sure the ROI matches the image.
 %Scroll through all the pixels and extract if it is part of ROI.
 for i=1:x
     for j=1:y
         for k=1:z
             currentpixel = image(i,j,k);
             
             
             %match = xor(currentpixel, currentroi);
             
             if (currentpixel > 0)
                 %There is a match!
                 extractedimage(i,j,k) = 10000000;
                 roisize = roisize + 1;
             else%Disregard and make black
             end
             if (currentpixel == 0)
                 
             end
         end
     end
 end
 
 mean1 = sum(sum(sum(extractedimage)))/roisize;
 
 extractedimaged = extractedimage(:);
 
 stdev = std(extractedimaged);
 
 %Write the new image into the space and save
 newnii = make_nii(extractedimage);
 
 %roi.img = extractedimage;
 %roi.fileprefix = roifilename;
 %j = view_nii(roi);
 
 %Uncomment the following if you want to save the files in a new path:
 %roiname = strcat('INSERT PATH HERE', roiname);
 %save_nii(roi, roiname);
 save_nii(newnii, roiname);

end
 
%Thomas Ng (thomasn@caltech.edu)
%4th December, 2006
 
 