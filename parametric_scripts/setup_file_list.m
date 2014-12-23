function [file_list, visual_list] = setup_file_list(file_list, addfl, single)

if single
    % Single files
    if isempty(file_list)
        % Need to create a new filelist object
        sizer = 0; % Length of the filename
        for i = 1:numel(addfl)
            curfiles{1} = addfl{i};
            file_list(i).files = curfiles;
            [~, namer, ext] = fileparts(addfl{i});
            sizer = max(sizer, numel([namer ext]));
        end
        % Generate visualized list
        visual_list = [];
        for i = 1:numel(addfl)
            [~, namer, ~] = fileparts(addfl{i});
            if numel(namer) < sizer
                % Current filename too short, add spaces
                spacer = blanks(sizer-numel(namer));
                namer = [namer spacer];
            end
            visual_list = [visual_list; namer];
        end
    else
        j = numel(file_list);
        
        sizer = file_list(1).files;
        sizer = sizer{1};
        [~, namer, ext] = fileparts(sizer);
        sizer = numel([namer ext]);
        
        for i = 1:numel(addfl)
            file_list(j+i).files = addfl(i);
            [~, namer, ext] = fileparts(addfl{i});
            sizer = max(sizer, numel([namer ext]));
        end
        % Generate visualized list
        visual_list = [];
        
        for i = 1:numel(file_list)
            
            namer = file_list(i).files;
            
            namer = namer{1};
            [~,namer, ~] = fileparts(namer);
            if numel(namer) < sizer
                % Current filename too short, add spaces
                spacer = blanks(sizer-numel(namer));
                namer = [namer spacer];
            end
            visual_list = [visual_list; namer];
        end
        
    end
else
    if isempty(file_list)
        
        % Need to create a new filelist object
        sizer = 0; % Length of the filename
        
        for i = 1:numel(addfl)
            curfiles{i} = addfl{i};
            
            [~, namer, ext] = fileparts(addfl{i});
            sizer = max(sizer, numel([namer ext]));
        end
        
        file_list(1).files = curfiles;
        % Generate visualized list
        visual_list = [];
        
        [~, namer, ext] = fileparts(addfl{1});
        
        namer = [namer ext ' --> ' num2str(numel(addfl)) ' files'];
        
        visual_list = [visual_list; namer];
    else
        j = numel(file_list);
        
        sizer = file_list(1).files;
        sizer = sizer{1};
        [~, namer, ext] = fileparts(sizer);
        sizer = numel([namer ext]);
        
        for i = 1:numel(addfl)
            curfiles{i} = addfl{i};
            [~, namer, ext] = fileparts(addfl{i});
            sizer = max(sizer, numel([namer ext]));
        end
        
        file_list(j+1).files = curfiles;
        
        % Generate visualized list
        visual_list = [];
        sizer = 0;
        for i = 1:j+1
            namer = file_list(i).files;
            total = numel(namer);
            namer = namer{1};
            [~, namer, ext] = fileparts(namer);
            
            if total == 1
                sizer = max(sizer,numel([namer ext]));
            else
                
                
                namer = [namer ext ' --> ' num2str(total) ' files'];
                
                sizer = max(sizer, numel(namer));
            end
        end
        for i = 1:j+1
            
            namer = file_list(i).files;
            total = numel(namer);
            namer = namer{1};
            [~, namer, ext] = fileparts(namer);
            
            if total == 1
                namer = [namer ext];
                spacer = blanks(sizer-numel(namer));
                namer = [namer spacer];
                
            else
                namer = [namer ext ' --> ' num2str(total) ' files'];
                spacer = blanks(sizer-numel(namer));
                namer = [namer spacer];
                
            end
            
            
            visual_list = [visual_list; namer];
        end
        
    end
    
end
