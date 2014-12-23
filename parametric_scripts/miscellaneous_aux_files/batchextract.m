%This extracts the ROI as a batch job from files in dirpath and the ROI
%file as defined by roi. See extractroi.m for more details.
function [masterlist] = batchextract(dirpath, roi)

 realpath = strcat(dirpath, '*.hdr');
 listoffiles = ls(realpath);
 sizer = size(listoffiles);
 length1 = sizer(1);
 
 masterlist.roisizes = zeros(1, length1);
 masterlist.means = zeros(1, length1);
  masterlist.stdev = zeros(1, length1);
 masterlist.blackdots = zeros(1, length1);
 
 for i=1:length1
     currentpath = strcat(dirpath, listoffiles(i,:));
     [a, b, c, d, e, g] = extractroi(currentpath, roi);
     [f] = blackdot(currentpath,roi);
     
     if (i == 1)
         masterlist.roisizes(1,i) = a;
         masterlist.means(1,i) = b;
         masterlist.originalfile = c;
         masterlist.outputfile = d;
         masterlist.outputpath = e;
         masterlist.blackdots = f;
         masterlist.stdev = g;
     else
           masterlist.roisizes(1,i) = a;
         masterlist.means(1,i) = b;
         masterlist.originalfile = strvcat(masterlist.originalfile, c);
         masterlist.outputfile = strvcat(masterlist.outputfile, d);
         masterlist.outputpath = strvcat(masterlist.outputpath, e);
         masterlist.blackdots(1,i) = f;
         masterlist.stdev(1,i) = g;
     end
 end
end
     
     