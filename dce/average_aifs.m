function varargout = average_aifs(varargin)
% AVERAGE_AIFS MATLAB code for average_aifs.fig
%      AVERAGE_AIFS, by itself, creates a new AVERAGE_AIFS or raises the existing
%      singleton*.
%
%      H = AVERAGE_AIFS returns the handle to a new AVERAGE_AIFS or the handle to
%      the existing singleton*.
%
%      AVERAGE_AIFS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AVERAGE_AIFS.M with the given input arguments.
%
%      AVERAGE_AIFS('Property','Value',...) creates a new AVERAGE_AIFS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before average_aifs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to average_aifs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help average_aifs

% Last Modified by GUIDE v2.5 28-Jan-2014 12:23:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @average_aifs_OpeningFcn, ...
                   'gui_OutputFcn',  @average_aifs_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1}) && ~strcmp(varargin{1},'save_path')
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before average_aifs is made visible.
function average_aifs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to average_aifs (see VARARGIN)

% Choose default command line output for average_aifs
handles.output = hObject;

% Create structure to hold aif list
handles.aif_list = {};
handles.save_path = '';

% Get function inputs
if nargin>1 && numel(varargin)>1 && strcmp(varargin{1},'save_path')
    handles.save_path = varargin{2};
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes average_aifs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = average_aifs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in aif_box.
function aif_box_Callback(hObject, eventdata, handles)
% hObject    handle to aif_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns aif_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from aif_box


% --- Executes during object creation, after setting all properties.
function aif_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aif_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in add_aif.
function add_aif_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

[filename, pathname, filterindex] = uigetfile( ...
    {  '*.mat','Matlab Worksapce Files (*.mat)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Choose Results from Section B',...
    'MultiSelect', 'on'); %#ok<NASGU>
if isequal(filename,0)
    %disp('User selected Cancel')
else
    %disp(['User selected ', fullfile(pathname, filename)])
    list = get(handles.aif_box,'String');
    
    % Combine path and filename together
    fullpath = strcat(pathname,filename);
    
    % Stupid matlab uses a different datastructure if only one file
    % is selected, handle special case
    if ischar(list)
        list = {list};
    end
    if ischar(filename)
        filename = {filename};
    end
    if ischar(fullpath)
        fullpath = {fullpath};
    end

    filename = filename';
    fullpath = fullpath';
        
    % Add selected files to listbox
    if strcmp(list,'No Files')
        list = filename;
        handles.aif_list = fullpath;
    else
        list = [list;  filename];
        handles.aif_list = [handles.aif_list; fullpath];
    end 
    
    set(handles.aif_box,'String',list, 'Value',1)
end
guidata(hObject, handles);

% --- Executes on button press in remove_aif.
function remove_aif_Callback(hObject, eventdata, handles)
index_selected = get(handles.aif_box,'Value');
list = get(handles.aif_box,'String');
for n=size(index_selected,2):-1:1
    % Remove from end of list first so resizing does not 
    % change subsequent index numbers
    %disp(['User removed ', list{index_selected(n)}]);
    list(index_selected(n)) = [];
    handles.aif_list(index_selected(n)) = [];
end

set(handles.aif_box,'String',list, 'Value',1)
guidata(hObject, handles);


% --- Executes on button press in run_average.
function run_average_Callback(hObject, eventdata, handles)

number_aif = numel(handles.aif_list);

if number_aif==0
    disp('No files selected');
    return;
end

b = figure;
hold on;
for i=1:number_aif
    disp(['Processing ', char(handles.aif_list(i))])

    external = load(char(handles.aif_list(i)));
    if isfield(external,'Cp_use')
        Cp_use = external.Cp_use;
    elseif isfield(external,'xdata')
        Cp_use = external.xdata{1}.Cp;
    else
        disp(['No Cp curve found in ' handles.aif_list(i)])
        return
    end
    
    if i==1
        %initialize
        Cp_average = zeros(size(Cp_use));
    end
    
    Cp_average = Cp_average+Cp_use;
    
    % 5.5 Plot the results   
    h(i) = plot(Cp_use,'b','LineWidth',0.3);
%     M{i} = '';
end

Cp_average = Cp_average./number_aif;
Cp_use = Cp_average;

h(end+1) = plot(Cp_average,'k','LineWidth',2.0);
hold off;
M{1} = 'Individual AIFs';
M{2} = 'Average AIF'; 
legend(h([end-1 end]),M);
title(['Average of ' num2str(number_aif) ' AIFs'], 'Interpreter', 'none');
ylabel('Concentration (mM)');
xlabel('Time (image number)');
% saveas(b, fullfile(PathName1, [rootname 'AIF_fitting.fig']));
    

save_name = fullfile(handles.save_path, ['average_' num2str(number_aif) '_aifs.mat']);
save(save_name,'Cp_use');

disp(['Average of ' num2str(number_aif) ' AIFs saved to: ' save_name]);
delete(handles.figure1);
 
