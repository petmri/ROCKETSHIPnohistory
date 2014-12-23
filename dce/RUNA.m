function varargout = RUNA(varargin)
% RUNA MATLAB code for RUNA.fig
%      RUNA, by itself, creates a new RUNA or raises the existing
%      singleton*.
%
%      H = RUNA returns the handle to a new RUNA or the handle to
%      the existing singleton*.
%
%      RUNA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNA.M with the given input arguments.
%
%      RUNA('Property','Value',...) creates a new RUNA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RUNA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RUNA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RUNA

% Last Modified by GUIDE v2.5 28-Mar-2014 10:43:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RUNA_OpeningFcn, ...
    'gui_OutputFcn',  @RUNA_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before RUNA is made visible.
function RUNA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RUNA (see VARARGIN)

% Choose default command line output for RUNA
handles.output = hObject;

handles.filelist =   [];

%Parallel list for sorting comparison
handles.sortlist =   [];
%Rootname
handles.subjectID =  [];
handles.rootname  = [];
%Hashtable % row is 3D volume, % column referes to 2D slice 
handles.LUT= [];

handles.t1aiffiles = [];
handles.t1roifiles = [];
handles.noisefiles = [];
handles.t1mapfiles = [];
handles.saved_results = '';

% Properly enables or disables options
uirestore(handles.xyzt);
uirestore(handles.xytz);
uirestore(handles.aif_auto);
uirestore(handles.aif_auto_static);
uirestore(handles.aif_roi);
update_disable_options(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RUNA wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RUNA_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} =handles.saved_results;
delete(handles.figure1);


% --- Executes on selection change in DCEfilesA.
function DCEfilesA_Callback(hObject, eventdata, handles)
% hObject    handle to DCEfilesA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DCEfilesA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DCEfilesA


% --- Executes during object creation, after setting all properties.
function DCEfilesA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DCEfilesA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DCEfilesB.
function DCEfilesB_Callback(hObject, eventdata, handles)
% hObject    handle to DCEfilesB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    DCEA = get(handles.DCEfilesA, 'Value');
    DCEB = get(handles.DCEfilesB, 'Value');
  
    [handles] = visualize_list_dce(handles, DCEA,DCEB,1);
    
    % Update handles structure
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns DCEfilesB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DCEfilesB


% --- Executes during object creation, after setting all properties.
function DCEfilesB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DCEfilesB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DCEfilesC.
function DCEfilesC_Callback(hObject, eventdata, handles)
% hObject    handle to DCEfilesC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DCEfilesC contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DCEfilesC


% --- Executes during object creation, after setting all properties.
function DCEfilesC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DCEfilesC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DCEfilesBup.
function DCEfilesBup_Callback(hObject, eventdata, handles)
% hObject    handle to DCEfilesBup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure
guidata(hObject, handles);

% Check if there is a dataset already. If not, do nothing.
list = get(handles.DCEfilesB,'String');

if strcmp(list, 'No files selected') || isempty(list)
    % do nothing
else
    
    %
    up = 1;
    dim= 1;
    [handles] = reorderLUT(handles, up, dim);
    
    DCEA = get(handles.DCEfilesA, 'Value');
    DCEB = get(handles.DCEfilesB, 'Value');
    DCEC = get(handles.DCEfilesC, 'Value');
  
    [handles] = visualize_list_dce(handles, DCEA,DCEB,DCEC);

end

% Update handles structure
guidata(hObject, handles);





% --- Executes on button press in DCEfilesBdown.
function DCEfilesBdown_Callback(hObject, eventdata, handles)
% hObject    handle to DCEfilesBdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure
guidata(hObject, handles);

% Check if there is a dataset already. If not, do nothing.
list = get(handles.DCEfilesB,'String');

if strcmp(list, 'No files selected') || isempty(list)
    % do nothing
else
     %
    up = 0;
    dim= 1;
    [handles] = reorderLUT(handles, up, dim);
    
    DCEA = get(handles.DCEfilesA, 'Value');
    DCEB = get(handles.DCEfilesB, 'Value');
    DCEC = get(handles.DCEfilesC, 'Value');

    [handles] = visualize_list_dce(handles, DCEA,DCEB,DCEC);
    

