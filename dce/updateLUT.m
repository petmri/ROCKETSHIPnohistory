function    LUT = updateLUT(id,LUT);

% update the LUT and remove the id

[x, y] = find(LUT == id);

if numel(x) > 1 || numel(y) > 1
    error('Multiple indices found in updateLUT');
else
    LUT(x,y) = 0;
    
    % Now we update the LUT
    for i = 1:size(LUT,1)
        
        for j = (size(LUT,2)-1):-1:1
            
            if LUT(i,j) == 0
                LUT(i,j:end) = circshift(LUT(i,j:end),[0 -1]);

            end
        end
    end
end

% Update LUT to reflect that we are removing files

ind = find(LUT > id);

LUT(ind) = LUT(ind)-1;

% If the whole row is empty, we remove it.
emptyrow = [];
for i = 1:size(LUT,1)
    
    currow = LUT(i,:);
    
    if sum(currow) == 0
        emptyrow(end+1) = i;
    end
end

LUT(emptyrow,:) = [];

