function varargout = initGUI(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @initGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @initGUI_OutputFcn, ...
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


% --- Executes just before initGUI is made visible.
function initGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to initGUI (see VARARGIN)

% Choose default command line output for initGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.dirShowText,'String','E:\recordings');
uiwait(handles.initMainWindow);

preAmpGain = str2double(handles.preAmpGainEdit.String);
ampGain = str2double(handles.ampGainEdit.String);
daqGainValue = handles.daqGainMenu.Value;
switch daqGainValue
	case 1
		daqGain = 1;
	case 2
		daqGain = 2;
	case 3
		daqGain = 4;
	case 4
		daqGain = 8;
end
totalGain = preAmpGain * ampGain;

directory = handles.dirShowText.String;
basename = handles.basenameEdit.String;
chList = handles.channelListBox.Value;
srate = str2double(handles.sRateEdit.String);
notes = handles.notesEdit.String;
close all;
plotGUI( directory, ...
		 basename, ...
	     chList, ...
	     totalGain, ...
	     srate, ...
		 daqGain)



% --- Outputs from this function are returned to the command line.
function varargout = initGUI_OutputFcn(hObject, eventdata, handles) 

%varargout{1} = handles.output;


% --- Executes on selection change in channelListBox.
function channelListBox_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function channelListBox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)

uiresume(handles.initMainWindow)

% --- Executes on button press in setDirButton.
function setDirButton_Callback(hObject, eventdata, handles)

	dir = uigetdir(matlabroot);
	setappdata(hObject,'directory',dir)
	set(handles.dirShowText,'String',dir);


function preAmpGainEdit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function preAmpGainEdit_CreateFcn(hObject, eventdata, handles)
set(hObject, 'String', 1)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ampGainEdit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ampGainEdit_CreateFcn(hObject, eventdata, handles)
set(hObject, 'String', 1000)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in daqGainMenu.
function daqGainMenu_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function daqGainMenu_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sRateEdit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function sRateEdit_CreateFcn(hObject, eventdata, handles)
set(hObject, 'String', 24000)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over basenameEdit.
function basenameEdit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to basenameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function notesEdit_Callback(hObject, eventdata, handles)
% hObject    handle to notesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of notesEdit as text
%        str2double(get(hObject,'String')) returns contents of notesEdit as a double


% --- Executes during object creation, after setting all properties.
function notesEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