end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in DCEfilesCup.
function DCEfilesCup_Callback(hObject, eventdata, handles)
% hObject    handle to DCEfilesCup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure
guidata(hObject, handles);

% Check if there is a dataset already. If not, do nothing.
list = get(handles.DCEfilesC,'String');

if strcmp(list, 'No files selected') || isempty(list)
    % do nothing
else
  %
    up = 1;
    dim= 2;
    [handles] = reorderLUT(handles, up, dim);
    
    DCEA = get(handles.DCEfilesA, 'Value');
    DCEB = get(handles.DCEfilesB, 'Value');
    DCEC = get(handles.DCEfilesC, 'Value');
    
    [handles] = visualize_list_dce(handles, DCEA,DCEB,DCEC);
    

end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in DCEfilesCdown.
function DCEfilesCdown_Callback(hObject, eventdata, handles)
% hObject    handle to DCEfilesCdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update handles structure
guidata(hObject, handles);

% Check if there is a dataset already. If not, do nothing.
list = get(handles.DCEfilesC,'String');

if strcmp(list, 'No files selected') || isempty(list)
    % do nothing
else
     %
    up = 0;
    dim= 2;
    [handles] = reorderLUT(handles, up, dim);
    
    DCEA = get(handles.DCEfilesA, 'Value');
    DCEB = get(handles.DCEfilesB, 'Value');
    DCEC = get(handles.DCEfilesC, 'Value');
    
    [handles] = visualize_list_dce(handles, DCEA,DCEB,DCEC);
    
 
end
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('User selected Run A')
disp('Consistency checks before running');

[notemsg, errormsg] = consistencyCHECKRUNA(handles);

if ~isempty(errormsg)
    disp_error(errormsg, handles);
    return;
else
    disp_error(notemsg, handles);
end

disp('Loading image volumes')

[TUMOR, LV, NOISE, DYNAMIC, dynampath, dynamname, rootname, hdr, res, sliceloc, errormsg] = loadIMGVOL(handles);

if ~isempty(errormsg)
    
    disp_error(errormsg, handles);
    return;
end

% Debug checks
% size(TUMOR)
% size(LV)
% size(NOISE)
% size(DYNAMIC)
% dynampath 
% dynamname
% rootname
% hdr
% res
% sliceloc
% errormsg
% pause

% image parameters
quant     = get(handles.quant, 'Value');
if quant
    if get(handles.aiforrr, 'Value')==2
        aif_rr_type = 'rr';
    else
        aif_rr_type = get(get(handles.aif_type,'SelectedObject'),'Tag');
    end
else
    aif_rr_type = 'none';
end
tr = str2num(get(handles.tr, 'String')); %#ok<ST2NM>
fa = str2num(get(handles.fa, 'String')); %#ok<ST2NM>
% time_resolution = str2num(get(handles.time_resolution, 'String')); %#ok<ST2NM>
hematocrit = str2num(get(handles.hematocrit, 'String')); %#ok<ST2NM>
snr_filter = str2num(get(handles.snr_filter, 'String')); %#ok<ST2NM>
relaxivity = str2num(get(handles.relaxivity, 'String')); %#ok<ST2NM>
injection_time = str2num(get(handles.injection_time, 'String')); %#ok<ST2NM>
injection_duration = str2num(get(handles.injection_duration, 'String')); %#ok<ST2NM>
%water_fraction = str2num(get(handles.water_fraction, 'String')); %#ok<ST2NM>
drift = get(handles.drift, 'Value');
blood_t1 = str2num(get(handles.blood_t1, 'String')); %#ok<ST2NM>

%time_resolution = time_resolution/60; %convert to minutes
saved_results = A_make_R1maps_func(DYNAMIC, LV, TUMOR, NOISE, hdr, res,quant, rootname, dynampath, dynamname, aif_rr_type, ... 
    tr,fa,hematocrit,snr_filter,relaxivity,injection_time,drift, sliceloc,blood_t1, injection_duration);

