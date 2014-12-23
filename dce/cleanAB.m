%% Clean up the A./B  by interpolation, before taking log
% A./B, aka AB, needs to be positive, we interpolate to rid out noisy
% components without taking out all the voxels indiscriminately.

function [AB T1 ROIind BADspace GOODspace] = cleanAB(AB, T1, ROIind, type, pick, threshold, quant)

BADspace = [];
CLEANspace = 0;
timepoints = size(AB,1);
spacepoints= size(AB,2);
 GOODspace = [1:spacepoints];
 
    disp(' ');
    disp(['Clean AB of ' type ' with interpolation'])
    disp(['time points = ' num2str(timepoints)])
    disp(['space points = ' num2str(spacepoints)])
    
    % Search each voxel to see if issues, interpolate if issues
    oneside = 0;
    smallbuf= 0;
    thres   = 0;
    for j = 1:spacepoints
        
        TEST = AB(:, j);
        
        ind  = find(TEST<0);
        
        % if greater than threshold, remove
        if(numel(ind) > threshold*(timepoints))
            BADspace = [BADspace j];
            
            thres = thres +1;
        elseif(ind > 0)
            
            for k = 1:numel(ind)
                
                buffer = 5;
                
                bufferind = ind(k)-buffer:ind(k)+buffer;
                
                out = bufferind > (timepoints);
                bufferind(out) = [];
                
                out = bufferind < 1;
                bufferind(out) = [];
                
                out = bufferind == ind(k);
                bufferind(out) = [];
                
                
                
                out = ismember(bufferind, ind);
                bufferind(out) = [];
                
                
                if(numel(bufferind) < 2)
                    BADspace = unique([BADspace j]);
                    smallbuf = smallbuf + 1;
                elseif(isempty(find((bufferind-ind(k)) > 0)) || isempty(find((bufferind-ind(k)) < 0)))
                    % Cannot interpolate
                    BADspace = unique([BADspace j]);
                    oneside = oneside + 1;
                else
                    TEST(ind(k)) = interp1(bufferind, TEST(bufferind), ind(k));
                    
                    CLEANspace = CLEANspace+1;
                    
                end
            end
            
            if(ismember(j, BADspace))
            else
                
                AB(:, j) = TEST;
            end
        else
        end
    end
    
    GOODspace= setdiff([1:spacepoints], BADspace);
    perbad = numel(BADspace)/spacepoints*100;
    
    disp([num2str(perbad) '% of total ' type ' voxels were removed from analysis.']);
    
    disp([num2str(CLEANspace/numel(AB)*100) '% of total voxels were cleaned.']);
    
    AB(:, BADspace) = [];
    T1(BADspace)    = [];
    ROIind(BADspace) = [];
    
    % Now we pick number of voxels to be selected for actual measure 0 if all
    pick = min(pick, numel(ROIind));
    if(pick <= 0)
        %All chosen
    else
        
        AB = AB(:,1:pick);
        
        T1 = T1(1:pick);
        ROIind = ROIind(1:pick);
    end


% oneside
% smallbuf
% thres











