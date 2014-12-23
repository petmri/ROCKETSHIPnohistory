% Find the coordinates of the phantom rod

function OUT = findRod(currentimage, rod, noise, VISITED)

OUT = [];
threshold = currentimage(rod(1), rod(2))*0.9;

% done = 0;
% 
% while(~done)
%     
%     if(currentimage(rod(1), rod(2)) < threshold)
%         done = 1;
%     elseif(ismember([rod(1) rod(2)], VISITED))
%         done = 1;
%     else
%         
%         OUT = [OUT;rod];
%         VISITED = [VISITED; rod];
%         
%         for i = [-1:1]
%             for j = [-1:1]
%                 
%                 if((i== 0) && (j == 0))
%                     
%                 elseif(ismember([rod(1)+i rod(2)+j], VISITED))
%                     
%                 elseif(currentimage(rod(1)+i, rod(2)+j) < threshold)
%                 else
%                    % VISITED = [VISITED; [rod(1)+i rod(2)+j]];
%                     OUT = [OUT; findRod(currentimage, [rod(1)+i rod(2)+j], noise, VISITED)];
%                 end
%             end
%         end
%     end
% end


for i = [-3:3]
    for j = [-3:3]
        
        if((rod(1)+i < size(currentimage,1)) && (rod(2)+j < size(currentimage,2)))
            if(currentimage(rod(1)+i, rod(2)+j) > threshold)
                OUT = [OUT; [rod(1)+i rod(2)+j]];
            end
        end
    end
end

       