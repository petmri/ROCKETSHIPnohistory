%[masterlist] = intensityscale(dirpath, roi)
%The intensity of the images are scaled such that the highest tissue part of the
%image is consistent through out the data set. (We know that 0 or close to  is black).
%The brightest is examined only within the ROI mask we input. Outpud gives
%you a list of maximum values data and the name of the corresponding file.
function [masterlist] = intensityscale(dirpath, roi)

roi;

 realpath = strcat(dirpath, '*.hdr');
 listoffiles = ls(realpath);
 sizer = size(listoffiles);
 length1 = sizer(1);
 
 %masterlist.niimageset = zeros(1, length1);
 masterlist.maxhist = zeros(1, length1);
 masterlist.roiname = zeros(1, length1);
 masterlist.filtername = zeros(1, length1);
 
 %Extract necessary data
 for i=1:length1
     currentpath = strcat(dirpath, listoffiles(i,:));
     [b, c, d] = extracttissuemaxroi(currentpath, roi);
   
     
     if (i == 1)
         masterlist.curpath = currentpath;
         masterlist.maxhist(1,i) = b;
         masterlist.roiname = c;
         masterlist.filtername = d;
     else
         masterlist.curpath = strvcat(masterlist.curpath, currentpath);
         masterlist.maxhist(1,i) = b;
         masterlist.roiname = strvcat(masterlist.roiname, c);
         masterlist.filtername = strvcat(masterlist.filtername, d);
         
     end
       masterlist;
 end
 
 %load the ROI image
 [g] = load_nii(roi);
 roiimage = g.img;
 
 %find maximum value as the template
masterlist.maxhist;
 y = max(masterlist.maxhist);
 
 %Scale each image and write new
 %UNCOMMENT FOR FUTURE
 for i=1:length1
     
     dirpath ;
     listoffiles(i,:);
     currentpath = strcat(dirpath, listoffiles(i,:));
     [nii] = load_nii(currentpath);     
  
     h = nii.img;
      
 filteredset = h.*roiimage;
 
  %Rescale image so that the smallest intensity value is 0
 min_value = min(min(min(filteredset)));
 
 h = h + abs(min_value);
    
     
     maxa = masterlist.maxhist(1,i);
    % maxa = max(max(max(h)));
     
     h = h*(y/maxa);
     
     nii.img = h;
     
     save_nii(nii, masterlist.roiname(i,:));
 end
 
 %Perform unsharp filtering
 %{
 realpath1 = strcat(dirpath, '*scaled.hdr');
 listoffiles1 = ls(realpath1);
 sizer1 = size(listoffiles1);
 length2 = sizer1(1);
 
 sharpFilter = fspecial('unsharp', 0.2);
 
  for i=1:length2
     currentpath = strcat(dirpath, listoffiles1(i,:))
     [nii] = load_nii(currentpath);     
  
     h = nii.img;
     
     sharp = imfilter(h, sharpFilter, 'conv');
      
     nii.img = sharp;
     
     save_nii(nii, masterlist.filtername(i,:));
 end
 
end
%}
     
  
 

     
     