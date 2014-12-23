function [handles, errormsg] = ADDLUT(handles, fullpath);
errormsgA = '';

% Load the files that have already been added. 
LUT = handles.LUT;
subjectID = handles.subjectID;
filelist  = handles.filelist;
sortlist  = handles.sortlist;

% Generate sortedfullpath, sortlist_current, subjectID
%[sortlist_fullpath, sortlist_current, sortlist_origfilename] = sort_parse_INPUTS(fullpath);

%sortlist_fullpath is the full path of the input list in order
%sortlist is the file name with natural ordering for numbers
%sortlist_filename is the filename without the natural ordering
[sortlist_fullpath, sortlist_current, sortlist_origfilename] = sort_parse_INPUTS(fullpath);
%save('Moo.mat', 'sortlist_fullpath', 'sortlist_current', 'fullpath')

rootname = findrootname(subjectID, sortlist_origfilename);

[subsets, errormsg] = sort_parse_2Dvol(sortlist_origfilename, rootname);

% Now we update LUT
if isempty(LUT) || (numel(find(LUT == 0)) == numel(LUT))
    % initialize
    counter = 1;
    for i = 1:numel(subsets)
        for j = 1:subsets(i)
            
            LUT(i,j) = counter;
            filelist = appendLISTS(filelist, sortlist_fullpath(counter));
            sortlist = appendLISTS(sortlist, sortlist_current(counter));
            subjectID= appendLISTS(subjectID, sortlist_origfilename(counter));
            counter = counter + 1;
        end
    end
 
else
    % Need to add current files to the end of the queue
    counter = 1;
    nextfile = numel(sortlist) + 1; % to append to the end of the queue
    
    for i = 1:numel(subsets)
        for j = 1:subsets(i)
            curname = sortlist_current{counter};
            cursubjectID = sortlist_origfilename{counter};
    
            % Find the place to put the file
            [row, col, NEW, DUP] = findLUTPLACE(LUT, sortlist, curname, cursubjectID, subjectID, rootname);
            
            if ~NEW
                
                if LUT(row,col) == 0
                    % 0 just add
                    LUT(row,col) = nextfile;
                elseif DUP
                    % Already added,
                    sortlist_fullpath(counter)      = [];
                    sortlist_current(counter)       = [];
                    sortlist_origfilename(counter)  = [];
                    
                else
                    ind = find(LUT(row,:) == 0);
                    
                    if isempty(ind)
                        LUT(row, col+1:end+1) = LUT(row,col:end);
                    elseif ind == size(LUT,2)
                        
                        for k = (ind-1):-1:col
                            LUT(row,k+1) = LUT(row,k);
                        end
                    else
                        error('ind not at the end of the LUT row')
                    end
                    LUT(row,col) = nextfile;
                end
            else
                if row == 1
                    % place at the stop
                    newrow = zeros(1, size(LUT,2));
                    newrow(col) = nextfile;
                    LUT(2:end+1,:) = LUT;
                    LUT(1,:) = newrow;
                elseif row > size(LUT,1)
                    % place at the bottom
                    newrow = zeros(1, size(LUT,2));
                    newrow(col) = nextfile;
                    LUT(end+1,:)= newrow;
                else
                    % place somewhere in between
                    newrow = zeros(1, size(LUT,2));
                    newrow(col) = nextfile;
                    
                    LUT(row+1:end+1,:) = LUT(row:end, :);
                    LUT(row,:) = newrow;
                end
            end
            
            if ~DUP
                filelist = appendLISTS(filelist, sortlist_fullpath(counter));
                sortlist = appendLISTS(sortlist, sortlist_current(counter));
                subjectID= appendLISTS(subjectID, sortlist_origfilename(counter));
                
                nextfile = nextfile + 1;
                counter = counter + 1;
            end
        end
    end
end

handles.LUT = LUT;
handles.subjectID = subjectID;
handles.rootname = rootname;
handles.filelist = filelist;
handles.sortlist = sortlist;






