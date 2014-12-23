function [subsets, errormsgA] = sort_parse_2Dvol(sortlist_origfilename, rootname);

errormsgA = '';

subsets = split2subsets(sortlist_origfilename,  rootname);

% Check if there are uneven subsets

if numel(unique(subsets)) > 1
    errormsg = 'Uneven subsets: Check filenames';
    return;
end