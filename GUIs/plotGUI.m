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

if ~isempty(varargin)
	directory = varargin{1};
	basename = varargin{2};
	chList = varargin{3}; %given as array of numbers referring to 
						  %active channels i.e. if channels 1, 3, and 5 
						  %are active, chList=[1,3,5]
						  
	totalGain = varargin{4}; %scalar representing total gain through DAQ
	
	srate = varargin{5}; %sample rate given in hertz, should equal nyquist
	
	daqGain = varargin{6}; %value can be 1, 2, 4, or 8. The number is
						   %used to set the analog input object's attribute
						   %'gainperchan' which sets the range of possible
						   %recorded values						
else
	directory = 'C:\';
	chList = [1 2 4 8];
	totalGain = 1000;
	srate = 9001;
end
set(handles.pathDisplay, 'String', directory); %sets display for saving
											   %directory
setappdata(hObject,'gain',totalGain)
setappdata(hObject,'srate',srate)
									
%%
setappdata(hObject, 'chList', chList)
textChList=cell(length(chList)+1,1);
for a=1:length(chList)+1
	if a==1
		textChList{a} = 'No Source';
	else
	textChList{a} = sprintf('Channel %02d',chList(a-1)); 
	end
end
for a=1:8
	handles.(sprintf('dataPicker%d',a)).String = textChList;
end
handles.channelListBox.String = textChList;
%%


recorder = liveRecord(directory, basename, chList, srate, daqGain);
plots = {handles.plot1 handles.plot2 handles.plot3 handles.plot4 ...
	handles.plot5 handles.plot6 handles.plot7 handles.plot8};
recorder.setAxes(plots)

recorder.setSampleCounter(handles.samplesText);
setappdata(hObject,'recorder',recorder);
guidata(hObject, handles);
uiwait(handles.mainWindow)



% --- Outputs from this function are returned to the command line.
function varargout = plotGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
varargout{1} = handles;

% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rec = getappdata(handles.mainWindow, 'recorder');
rec.start()

% --- Executes on button press in pauseButton.
function pauseButton_Callback(hObject, eventdata, handles)

% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow, 'recorder');
rec.stop()



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
if newSource == 1
    rec.setDataSource(1,'')
else
    rec.setDataSource(1,newSource-1)
end

% --- Executes on selection change in dataPicker2.
function dataPicker2_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
if newSource == 1
    rec.setDataSource(2,'')
else
    rec.setDataSource(2,newSource-1)
end

% --- Executes on selection change in dataPicker3.
function dataPicker3_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
if newSource == 1
    rec.setDataSource(3,'')
else
    rec.setDataSource(3,newSource-1)
end

% --- Executes on selection change in dataPicker4.
function dataPicker4_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
if newSource == 1
    rec.setDataSource(4,'')
else
    rec.setDataSource(4,newSource-1)
end

% --- Executes on selection change in dataPicker5.
function dataPicker5_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
if newSource == 1
    rec.setDataSource(5,'')
else
    rec.setDataSource(5,newSource-1)
end

% --- Executes on selection change in dataPicker6.
function dataPicker6_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
if newSource == 1
    rec.setDataSource(6,'')
else
    rec.setDataSource(6,newSource-1)
end

% --- Executes on selection change in dataPicker7.
function dataPicker7_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
if newSource == 1
    rec.setDataSource(7,'')
else
    rec.setDataSource(7,newSource-1)
end

% --- Executes on selection change in dataPicker8.
function dataPicker8_Callback(hObject, eventdata, handles)
rec = getappdata(handles.mainWindow,'recorder');
newSource = get(hObject,'Value');
if newSource == 1
    rec.setDataSource(8,'')
else
    rec.setDataSource(8,newSource-1)
end

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
    rec.scaleLims('x',1,scale);
% --- Executes on slider movement.
function xMaxSlider2_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.scaleLims('x',2,scale);
% --- Executes on slider movement.
function xMaxSlider3_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.scaleLims('x',3,scale);
% --- Executes on slider movement.
function xMaxSlider4_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.scaleLims('x',4,scale);
% --- Executes on slider movement.
function xMaxSlider5_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.scaleLims('x',5,scale);
% --- Executes on slider movement.
function xMaxSlider6_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.scaleLims('x',6,scale);
% --- Executes on slider movement.
function xMaxSlider7_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.scaleLims('x',7,scale);
% --- Executes on slider movement.
function xMaxSlider8_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = round(hObject.Value,1);
    rec.scaleLims('x',8,scale);




% --- Executes on slider movement.
function yMaxSlider1_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.scaleLims('y',1,scale);
% --- Executes on slider movement.
function yMaxSlider2_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.scaleLims('y',2,scale);
% --- Executes on slider movement.
function yMaxSlider3_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.scaleLims('y',3,scale);
% --- Executes on slider movement.
function yMaxSlider4_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.scaleLims('y',4,scale);
% --- Executes on slider movement.
function yMaxSlider5_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.scaleLims('y',5,scale);
% --- Executes on slider movement.
function yMaxSlider6_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.scaleLims('y',6,scale);
% --- Executes on slider movement.
function yMaxSlider7_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.scaleLims('y',7,scale);
% --- Executes on slider movement.
function yMaxSlider8_Callback(hObject, eventdata, handles)
    rec = getappdata(handles.mainWindow,'recorder');
    scale = hObject.Value;
    rec.scaleLims('y',8,scale);


function channelListBox_Callback(hObject, eventdata, handles)

function channelListBox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
