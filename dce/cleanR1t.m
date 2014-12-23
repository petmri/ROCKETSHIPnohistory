%% Clean up the R1 by interpolation

function [R1t, T1 ROIind, BADspace, GOODspace] = cleanR1t(R1t, T1, ROIind, type, pick, threshold, quant)

BADspace = [];
CLEANspace = 0;
timepoints = size(R1t,1);
spacepoints= size(R1t,2);


    disp(' ');
    disp(['Clean R1t of ' type ' with interpolation'])
    disp(['time points = ' num2str(timepoints)])
    disp(['space points = ' num2str(spacepoints)])
    
    % Search each voxel to see if issues, interpolate if issues
    
    for j = 1:spacepoints
        
        %First check for non-real numbers
        R1t_imaginary = imag(R1t(:, j));
        ind  = find(R1t_imaginary > 0);
        
        % if greater than threshold, remove
        if(ind > threshold*(timepoints))
            BADspace = [BADspace j];
        elseif(ind > 0)
            %Not greater than threshold remove imaginary part
            R1t(:, j) = real(R1t(:, j));
        end
        
        %Also check for non-finite values
        ind = find(~isfinite((R1t(:, j))));
        if(ind > threshold*(timepoints))
            BADspace = [BADspace j];
        elseif(ind > 0)
            for k = 1:numel(ind)
                buffer = 3;
                
                bufferind = ind(k)-buffer:ind(k)+buffer;
                
                out = find(bufferind > (timepoints));
                bufferind(out) = [];
                
                out = find(bufferind < 1);
                bufferind(out) = [];
                
                out = find(bufferind == ind(k));
                bufferind(out) = [];
                
                R1t(ind(k),j) = interp1(bufferind, R1t(bufferind,j), ind(k));
                
                if isfinite(R1t(ind(k),j))
                    CLEANspace = CLEANspace+1;
                else
                    BADspace = [BADspace j];
                    break;
                end
            end
        end
        
    end
    
    GOODspace= setdiff([1:spacepoints], BADspace);
    perbad = numel(BADspace)/spacepoints*100;
    
    disp([num2str(perbad) '% of total ' type ' voxels were removed from analysis.']);
    
    disp([num2str(CLEANspace/numel(R1t)*100) '% of total voxels were cleaned.']);
    
    R1t(:, BADspace) = [];
    T1(BADspace)    = [];
    ROIind(BADspace) = [];
    
    % Now we pick number of voxels to be selected for actual measure 0 if all
    pick = min(pick, numel(ROIind));
    if(pick <= 0)
        %All chosen
    else
        
        R1t = R1t(:,1:pick);
        
        T1 = T1(1:pick);
        ROIind = ROIind(1:pick);
    end
    











