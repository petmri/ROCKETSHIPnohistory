%Extract Max ROI
%Aim to extract max intensity value from ROI from an Analyze Image. 


function [maxvalue, roiname] = extractmaxroi(imagename, roi)
 
 %load the Analyze image
 [nii] = load_nii(imagename);
 imageset = nii;
 imagesetimg = imageset.img;
 
 %load the ROI image
 [roi] = load_nii(roi);
 roiimage = roi.img;
 
 %scale value of ROI
 maxroi = max(max(max(roiimage)));
 
 maxvalue = 0;
 
 sizeofroi = size(roiimage);
 
 filename = nii.fileprefix;
 x = sizeofroi(1);
 y = sizeofroi(2);
 z = sizeofroi(3);
 
 %ROI extracted name
 roiname = strcat(filename, 'scaled');
 %roifilename = strcat('scaled', filename);
 
 filteredset = imagesetimg.*roiimage;
 
 maxfilter = max(max(max(filteredset)));
 
 maxvalue = maxfilter/maxroi;
 
 %Error check to make sure the ROI matches the image.
 %Scroll through all the pixels and check to see if it is maxvalue intensity voxel if it is part of ROI.
 %for i=1:x
 %    for j=1:y
  %       for k=1:z
   %          currentpixel = image(i,j,k);
    %         currentroi = roiimage(i,j,k);
             
             %match = xor(currentpixel, currentroi);
             
     %        if (currentroi ~= 0)
                 %There is a match!
        %         maxvalue
      %           if(currentpixel>maxvalue)
                     %maxvalue = currentpixel
       %          else
         %        end
          %   else%Disregard
           %  end
            % if (currentroi == 0)
                 
             %end
         %end
     %end
 %send
end

%Thomas Ng (thomasn@caltech.edu)
%29th January 2007
 
 