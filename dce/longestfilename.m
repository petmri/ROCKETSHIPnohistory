function sizer = longestfilename(filelist);
sizer = 0;

for i = 1:numel(filelist)

        namer = filelist{i};
        [~, namer, ~] = fileparts(namer);
        sizer = max(sizer, numel(namer));
    end
end