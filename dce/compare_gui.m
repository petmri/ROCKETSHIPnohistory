function varargout = compare_gui(varargin)
% COMPARE_GUI MATLAB code for compare_gui.fig
%      COMPARE_GUI, by itself, creates a new COMPARE_GUI or raises the existing
%      singleton*.
%
%      H = COMPARE_GUI returns the handle to a new COMPARE_GUI or the handle to
%      the existing singleton*.
%
%      COMPARE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPARE_GUI.M with the given input arguments.
%
%      COMPARE_GUI('Property','Value',...) creates a new COMPARE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before compare_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to compare_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help compare_gui

% Last Modified by GUIDE v2.5 20-Dec-2013 13:28:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @compare_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @compare_gui_OutputFcn, ...
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


% --- Executes just before compare_gui is made visible.
function compare_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to compare_gui (see VARARGIN)

% Choose default command line output for compare_gui
handles.output = hObject;

handles.xdata = varargin(1);
handles.fit_data = varargin(2);
handles.show_original = varargin(3);
handles.show_ci = varargin(4);

% Update handles structure
guidata(hObject, handles);

set(handles.roi_listbox,'String',handles.fit_data{1}.roi_name, 'Value',1)
% UIWAIT makes compare_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = compare_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in roi_listbox.
function roi_listbox_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String')); 
selected_name = contents{get(hObject,'Value')};
selected_roi_temp = strfind(handles.fit_data{1}.roi_name,selected_name);
selected_roi = find(not(cellfun('isempty', selected_roi_temp)));

plot_data.Ct			= handles.xdata{1}.roi_series(:,selected_roi);
plot_data.Ct_original	= handles.xdata{1}.roi_series_original(:,selected_roi);
plot_data.Cp			= handles.xdata{1}.Cp;
plot_data.timer			= handles.xdata{1}.timer;
plot_data.fit_parameters= handles.fit_data{1}.roi_results(selected_roi,:);
plot_data.dce_model		= handles.fit_data{1}.dce_model;
plot_data.show_original = handles.show_original{1};
plot_data.show_ci		= handles.show_ci{1};
plot_data.title = ['ROI "' selected_name '"'];

if strcmp(handles.fit_data{1}.dce_model,'fxr')
    plot_data.R1o = handles.xdata{1}.roi_r1(selected_roi);
    plot_data.R1i = handles.xdata{1}.roi_r1(selected_roi);
    plot_data.r1 = handles.xdata{1}.relaxivity;
    plot_data.fw = 0.8;
end

figure(2);
plot_dce_curve(plot_data);


% --- Executes during object creation, after setting all properties.
function roi_listbox_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_exit.
function button_exit_Callback(hObject, eventdata, handles)
% hObject    handle to button_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);
