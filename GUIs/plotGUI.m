function varargout = plotGUI(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @plotGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before plotGUI is made visible.
function plotGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)
% varargin   consists of 4 values given by initGUI: {directory, basename, 
%										   	chList, totalGain, srate, ai}

handles.output = hObject;
handles.initButton.Enable = 'on';
handles.startButton.Enable = 'off';
handles.stopButton.Enable = 'off';

if ~isempty(varargin)
	saverData = varargin{1};
	daqData   = varargin{2};			
end

chList = daqData.chList;
set(handles.pathDisplay, 'String', saverData.dirPath); %sets display for saving
											      %directory

%%												  
textChList=cell(length(chList)+1,1);
for a=1:length(chList)+1
	if a==1
		textChList{a} = 'No Source';
	else
	textChList{a} = sprintf('Channel %02d',chList(a-1)); 
	end
end


handles.dataPicker1.String = textChList;
handles.dataPicker2.String = textChList;
handles.dataPicker3.String = textChList;
handles.dataPicker4.String = textChList;
handles.dataPicker5.String = textChList;
handles.dataPicker6.String = textChList;
handles.dataPicker7.String = textChList;
handles.dataPicker8.String = textChList;

handles.channelListBox.String = textChList;
%%

%guiHandles is a struct containing references to GUI widgets
guiHandles.plots = {handles.plot1 handles.plot2 handles.plot3 handles.plot4 ...
		            handles.plot5 handles.plot6 handles.plot7 handles.plot8};
guiHandles.sampleCounter = handles.samplesText;
guiHandles.acqTimer = handles.timeText;


recorder = liveRecord(saverData, daqData, guiHandles);

setappdata(hObject,'recorder',recorder);
guidata(hObject, handles);
uiwait(handles.mainWindow)



% --- Outputs from this function are returned to the command line.
function varargout = plotGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
varargout{1} = handles;

% --- Executes on button press in initButton.
function initButton_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow, 'recorder');
rec.resetUI()
handles.startButton.Enable = 'on';
hObject.Enable = 'off';

% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rec = getappdata(handles.mainWindow, 'recorder');
rec.start()
handles.stopButton.Enable = 'on';
hObject.Enable = 'off';

% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow, 'recorder');
rec.stop()
handles.initButton.Enable = 'on';
hObject.Enable = 'off';


% --- Executes during object creation, after setting all properties.
function dataPicker1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function functionPicker1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function xMaxSlider1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes during object creation, after setting all properties.
function yMaxSlider1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function dataPicker2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function functionPicker2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function xMaxSlider2_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes during object creation, after setting all properties.
function yMaxSlider2_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function dataPicker3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function functionPicker3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function xMaxSlider3_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes during object creation, after setting all properties.
function yMaxSlider3_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function dataPicker4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function functionPicker4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function xMaxSlider4_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes during object creation, after setting all properties.
function yMaxSlider4_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function dataPicker5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function functionPicker5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function xMaxSlider5_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes during object creation, after setting all properties.
function yMaxSlider5_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function dataPicker6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function functionPicker6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function xMaxSlider6_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes during object creation, after setting all properties.
function yMaxSlider6_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function dataPicker7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function functionPicker7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function xMaxSlider7_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes during object creation, after setting all properties.
function yMaxSlider7_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function dataPicker8_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function functionPicker8_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function xMaxSlider8_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes during object creation, after setting all properties.
function yMaxSlider8_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on selection change in dataPicker1.
function dataPicker1_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
rec.chAxes(1,3,newSource-1);


% --- Executes on selection change in dataPicker2.
function dataPicker2_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
rec.chAxes(2,3,newSource-1);

% --- Executes on selection change in dataPicker3.
function dataPicker3_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
rec.chAxes(3,3,newSource-1);

% --- Executes on selection change in dataPicker4.
function dataPicker4_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
rec.chAxes(4,3,newSource-1);

% --- Executes on selection change in dataPicker5.
function dataPicker5_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
rec.chAxes(5,3,newSource-1);

% --- Executes on selection change in dataPicker6.
function dataPicker6_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
rec.chAxes(6,3,newSource-1);

% --- Executes on selection change in dataPicker7.
function dataPicker7_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
rec.chAxes(7,3,newSource-1);

% --- Executes on selection change in dataPicker8.
function dataPicker8_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
rec.chAxes(8,3,newSource-1);

% --- Executes on selection change in functionPicker1.
function functionPicker1_Callback(hObject, eventdata, handles)
% --- Executes on selection change in functionPicker2.
function functionPicker2_Callback(hObject, eventdata, handles)
% --- Executes on selection change in functionPicker3.
function functionPicker3_Callback(hObject, eventdata, handles)
% --- Executes on selection change in functionPicker4.
function functionPicker4_Callback(hObject, eventdata, handles)
% --- Executes on selection change in functionPicker5.
function functionPicker5_Callback(hObject, eventdata, handles)
% --- Executes on selection change in functionPicker6.
function functionPicker6_Callback(hObject, eventdata, handles)
% --- Executes on selection change in functionPicker7.
function functionPicker7_Callback(hObject, eventdata, handles)
% --- Executes on selection change in functionPicker8.
function functionPicker8_Callback(hObject, eventdata, handles)



% --- Executes on slider movement.
function xMaxSlider1_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.chAxes(1,1,scale);
% --- Executes on slider movement.
function xMaxSlider2_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.chAxes(2,1,scale);
% --- Executes on slider movement.
function xMaxSlider3_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.chAxes(3,1,scale);
% --- Executes on slider movement.
function xMaxSlider4_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.chAxes(4,1,scale);
% --- Executes on slider movement.
function xMaxSlider5_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.chAxes(5,1,scale);
% --- Executes on slider movement.
function xMaxSlider6_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.chAxes(6,1,scale);
% --- Executes on slider movement.
function xMaxSlider7_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.chAxes(7,1,scale);
% --- Executes on slider movement.
function xMaxSlider8_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.chAxes(8,1,scale);




% --- Executes on slider movement.
function yMaxSlider1_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.chAxes(1,2,scale);
% --- Executes on slider movement.
function yMaxSlider2_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.chAxes(2,2,scale);
% --- Executes on slider movement.
function yMaxSlider3_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.chAxes(3,2,scale);
% --- Executes on slider movement.
function yMaxSlider4_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.chAxes(4,2,scale);
% --- Executes on slider movement.
function yMaxSlider5_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.chAxes(5,2,scale);
% --- Executes on slider movement.
function yMaxSlider6_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.chAxes(6,2,scale);
% --- Executes on slider movement.
function yMaxSlider7_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.chAxes(7,2,scale);
% --- Executes on slider movement.
function yMaxSlider8_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.chAxes(8,2,scale);


function channelListBox_Callback(hObject, eventdata, handles)

function channelListBox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function globalXscaleSlider_Callback(hObject, eventdata, handles)
% hObject    handle to globalXscaleSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function globalXscaleSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to globalXscaleSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
