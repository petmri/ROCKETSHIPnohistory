function varargout = demo(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @demo_OpeningFcn, ...
                   'gui_OutputFcn',  @demo_OutputFcn, ...
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


function demo_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

function varargout = demo_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function test_CB1_Callback(hObject, eventdata, handles)

function radiobutton1_Callback(hObject, eventdata, handles)

function radiobutton2_Callback(hObject, eventdata, handles)

function test_TB1_Callback(hObject, eventdata, handles)

function test_pop_Callback(hObject, eventdata, handles)

function test_pop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;

function test_CB1_CreateFcn(hObject, eventdata, handles)
uirestore;

function testme_figure_CloseRequestFcn(hObject, eventdata, handles)
uiremember;
delete(hObject);


function testme_figure_CreateFcn(hObject, eventdata, handles)
uirestore;

function test_CB2_Callback(hObject, eventdata, handles)

function test_edit1_Callback(hObject, eventdata, handles)

function test_edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;

function test_slider1_Callback(hObject, eventdata, handles)

function test_slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
uirestore;

function test_edit1_DeleteFcn(hObject, eventdata, handles)
uiremember;


function listbox1_Callback(hObject, eventdata, handles)

function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
uirestore;

function axes1_DeleteFcn(hObject, eventdata, handles)
uiremember;

function test_slider1_DeleteFcn(hObject, eventdata, handles)
uiremember;

function listbox1_DeleteFcn(hObject, eventdata, handles)
uiremember;

function test_CB1_DeleteFcn(hObject, eventdata, handles)
uiremember;

function test_CB2_DeleteFcn(hObject, eventdata, handles)
uiremember;

function test_pop_DeleteFcn(hObject, eventdata, handles)
uiremember;

function test_TB1_DeleteFcn(hObject, eventdata, handles)
uiremember;

function test_CB2_CreateFcn(hObject, eventdata, handles)
uirestore;

function test_RB2_CreateFcn(hObject, eventdata, handles)
uirestore;

function test_RB2_DeleteFcn(hObject, eventdata, handles)
uiremember;

function test_RB3_CreateFcn(hObject, eventdata, handles)
uirestore;

function test_RB3_DeleteFcn(hObject, eventdata, handles)
uiremember;

function test_TB1_CreateFcn(hObject, eventdata, handles)
uirestore;