% saved_results = 'aaa';
%set(handles.results_a_path,'String',saved_results);

handles.saved_results = saved_results;
guidata(hObject, handles);
uiresume(handles.figure1);



function aifRRtxt_Callback(hObject, eventdata, handles)
% hObject    handle to aifRRtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aifRRtxt as text
%        str2double(get(hObject,'String')) returns contents of aifRRtxt as a double


% --- Executes during object creation, after setting all properties.
function aifRRtxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aifRRtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function t1_roi_path_Callback(hObject, eventdata, handles)
% hObject    handle to t1_roi_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t1_roi_path as text
%        str2double(get(hObject,'String')) returns contents of t1_roi_path as a double


% --- Executes during object creation, after setting all properties.
function t1_roi_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t1_roi_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in t1aif.
function t1aif_Callback(hObject, eventdata, handles)
% hObject    handle to t1aif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);

[filename, pathname, filterindex] = uigetfile( ...
    {  '*.nii','Nifti Files (*.nii)'; ...
    '*2dseq','Bruker Files (2dseq)'; ...
    '*dcm', 'DICOM Files (dcm)'; ...
    '*.hdr;*.img','Analyze Files (*.hdr, *.img)';...
    '*.*',  'All Files (*.*)'}, ...
    'Choose ROI of AIF or Ref Region', 'MultiSelect', 'on'); %#ok<NASGU>
if isequal(filename,0)
    %disp('User selected Cancel')
else
    %disp(['User selected ', fullfile(pathname, filename)])
    
    % Combine path and filename together
    fullpath = strcat(pathname,filename);
    
    if ischar(fullpath)
        fullpath = {fullpath};
    end
    % if isempty(list)
    %     list = {''};
    % end
    
    %filename = filename';
    fullpath = fullpath';
    
    if numel(fullpath) > 1
        visualpath = [fullpath{1} ' -> ' num2str(numel(fullpath)) ' files'];
    else
        visualpath = fullpath{1};
    end
    set(handles.aifRRtxt,'String',visualpath);
    
    handles.t1aiffiles = fullpath;
    
end
guidata(hObject, handles);


% --- Executes on button press in t1roi.
function t1roi_Callback(hObject, eventdata, handles)
% hObject    handle to t1roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);

[filename, pathname, filterindex] = uigetfile( ...
    {  '*.nii','Nifti Files (*.nii)'; ...
    '*2dseq','Bruker Files (2dseq)'; ...
    '*dcm', 'DICOM Files (dcm)'; ...
    '*.hdr;*.img','Analyze Files (*.hdr, *.img)';...
    '*.*',  'All Files (*.*)'}, ...
    'Choose ROI image of region of interest', 'MultiSelect', 'on'); %#ok<NASGU>
if isequal(filename,0)
    %disp('User selected Cancel')
    fullpath = '';
else
    %disp(['User selected ', fullfile(pathname, filename)])
    
    % Combine path and filename together
    fullpath = strcat(pathname,filename);
    
    if ischar(fullpath)
        fullpath = {fullpath};
    end
    % if isempty(list)
    %     list = {''};
    % end
    
    %filename = filename';
    fullpath = fullpath';
    
    if numel(fullpath) > 1
        visualpath = [fullpath{1} ' -> ' num2str(numel(fullpath)) ' files'];
    else
        visualpath = fullpath{1};
    end
    
    set(handles.t1_roi_path,'String',visualpath);
end

handles.t1roifiles = fullpath;
guidata(hObject, handles);



% --- Executes on selection change in filevolume.
function filevolume_Callback(hObject, eventdata, handles)
% hObject    handle to filevolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filevolume contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filevolume


% if ~isempty(handles.batchdata)
%     [handles, errormsg] = update_segmentlist(handles, '', 3);
%     disp_error(errormsg, handles);
% end

[handles, errormsg] = visualize_list_dce(handles, 1,1,1);

disp_error(errormsg, handles);
guidata(hObject, handles);
uiremember;

