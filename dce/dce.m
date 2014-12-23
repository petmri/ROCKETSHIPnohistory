function varargout = dce(varargin)
% DCE MATLAB code for dce.fig
%      DCE, by itself, creates a new DCE or raises the existing
%      singleton*.
%
%      H = DCE returns the handle to a new DCE or the handle to
%      the existing singleton*.
%
%      DCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DCE.M with the given input arguments.
%
%      DCE('Property','Value',...) creates a new DCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dce_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dce_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dce

% Last Modified by GUIDE v2.5 01-Feb-2014 10:48:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @dce_OpeningFcn, ...
    'gui_OutputFcn',  @dce_OutputFcn, ...
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


% --- Executes just before dce is made visible.
function dce_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dce (see VARARGIN)

% Choose default command line output for dce
handles.output = hObject;

% Batch for RUN D
handles.batch_d_listfullpath = {};

uirestore(handles.batch_d_list);
uirestore(handles.email);

% Update handles structure
guidata(hObject, handles);



% check preference file withe verbose for invalid selections, use this to
% guard against typos
parse_preference_file('dce_preferences.txt',1,...
    {'aif_lower_limits' 'aif_upper_limits' 'aif_initial_values' ...
    'aif_TolFun' 'aif_TolX' 'aif_MaxIter' 'aif_MaxFunEvals' 'aif_Robust'...
    'voxel_lower_limit_ktrans' 'voxel_upper_limit_ktrans' 'voxel_initial_value_ktrans' ...
    'voxel_lower_limit_ve' 'voxel_upper_limit_ve' 'voxel_initial_value_ve' ...
    'voxel_lower_limit_vp' 'voxel_upper_limit_vp' 'voxel_initial_value_vp' ...
    'voxel_lower_limit_fp' 'voxel_upper_limit_fp' 'voxel_initial_value_fp' ...
    'voxel_lower_limit_tp' 'voxel_upper_limit_tp' 'voxel_initial_value_tp' ...
    'voxel_TolFun' 'voxel_TolX' 'voxel_MaxIter' 'voxel_MaxFunEvals' ...
    'voxel_lower_limit_tau' 'voxel_upper_limit_tau' 'voxel_initial_value_tau' ...
    'voxel_Robust' 'fxr_fw' 'autoaif_r_square_threshold' 'autoaif_end_signal_threshold' ...
    'autoaif_sobel_threshold' });

% UIWAIT makes dce wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dce_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse_dce.
function browse_dce_Callback(hObject, eventdata, handles)
% Update handles structure
guidata(hObject, handles);

[filename, pathname, filterindex] = uigetfile( ...
    {  '*.nii','Nifti Files (*.nii)'; ...
    '*2dseq','Bruker Files (2dseq)'; ...
    '*.hdr;*.img','Analyze Files (*.hdr, *.img)';...
    '*.*',  'All Files (*.*)'}, ...
    'Choose DCE-MRI file'); %#ok<NASGU>
if isequal(filename,0)
    %disp('User selected Cancel')
else
    %disp(['User selected ', fullfile(pathname, filename)])
    
    % Combine path and filename together
    fullpath = strcat(pathname,filename);
    
    set(handles.dce_path,'String',fullpath);
end
guidata(hObject, handles);

function dce_path_Callback(hObject, eventdata, handles)
uiremember;

% --- Executes during object creation, after setting all properties.
function dce_path_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;

% --- Executes on button press in run_a.
function run_a_Callback(hObject, eventdata, handles)
disp('User selected Run A')
% Run Computation
saved_results = RUNA;%A_make_R1maps_func(dce_path,t1_aif_path,t1_roi_path,noise_path,tr,fa,hematocrit,snr_filter,relaxivity,injection_time,drift);
set(handles.results_a_path,'String',saved_results);


% --- Executes on button press in browse_results_a.
function browse_results_a_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

