% Remove dir info to allow nice visualization
function visual_list = visualize_list_dce(list)

visual_list = [];
sizer = 0;

for i = 1:numel(list)
    curfiles = list(i).files; 
    namer = curfiles{1};

    [~, namer, ext] = fileparts(namer);
    
    if numel(curfiles) > 1
        namer = [namer ' --> ' num2str(numel(curfiles)) ' files'];
    else
        namer = [namer ext];
    end
    
    sizer = max(sizer, numel(namer));
    
    totname{i}.namer = namer;
end

for i = 1:numel(list)
    
    namer = totname{i}.namer;
    
    if numel(namer) < sizer
        
        namer = [namer blanks(sizer-numel(namer))];
    end

    visual_list = [visual_list; namer];
end
%     
% for i = 1:numel(list)
%     [~, fn,ext] = fileparts(list{i});
%     list{i} = [fn ext];
% end