% --- Executes during object creation, after setting all properties.
function filevolume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filevolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;

% --- Executes on button press in addfiles.
function addfiles_Callback(hObject, eventdata, handles)
% hObject    handle to addfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname, filterindex] = uigetfile( ...
    {'*.nii','Nifti Files (*.nii)';
    '*.hdr;*.img',  'Analyze Files (*.hdr, *.img)'; ...
    '*.dcm','3D DICOM Files (*.dcm)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Pick volume files', ...
    'MultiSelect', 'on');

if isequal(filename,0)
    %disp('User selected Cancel')
    return;
end

% Combine path and filename together
fullpath = strcat(pathname,filename);


% Check if there is a dataset already. If not, do nothing.
list = get(handles.DCEfilesA,'String');

% Stupid matlab uses a different datastructure if only one file
% is selected, handle special case
if ischar(list)
    list = {list};
end
% if ischar(filename)
%     filename = {filename};
% end
if ischar(fullpath)
    fullpath = {fullpath};
end
% if isempty(list)
%     list = {''};
% end

%filename = filename';
fullpath = fullpath';

% Add new files to hashtable

[handles, errormsg] = ADDLUT(handles, fullpath);

[handles] = visualize_list_dce(handles, 1,1,1);

disp_error(errormsg, handles);

guidata(hObject, handles);


% --- Executes on button press in removefiles.
function removefiles_Callback(hObject, eventdata, handles)
% Update handles structure
guidata(hObject, handles);

% Check if there is a dataset already. If not, do nothing.
list = get(handles.DCEfilesA,'String');

if strcmp(list, 'No files selected') || isempty(list)
    % do nothing
else
    
    fileselectedA = get(handles.DCEfilesA, 'Value');
    toberemoved   = list(fileselectedA,:);
    
    % Remove files from hashtable
    
    [handles, errormsg] = REMOVELUT(handles,  toberemoved);
    disp_error(errormsg, handles);
    
    fileselectedA = max((fileselectedA-1), 1);
    [handles, errormsg] = visualize_list_dce(handles, fileselectedA,1,1);
    
    disp_error(errormsg, handles);
end
guidata(hObject, handles);


% --- Executes on button press in noisefile.
function noisefile_Callback(hObject, eventdata, handles)
guidata(hObject, handles);
set(handles.noisepixels, 'Value', 0);
set(handles.noisefile, 'Value', 1);
[filename, pathname, filterindex] = uigetfile( ...
    {  '*.nii','Nifti Files (*.nii)'; ...
    '*2dseq','Bruker Files (2dseq)'; ...
    '*dcm', 'DICOM Files (dcm)'; ...
    '*.hdr;*.img','Analyze Files (*.hdr, *.img)';...
    '*.*',  'All Files (*.*)'}, ...
    'Choose Noise Region from dynamic scan', 'MultiSelect', 'off'); %#ok<NASGU>
if isequal(filename,0)
    %disp('User selected Cancel')
    set(handles.noisefile, 'Value', 0);
    set(handles.noisepixels, 'Value', 1);
else
    %disp(['User selected ', fullfile(pathname, filename)])
    
    % Combine path and filename together
    fullpath = strcat(pathname,filename);
    
    if ischar(fullpath)
        fullpath = {fullpath};
    end
    
    fullpath = fullpath';
    
    if numel(fullpath) > 1
        visualpath = [fullpath{1} ' -> ' num2str(numel(fullpath)) ' files'];
    else
        visualpath = fullpath{1};
    end
    
    set(handles.noise_path,'String',visualpath);
    handles.noisefiles = fullpath;
end
guidata(hObject, handles);
update_disable_options(handles);



% --- Executes on button press in noisepixels.
function noisepixels_Callback(hObject, eventdata, handles)
guidata(hObject, handles);
set(handles.noisefile, 'Value', 0);
set(handles.noisepixels, 'Value', 1);
update_disable_options(handles);




function noise_path_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function noise_path_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noisepixsize_Callback(hObject, eventdata, handles)
uiremember;

% --- Executes during object creation, after setting all properties.
function noisepixsize_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;


function tr_Callback(hObject, eventdata, handles)
uiremember;

% --- Executes during object creation, after setting all properties.
function tr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;


function fa_Callback(hObject, eventdata, handles)
uiremember;


% --- Executes during object creation, after setting all properties.
function fa_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;


function hematocrit_Callback(hObject, eventdata, handles)
uiremember;

% --- Executes during object creation, after setting all properties.
function hematocrit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;


function snr_filter_Callback(hObject, eventdata, handles)
uiremember;

% --- Executes during object creation, after setting all properties.
function snr_filter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;


function injection_time_Callback(hObject, eventdata, handles)
uiremember;

% --- Executes during object creation, after setting all properties.
function injection_time_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;


function relaxivity_Callback(hObject, eventdata, handles)
uiremember;

% --- Executes during object creation, after setting all properties.
function relaxivity_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;



% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
uiresume(handles.figure1);



function rootnameB_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function rootnameB_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rootnameA_Callback(hObject, eventdata, handles)
[handles, errormsg] = update_segmentlist(handles, '', 3);
disp_error(errormsg, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rootnameA_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in aiforrr.
function aiforrr_Callback(hObject, eventdata, handles)
update_disable_options(handles);
uiremember;

% --- Executes during object creation, after setting all properties.
function aiforrr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;

% --- Executes when selected object is changed in fileorder.
function fileorder_SelectionChangeFcn(hObject, eventdata, handles)
uiremember(handles.xyzt);
uiremember(handles.xytz);

% --- Executes on key press with focus on DCEfilesB and none of its controls.
function DCEfilesB_KeyPressFcn(hObject, eventdata, handles)


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)


% --- Executes on button press in t1mapfile.
function t1mapfile_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

[filename, pathname, filterindex] = uigetfile( ...
    {  '*.nii','Nifti Files (*.nii)'; ...
    '*2dseq','Bruker Files (2dseq)'; ...
    '*dcm', 'DICOM Files (dcm)'; ...
    '*.hdr;*.img','Analyze Files (*.hdr, *.img)';...
    '*.*',  'All Files (*.*)'}, ...
    'Choose T1 map', 'MultiSelect', 'on'); %#ok<NASGU>
if isequal(filename,0)
    %disp('User selected Cancel')
else
    %disp(['User selected ', fullfile(pathname, filename)])
    
    % Combine path and filename together
    fullpath = strcat(pathname,filename);
    
    if ischar(fullpath)
        fullpath = {fullpath};
    end
    % if isempty(list)
    %     list = {''};
    % end
    
    %filename = filename';
    fullpath = fullpath';
    
    if numel(fullpath) > 1
        visualpath = [fullpath{1} ' -> ' num2str(numel(fullpath)) ' files'];
    else
        visualpath = fullpath{1};
    end
    
    set(handles.t1mappath,'String',visualpath);
end

handles.t1mapfiles = fullpath;
guidata(hObject, handles);



function t1mappath_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function t1mappath_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in quant.
function quant_Callback(hObject, eventdata, handles)
update_disable_options(handles);
uiremember;
    


% --- Executes on selection change in aifmaskroi.
function aifmaskroi_Callback(hObject, eventdata, handles)
update_disable_options(handles);
uiremember;


% --- Executes during object creation, after setting all properties.
function aifmaskroi_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;

% --- Executes on selection change in roimaskroi.
function roimaskroi_Callback(hObject, eventdata, handles)
update_disable_options(handles);
uiremember;

function update_disable_options(handles)
if get(handles.quant, 'Value')
%     set(handles.aifRRtxt, 'Enable', 'on');
    set(handles.aiforrr, 'Enable', 'on');
%     set(handles.aifmaskroi, 'Enable', 'on');
    if get(handles.aiforrr, 'Value') == 1
        % AIF
        set(handles.aif_roi, 'Enable', 'on');
        set(handles.aif_auto, 'Enable', 'on');
        set(handles.aif_auto_static, 'Enable', 'on');
        if get(handles.aif_auto_static, 'Value')
            set(handles.blood_t1, 'Enable', 'on');
        else
            set(handles.blood_t1, 'Enable', 'off');
        end
        if get(handles.aif_roi, 'Value')
            set(handles.aifmaskroi, 'Enable', 'on');
            set(handles.injection_duration, 'Enable', 'off');
        else
            % Auto so cannot use T1 map of small AIF ROI
            % Can only use a mask
            set(handles.aifmaskroi, 'Value',1);
            set(handles.aifmaskroi, 'Enable', 'off');
            set(handles.injection_duration, 'Enable', 'on');
        end
    else
        % RR, no AIF
        set(handles.aif_roi, 'Enable', 'off');
        set(handles.aif_auto, 'Enable', 'off');
        set(handles.aif_auto_static, 'Enable', 'off');
        set(handles.blood_t1, 'Enable', 'off');
        set(handles.aifmaskroi, 'Enable', 'on');
        set(handles.injection_duration, 'Enable', 'off');
    end
else
%     set(handles.aifRRtxt, 'Enable', 'off');
    set(handles.aiforrr, 'Enable', 'off');
%     set(handles.aifmaskroi, 'Enable', 'off');
    set(handles.aif_roi, 'Enable', 'off');
    set(handles.aif_auto, 'Enable', 'off');
    set(handles.aif_auto_static, 'Enable', 'off');
    set(handles.blood_t1, 'Enable', 'off');
%     set(handles.aifmaskroi, 'Enable', 'on');
    set(handles.injection_duration, 'Enable', 'off');
end
if (get(handles.roimaskroi, 'Value') == 2 && get(handles.aifmaskroi, 'Value') == 2) || ...
        (get(handles.roimaskroi, 'Value') == 2 && get(handles.aif_auto_static, 'Value') && strcmp(get(handles.aif_auto_static, 'Enable'),'on') )
    % The input is a T1 values, so we don't need a seperate T1 map
    set(handles.t1mapfile, 'Enable', 'off');
    set(handles.t1mappath, 'Enable', 'off');
elseif ~get(handles.quant, 'Value') && get(handles.roimaskroi, 'Value') == 2
    % The input is a T1 values, so we don't need a seperate T1 map
    set(handles.t1mapfile, 'Enable', 'off');
    set(handles.t1mappath, 'Enable', 'off');
else
    % The input is a mask, so we need a seperate T1 map
    set(handles.t1mapfile, 'Enable', 'on');
    set(handles.t1mappath, 'Enable', 'on');
end
if get(handles.noisepixels,'Value')
    set(handles.noise_path, 'Enable', 'off');
    set(handles.noisepixsize, 'Enable', 'on');
else
    set(handles.noise_path, 'Enable', 'on');
    set(handles.noisepixsize, 'Enable', 'off');
end

% --- Executes during object creation, after setting all properties.
function roimaskroi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roimaskroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;

% --- Executes on button press in drift.
function drift_Callback(hObject, eventdata, handles)
uiremember();


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
uiresume(hObject);

% --- Executes during object creation, after setting all properties.
function fileorder_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function drift_CreateFcn(hObject, eventdata, handles)
uirestore;


% --- Executes during object creation, after setting all properties.
function quant_CreateFcn(hObject, eventdata, handles)
uirestore;


% --- Executes during object creation, after setting all properties.
function noisefile_CreateFcn(hObject, eventdata, handles)
% uirestore;


% --- Executes during object creation, after setting all properties.
function noisepixels_CreateFcn(hObject, eventdata, handles)
% uirestore;


function blood_t1_Callback(hObject, eventdata, handles)
uiremember();

% --- Executes during object creation, after setting all properties.
function blood_t1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;

% --- Executes when selected object is changed in aif_type.
function aif_type_SelectionChangeFcn(hObject, eventdata, handles)
uiremember(handles.aif_auto);
uiremember(handles.aif_auto_static);
uiremember(handles.aif_roi);
update_disable_options(handles);



function injection_duration_Callback(hObject, eventdata, handles)
uiremember();

% --- Executes during object creation, after setting all properties.
function injection_duration_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;
