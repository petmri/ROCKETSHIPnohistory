%NO GOOD IF USE TISSUE ONE
%[masterlist] = intensityscale(dirpath, roi)
%The intensity of the images are scaled such that the brightest part of the
%image is consistent through out the data set. (We know that 0 is black).
%The brightest is examined only within the ROI mask we input. Outpud gives
%you a list of maximum values data and the name of the corresponding file.
function [masterlist] = intensityscale(dirpath, roi)

 realpath = strcat(dirpath, '*.hdr');
 listoffiles = ls(realpath);
 sizer = size(listoffiles);
 length1 = sizer(1);
 
 %masterlist.niimageset = zeros(1, length1);
 masterlist.maxvalues = zeros(1, length1);
 masterlist.roiname = zeros(1, length1);
 
 %Extract necessary data
 for i=1:length1
     currentpath = strcat(dirpath, listoffiles(i,:));
     [b, c] = extractmaxroi(currentpath, roi);
     
     
     if (i == 1)
         masterlist.curpath = currentpath;
         masterlist.maxvalues(1,i) = b;
         masterlist.roiname = c;
     else
         masterlist.curpath = strvcat(masterlist.curpath, currentpath);
         masterlist.maxvalues(1,i) = b;
         masterlist.roiname = strvcat(masterlist.roiname, c);
         
     end
 end
 
 %find maximum value
masterlist.maxvalues
 y = max(masterlist.maxvalues)
 
 %Scale each image and write new
 
 for i=1:length1
     currentpath = strcat(dirpath, listoffiles(i,:))
     [nii] = load_nii(currentpath);     
  
     h = nii.img;
     maxa = max(max(max(h)));
     
     h = h*(y/maxa);
     
     nii.img = h;
     
     save_nii(nii, masterlist.roiname(i,:));
 end
end

     
  
 

     
     