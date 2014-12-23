%Extract Max ROI
%Aim to extract max intensity value from ROI from an Analyze Image. 


function [imageset, maxvalue, filename] = extractroi(imagename, roi);
 
 %load the Analyze image
 [nii] = load_nii(imagename);
 imageset = nii;
 
 %load the ROI image
 [roi] = load_nii(roi);
 roiimage = roi.img;
 maxvalue = 0;
 
 sizeofroi = size(roiimage);
 
 filename = nii.fileprefix;
 x = sizeofroi(1);
 y = sizeofroi(2);
 z = sizeofroi(3);
 
 %ROI extracted name
 roiname = strcat('scaled', imagename);
 roifilename = strcat('scaled', filename);
 

 %Error check to make sure the ROI matches the image.
 %Scroll through all the pixels and extract if it is part of ROI.
 for i=1:x
     for j=1:y
         for k=1:z
             currentpixel = image(i,j,k);
             currentroi = roiimage(i,j,k);
             
             %match = xor(currentpixel, currentroi);
             
             if (currentroi ~= 0)
                 %There is a match!
                 extractedimage(i,j,k) = currentpixel;
                 roisize = roisize + 1;
             else%Disregard and make black
             end
             if (currentroi == 0)
                 
             end
         end
     end
 end
 
 mean1 = sum(sum(sum(extractedimage)))/roisize;
 
 extractedimaged = extractedimage(:);
 
 stdev = std(extractedimaged);
 
 %Write the new image into the space and save
 newnii = make_nii(extractedimage);
 
 roi.img = extractedimage;
 roi.fileprefix = roifilename;
 %j = view_nii(roi);
 
 %Uncomment the following if you want to save the files in a new path:
 %roiname = strcat('INSERT PATH HERE', roiname);
 %save_nii(roi, roiname);
 save_nii(newnii, roiname);

end
 
%Thomas Ng (thomasn@caltech.edu)
%4th December, 2006
 
 