[filename, pathname, filterindex] = uigetfile( ...
    {  '*.mat','Matlab Worksapce Files (*.mat)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Choose Results from Section A'); %#ok<NASGU>
if isequal(filename,0)
    %disp('User selected Cancel')
else
    %disp(['User selected ', fullfile(pathname, filename)])
    
    % Combine path and filename together
    fullpath = strcat(pathname,filename);
    
    set(handles.results_a_path,'String',fullpath);
end
guidata(hObject, handles);

function results_a_path_Callback(hObject, eventdata, handles)
uiremember;

% --- Executes during object creation, after setting all properties.
function results_a_path_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;


% --- Executes on button press in run_b.
function run_b_Callback(hObject, eventdata, handles)
disp('User selected Run B')
results_a_path = get(handles.results_a_path,'String');

% Run Computation
saved_results = RUNB({results_a_path});
set(handles.results_b_path,'String',saved_results);


% --- Executes on button press in browse_results_b.
function browse_results_b_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

[filename, pathname, filterindex] = uigetfile( ...
    {  '*.mat','Matlab Worksapce Files (*.mat)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Choose Results from Section B'); %#ok<NASGU>
if isequal(filename,0)
    %disp('User selected Cancel')
else
    %disp(['User selected ', fullfile(pathname, filename)])
    
    % Combine path and filename together
    fullpath = strcat(pathname,filename);
    
    set(handles.results_b_path,'String',fullpath);
end
guidata(hObject, handles);


function results_b_path_Callback(hObject, eventdata, handles)
uiremember;

% --- Executes during object creation, after setting all properties.
function results_b_path_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;


% --- Executes on button press in browse_results_d.
function browse_results_d_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

[filename, pathname, filterindex] = uigetfile( ...
    {  '*.mat','Matlab Worksapce Files (*.mat)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Choose Results from Section D'); %#ok<NASGU>
if isequal(filename,0)
    %disp('User selected Cancel')
else
    %disp(['User selected ', fullfile(pathname, filename)])
    
    % Combine path and filename together
    fullpath = strcat(pathname,filename);
    
    set(handles.results_d_path,'String',fullpath);
end
guidata(hObject, handles);



function results_d_path_Callback(hObject, eventdata, handles)
uiremember;

% --- Executes during object creation, after setting all properties.
function results_d_path_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;


% --- Executes on button press in run_d.
function run_d_Callback(hObject, eventdata, handles)
disp('User selected Run D')
results_b_path = get(handles.results_b_path,'String');

% Run Computation
[saved_results, batch] = RUND({results_b_path});

if batch
    disp('Adding prep data to batch queue');
    
    [~, filename] = fileparts(saved_results);
    
    list = get(handles.batch_d_list, 'String');
    
    list = visualize_runD(list, filename);
    set(handles.batch_d_list, 'String', list);
    fullpathlist = handles.batch_d_listfullpath;
    fullpathlist{end+1} = saved_results;
    handles.batch_d_listfullpath = fullpathlist;
else
    disp('Run D done');
end

set(handles.results_d_path, 'String', saved_results);
guidata(hObject, handles);


% --- Executes on button press in run_e.
function run_e_Callback(hObject, eventdata, handles)
saved_results = get(handles.results_d_path, 'String');
fitting_analysis('results_path', saved_results);




% --- Executes on selection change in batch_d_list.
function batch_d_list_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function batch_d_list_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run_d_batch.
function run_d_batch_Callback(hObject, eventdata, handles)
guidata(hObject, handles);
disp('Running batch mode')
list = handles.batch_d_listfullpath;
visual_list = get(handles.batch_d_list, 'String');

started = 0;
if numel(list) > 0
    tic
%     % Log input results
%     log_path = fullfile(pwd, ['D_BATCH_dce_fit_voxels.log']);
%     disp(['Logging batch job at: ' log_path]);
%     if exist(log_path, 'file')==2
%         delete(log_path);
%     end
%     diary(log_path);
    started = 1;
    disp(['Starting batch with ' num2str(numel(list)) ' jobs']);
else
    disp('No prepped files for batch job');
end

new_cur_d_path = '';
while numel(list) > 0
    filename = list{end};
    disp(['Running job on : ' filename]);
    batch_data = load(filename);
%     results = D_fit_voxels_batch_func(Ddatabatch);

%Check if the path exists
results_b_path = batch_data.results_b_path;
[~, b_file, ext]     = fileparts(results_b_path);

if ~exist(results_b_path)
    disp('old path does not exist, trying new path');
    
   if ~exist(fullfile(new_cur_d_path, [b_file ext]))
        while(~exist(results_b_path))
        new_cur_d_path = uigetdir(pwd,['Old path does not exist, Select path where: ' [b_file ext] ' is please.']);
        %     slash = findstr('\', results_b_path);
        %     b_file = results_b_path((slash(end)+1):end);
        results_b_path = fullfile(new_cur_d_path, [b_file ext]);
        end
    else
        results_b_path = fullfile(new_cur_d_path, [b_file ext]);
    end
    if ~exist(results_b_path)
        error('Path error');
    end
    batch_data.results_b_path = results_b_path;
end


    results = D_fit_voxels_func(batch_data.results_b_path,...
        batch_data.dce_model,batch_data.time_smoothing,batch_data.time_smoothing_window,...
        batch_data.xy_smooth_size,batch_data.number_cpus,batch_data.roi_list,...
        batch_data.fit_voxels,batch_data.neuroecon, batch_data.outputft);

    disp(['Wrote: ' results]);
    
    %Flush the queue
    list(end) = [];
    visual_list(end,:) = [];
    
    handles.batch_d_listfullpath = list;
    set(handles.batch_d_list, 'String', visual_list);
    guidata(hObject, handles);
    uiremember;   
end

if started
    disp(datestr(now))
    toc

    % Now we email to user
    % Email the person on completion
    % Define these variables appropriately:
    mail = 'immune.caltech@gmail.com'; %Your GMail email address
    password = 'antibody'; %Your GMail password
    % Then this code will set up the preferences properly:
    setpref('Internet','E_mail',mail);
    setpref('Internet','SMTP_Server','smtp.gmail.com');
    setpref('Internet','SMTP_Username',mail);
    setpref('Internet','SMTP_Password',password);
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
    props.setProperty('mail.smtp.socketFactory.port','465');
    
    hostname = char( getHostName( java.net.InetAddress.getLocalHost ) );
    
    
    sendmail(get(handles.email, 'String'),'ROCKETSHIP map derivation completed',['Hello! Your Map Calc job on '...
        ,hostname,' is done!']);
    
end

handles.batch_d_listfullpath = list;
set(handles.batch_d_list, 'String', visual_list);
guidata(hObject, handles);




% --- Executes on button press in add_d_prep.
function add_d_prep_Callback(hObject, eventdata, handles)
curfulllist = handles.batch_d_listfullpath;

[filename, pathname, ~] = uigetfile( ...
    {'*prep*.mat','Batch data file (*prep*.mat)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Pick batch data files', ...
    'MultiSelect', 'on');

if isequal(filename,0)
    %disp('User selected Cancel')
    return;
end

% Combine path and filename together
fullpath = strcat(pathname,filename);

% Stupid matlab uses a different datastructure if only one file
% is selected, handle special case
% if ischar(filename)
%     filename = {filename};
% end
if ischar(fullpath)
    fullpath = {fullpath};
end

for i = 1:numel(fullpath)
    curfulllist{end+1} = fullpath{i};
end

% make visual_list
lengthspacer = 0;

for i = 1:numel(curfulllist)
    [~, filename] = fileparts(curfulllist{i});
    lengthspacer = max(lengthspacer, numel(filename));
end

list = '';
for i = 1:numel(curfulllist)
    [~, filename] = fileparts(curfulllist{i});
    list(i,:) = [filename blanks(max(0, lengthspacer-numel(filename)))];
end

set(handles.batch_d_list, 'String', list, 'Value', 1);
handles.batch_d_listfullpath = curfulllist;

guidata(hObject, handles);


% --- Executes on button press in remove_d_prep.
function remove_d_prep_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

fileselected = get(handles.batch_d_list, 'Value');
current_file_list = handles.batch_d_listfullpath;

if isempty(current_file_list)
    return
end

current_file_list(fileselected) = [];

% make visual_list
lengthspacer = 0;

for i = 1:numel(current_file_list)
    [~, filename] = fileparts(current_file_list{i});
    lengthspacer = max(lengthspacer, numel(filename));
end

list = '';
for i = 1:numel(current_file_list)
    [~, filename] = fileparts(current_file_list{i});
    list(i,:) = [filename blanks(max(0, lengthspacer-numel(filename)))];
end

if fileselected>numel(current_file_list)
    fileselected = numel(current_file_list);
end
set(handles.batch_d_list, 'String', list, 'Value', fileselected);
handles.batch_d_listfullpath = current_file_list;

guidata(hObject, handles);

function email_Callback(hObject, eventdata, handles)
uiremember;


% --- Executes during object creation, after setting all properties.
function email_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;
