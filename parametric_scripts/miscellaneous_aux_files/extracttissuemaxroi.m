%Extract Tissue Max ROI
%Aim to extract max intensity value from ROI from an Analyze Image. 


function [maxvalue, roiname, filtername] = extracttissuemaxroi(imagename, roi)
 
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
 
 %Filter name
 filtername = strcat(filename, 'conv_filter');
 %roifilename = strcat('scaled', filename);
 
 %UNCOMMENT
 filteredset = imagesetimg.*roiimage;
 
 %Rescale image so that the smallest intensity value is 0
 min_value = min(min(min(filteredset)));
 
 filteredset = filteredset + abs(min_value);
 
 [no,g] = hist(filteredset(:),1000);
 
 [peaks,troughs] = peakdet(no, 100);
 %%%
 
 %% whether data is ok..
if ( size(peaks, 1) < 2)
    fprintf('Data supposed to have 2 peaks. One near zero and one normal image peak. Cant find. Quitting');
   % return
end

peak1 = peaks(1,1);
peak2 = peaks(2,1);
trough1 = troughs(1,1);

if peak1 < trough1 && trough1 < peak2
    hist_y = no(trough1:end);
    hist_x = g(trough1:end);
else
    fprintf('poorly formed data. Hopefully will be supported in future versions');
    return
end

maxhist = max(hist_y);

indexnumber = find(hist_y >= maxhist);

g = size(indexnumber);
indices = g(2);
indexnumber = indexnumber(indices);

maxfilter = hist_x(indexnumber);

 
% maxfilter = max(max(max(filteredset)));
 
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
 
 