function  n = niftipathfind();

n = '';
checkpath = path;
semicolonmarkers = strfind(checkpath, ';');

for i = 1:(numel(semicolonmarkers)+1)
    
    if i == 1
        curpath = checkpath(1:semicolonmarkers(i));
        
    elseif i < numel(semicolonmarkers)+1
        curpath = checkpath(semicolonmarkers(i-1):semicolonmarkers(i));
    else
        curpath = checkpath(semicolonmarkers(i):end);
    end
    
    if strfind(curpath, 'niftitools')
        n = strrep(curpath, ';', '');
        return;
    end
end