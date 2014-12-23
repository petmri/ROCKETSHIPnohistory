function [dirpath] = rescale(dirpath)

    a = dirpath.curpath;
    b = dirpath.maxvalues
    c = dirpath.roiname
    
     y = max(b)
     
     sizer = size(a);
     length1 = sizer(1)
 
 %Scale each image and write new
 
 for i=1:length1
     a(i,:)
     [nii] = load_nii(a(i,:));     
     c(i,:)
     h = nii.img;
     maxa = max(max(max(h)))
     
     h = h*(y/maxa);
     
     nii.img = h;
     
     save_nii(nii, c(i,:));
 end