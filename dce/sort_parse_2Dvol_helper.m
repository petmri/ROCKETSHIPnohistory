function [subsets, errormsg] = sort_parse_2Dvol_helper(fullpath, sort_list);
errormsg = '';
% Split files into subsets

subsets = split2subsets(sort_list);

% Check if there are uneven subsets

if numel(unique(subsets)) > 1
    errormsg = 'Uneven subsets: Check filenames';
    return;
end

% totalnum = 0;
% for i = 1:numel(subsets)
%     
%     for j = 1:subsets(i)
%         
%         files(j) = fullpath(totalnum+1);
%         totalnum = totalnum+1;
%     end
%     
%     batchdata(i).files = files;
% end



     
     