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

set(handles.dirShowText,'String','E:\recordings\');
uiwait(handles.initMainWindow);

%preAmpGain = str2double(handles.preAmpGainEdit.String);
%ampGain = str2double(handles.ampGainEdit.String);
%totalGain = preAmpGain * ampGain;

%saverData is struct containing info on saving
saverData.dirPath = handles.dirShowText.String;   %directory path
saverData.filename = handles.basenameEdit.String; %base File name
saverData.notes = handles.notesEdit.String;       %notes

%daqData is struct containing data for ai Input
daqData.srate = str2double(handles.sRateEdit.String); %sample rate given in hertz, should equal nyquist
daqData.chList = handles.channelListBox.Value;        %given as array of numbers referring to 
										              %active channels i.e. if channels 1, 3, and 5 
										              %are active, chList=[1,3,5]
switch handles.daqGainMenu.Value %get dropdown box's index
	case 1
		daqData.gain = 1;        %values for ai.GainPerChan
	case 2
		daqData.gain = 2;
	case 3
		daqData.gain = 4;
	case 4
		daqData.gain = 8;
end

close all;
plotGUI( saverData, daqData )



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
