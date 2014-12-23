function IMG = sortIMGVOL(IMG, sliceloc);
% reslices IMG to be in correct order

if numel(sliceloc) < 2 
    return;
else
    
    [~, ind] = sort(sliceloc);

    for i = 1:numel(ind)
        
        NEWIMG(:,:,i) = IMG(:,:,ind);
    end
end

IMG = NEWIMG;