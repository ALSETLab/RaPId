function varargout = odeSettings(varargin)
%ODESETTINGS is the GUI to view and modify the settings used when using the Matlab-based ODE-solvers in
% the RaPId Toolbox. It is, and should only, be called from the function rapidMainWindow.
%
%      ODESETTINGS, by itself, creates a new ODESETTINGS or raises the existing
%      singleton.
%
%      ODESETTINGS('CALLBACK') and ODESETTINGS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in ODESETTINGS.m with the given input
%      arguments.
%
% See also: RAPID, SIMULINKSETTINGS, RAPIDMAINWINDOW, GUIDE

%% <Rapid Parameter Identification is a toolbox for automated parameter identification>
%
% Copyright 2016-2015 Luigi Vanfretti, Achour Amazouz, Maxime Baudette, 
% Tetiana Bogodorova, Jan Lavenius, Tin Rabuzin, Giuseppe Laera, 
% Francisco Gomez-Lopez
% 
% The authors can be contacted by email: luigiv at kth dot se
% 
% This file is part of Rapid Parameter Identification ("RaPId") .
% 
% RaPId is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RaPId is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Lesser General Public License
% along with RaPId.  If not, see <http://www.gnu.org/licenses/>.

% Last Modified by GUIDE v2.5 03-Mar-2016 20:50:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @odeSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @odeSettings_OutputFcn, ...
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


% --- Executes just before odeSettings is made visible.
function odeSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

handles.output = hObject;
handle2main=getappdata(0,'HandleMainGUI');
rapidObject=getappdata(handle2main,'rapidObject');
guidata(hObject, handles);% Update handles structure

set(handles.timeStep_edit,'String',rapidObject.experimentSettings.ts);
set(handles.simLength_edit,'String',rapidObject.experimentSettings.tf);
set(handles.timeOut_edit,'String',rapidObject.experimentSettings.timeOut);
set(handles.intMethod_edit,'String',rapidObject.experimentSettings.integrationMethod);
set(handles.history_togglebutton,'Value',rapidObject.experimentSettings.saveHist);
set(handles.costType_edit,'String',num2str(rapidObject.experimentSettings.cost_type));
tmp=rapidObject.experimentSettings;
if isfield(tmp,'pathToFmuModel')
    set(handles.FMU_filepath_edit,'String',tmp.pathToFmuModel);
end
dummy=cellstr(['';'']); %make sure that we have no empty cell arrays
if ~isempty(rapidObject.fmuInputNames)
    tmp1=(rapidObject.fmuInputNames);
else
    tmp1=dummy;
end

tmp7=(rapidObject.experimentSettings.objective_weights);

maxAlloc=max([length(tmp1),length(rapidObject.fmuOutputNames),length(rapidObject.parameterNames)])+1; %allocate space for the longest vector and and an extra editable field
dataAlloc=cell(7,maxAlloc);
dataAlloc(1,1:length(tmp1))=tmp1;
dataAlloc(2,1:length(rapidObject.fmuOutputNames))=rapidObject.fmuOutputNames;
dataAlloc(3,1:length(rapidObject.parameterNames))=rapidObject.parameterNames;
if ~isempty(rapidObject.experimentSettings.p_min)
    dataAlloc(4,1:length(rapidObject.experimentSettings.p_min))=num2cell(rapidObject.experimentSettings.p_min);
end
if ~isempty(rapidObject.experimentSettings.p_min)
    dataAlloc(5,1:length(rapidObject.experimentSettings.p_max))=num2cell(rapidObject.experimentSettings.p_max);
end
if ~isempty(rapidObject.experimentSettings.p_min)
    dataAlloc(6,1:length(rapidObject.experimentSettings.p_0))=num2cell(rapidObject.experimentSettings.p_0);
end
dataAlloc(7,1:length(tmp7))=num2cell(tmp7);
set(handles.uitable1,'Data',dataAlloc);
set(handles.uitable1,'ColumnEditable',true(ones(1,maxAlloc)));
tmp7=num2cell(max(2+max(cellfun(@(x)length(x),dataAlloc)),10)); % max width + 2 per col. or 10
fontsize=0.65*get(handles.uitable1,'Fontsize'); % assume width is ~65% of height
set(handles.uitable1,'ColumnWidth',cellfun(@(x)(x*fontsize),tmp7,'UniformOutput', false));  
tmp8=cell([1,maxAlloc]);
tmp8=cellfun(@(x){'char'},tmp8);
set(handles.uitable1,'ColumnFormat',tmp8);
if (get(handles.history_togglebutton,'Value'))==1
    set(handles.history_togglebutton,'String','Save History: On')
else
    set(handles.history_togglebutton,'String','Save History: Off')
end
if rapidObject.experimentSettings.verbose==1
    tmp2=1;
else
    tmp2=0;
end
set(handles.verbose_togglebutton,'Value',tmp2);
if (get(handles.verbose_togglebutton,'Value'))==1
    set(handles.verbose_togglebutton,'String','Verbose: On')
else
    set(handles.verbose_togglebutton,'String','Verbose: Off')
end
try
    set(handles.maxIterations_edit,'String',int2str(rapidObject.experimentSettings.maxIterations))
end

try
    set(handles.waitUntilFitness_edit,'String',num2str(rapidObject.experimentSettings.t_fitness_start));
end
if isprop(rapidObject,'experimentData') && isfield(rapidObject.experimentData, 'pathToReferenceData')  %we take care of Data settings pane in the next few lines
        set(handles.measuredOutputPath_edit,'String',rapidObject.experimentData.pathToReferenceData);
        set(handles.measuredTime_edit,'String',rapidObject.experimentData.expressionReferenceTime);
        set(handles.measuredOutputData_edit,'String',rapidObject.experimentData.expressionReferenceData);
        if isfield(rapidObject.experimentData,'pathToInData')
            set(handles.inputPath_edit,'String',rapidObject.experimentData.pathToInData);
            set(handles.inputTime_edit,'String',rapidObject.experimentData.expressionInDataTime);
            set(handles.inputData_edit,'String',rapidObject.experimentData.expressionInData);
        end
end


% UIWAIT makes odeSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = odeSettings_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% Model Path Settings Pane


% --- Executes on button press in FMU_filepath_pushbutton.
function FMU_filepath_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to FMU_filepath_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FILENAME, PATHNAME] = uigetfile({'*.fmu','FMU-files'},'Select the FMU file that you want to simulate (NB only FMI 1.0 for ODE-solving!)');
set(handles.FMU_filepath_edit,'String',fullfile(PATHNAME,FILENAME))


function FMU_filepath_edit_Callback(hObject, eventdata, handles)
% hObject    handle to FMU_filepath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FMU_filepath_edit as text
%        str2double(get(hObject,'String')) returns contents of FMU_filepath_edit as a double


% --- Executes during object creation, after setting all properties.
function FMU_filepath_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FMU_filepath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% end model path settings pane
%% Data Settings Pane
% --- Executes on button press in measuredOutputButton.
function measuredOutputButton_Callback(hObject, eventdata, handles)
% hObject    handle to measuredOutputButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile();
set(handles.measuredOutputPath_edit,'String',strcat(pathname,filename));


function measuredOutputPath_edit_Callback(hObject, eventdata, handles)
% hObject    handle to measuredOutputPath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measuredOutputPath_edit as text
%        str2double(get(hObject,'String')) returns contents of measuredOutputPath_edit as a double


% --- Executes during object creation, after setting all properties.
function measuredOutputPath_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measuredOutputPath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in inputDataPath_pushbutton.
function inputDataPath_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to inputDataPath_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile();
set(handles.inputPath_edit,'String',strcat(pathname,filename));


function inputPath_edit_Callback(hObject, eventdata, handles)
% hObject    handle to inputPath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputPath_edit as text
%        str2double(get(hObject,'String')) returns contents of inputPath_edit as a double


% --- Executes during object creation, after setting all properties.
function inputPath_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputPath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function inputTime_edit_Callback(hObject, eventdata, handles)
% hObject    handle to inputTime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputTime_edit as text
%        str2double(get(hObject,'String')) returns contents of inputTime_edit as a double


% --- Executes during object creation, after setting all properties.
function inputTime_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputTime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inputData_edit_Callback(hObject, eventdata, handles)
% hObject    handle to inputData_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputData_edit as text
%        str2double(get(hObject,'String')) returns contents of inputData_edit as a double


% --- Executes during object creation, after setting all properties.
function inputData_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputData_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function measuredTime_edit_Callback(hObject, eventdata, handles)
% hObject    handle to measuredTime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measuredTime_edit as text
%        str2double(get(hObject,'String')) returns contents of measuredTime_edit as a double


% --- Executes during object creation, after setting all properties.
function measuredTime_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measuredTime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function measuredOutputData_edit_Callback(hObject, eventdata, handles)
% hObject    handle to measuredOutputData_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measuredOutputData_edit as text
%        str2double(get(hObject,'String')) returns contents of measuredOutputData_edit as a double


% --- Executes during object creation, after setting all properties.
function measuredOutputData_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measuredOutputData_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
indices=eventdata.Indices;
theData=get(hObject,'Data');
% for some reason the table wants to convert to num often?? Taking care of
% it below
%if non-empty string entered
if  ~isempty(eventdata.EditData) % enter data
    if indices(1)<3
        theData{indices(1),indices(2)}=eventdata.EditData;
    elseif indices(1)==3;
        theData{indices(1),indices(2)}=eventdata.EditData;
    else
        if ~isnumeric (eventdata.NewData)
            theData{indices(1),indices(2)}=str2double(eventdata.NewData);
            if isnan(eventdata.NewData)
                warning('Please enter a numeric value')
            end
        else
            theData{indices(1),indices(2)} = eventdata.NewData;
        end
    end
    if indices(2)==size(theData,2)
        theData(:,indices(2)+1)=cell(size(theData,1),1);
    end
else  %delete data
    if indices(1)<3 
        theData(indices(1),indices(2))=cell(1,1);
        if all(cellfun(@isempty,theData(:,indices(2)))) &&  indices(2)~=size(theData,2)
            theData(:,indices(2))=[];
        end
    elseif indices(1)==3
        theData(indices(1),indices(2))=cell(1,1);
        if all(cellfun(@isempty,theData(:,indices(2)))) &&  indices(2)~=size(theData,2)
            theData(:,indices(2))=[];
        end
    else
        theData(indices(1),indices(2))=cell(1,1);
        if all(cellfun(@isempty,theData(:,indices(2)))) &&  indices(2)~=size(theData,2)
            theData(:,indices(2))=[];
        end
    end
 
end
set(hObject,'Data',theData);
set(hObject,'ColumnEditable',true(ones(1,size(theData,2)))); 
tmp7=num2cell(max(2+max(cellfun(@(x)length(x),theData)),10)); % max width + 2 per col. or 10
fontsize=0.65*get(handles.uitable1,'Fontsize'); % assume width is ~65% of height
set(handles.uitable1,'ColumnWidth',cellfun(@(x)(x*fontsize),tmp7,'UniformOutput', false));  
tmp2=cell([1,size(theData,2)]);
set(handles.uitable1,'ColumnFormat',cellfun(@(x){'char'},tmp2));

% --- Executes when selected cell(s) is changed in uitable1.
function InputNames_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
% end of data settings pane
%% General Settings pane
function maxIterations_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxIterations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxIterations_edit as text
%        str2double(get(hObject,'String')) returns contents of maxIterations_edit as a double


% --- Executes during object creation, after setting all properties.
function maxIterations_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxIterations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function simLength_edit_Callback(hObject, eventdata, handles)
% hObject    handle to simLength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of simLength_edit as text
%        str2double(get(hObject,'String')) returns contents of simLength_edit as a double


% --- Executes during object creation, after setting all properties.
function simLength_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simLength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function timeStep_edit_Callback(hObject, eventdata, handles)
% hObject    handle to timeStep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeStep_edit as text
%        str2double(get(hObject,'String')) returns contents of timeStep_edit as a double


% --- Executes during object creation, after setting all properties.
function timeStep_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeStep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function waitUntilFitness_edit_Callback(hObject, eventdata, handles)
% hObject    handle to waitUntilFitness_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of waitUntilFitness_edit as text
%        str2double(get(hObject,'String')) returns contents of waitUntilFitness_edit as a double


% --- Executes during object creation, after setting all properties.
function waitUntilFitness_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waitUntilFitness_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function costType_edit_Callback(hObject, eventdata, handles)
% hObject    handle to costType_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of costType_edit as text
%        str2double(get(hObject,'String')) returns contents of costType_edit as a double


% --- Executes during object creation, after setting all properties.
function costType_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to costType_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function verbose_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to verbose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of verbose
if get(hObject,'Value')==1
    set(hObject,'String','Verbose: On')
else
    set(hObject,'String','Verbose: Off')
end


function timeOut_edit_Callback(hObject, eventdata, handles)
% hObject    handle to timeOut_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeOut_edit as text
%        str2double(get(hObject,'String')) returns contents of timeOut_edit as a double


% --- Executes during object creation, after setting all properties.
function timeOut_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeOut_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in history_togglebutton.
function history_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to history_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of history_togglebutton
if get(hObject,'Value')==1
    set(hObject,'String','Save History: On')
else
    set(hObject,'String','Save History: Off')
end

function intMethod_edit_Callback(hObject, eventdata, handles)
% hObject    handle to intMethod_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intMethod_edit as text
%        str2double(get(hObject,'String')) returns contents of intMethod_edit as a double


% --- Executes during object creation, after setting all properties.
function intMethod_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intMethod_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% end of General Settings pane
%% Buttons at bottom

% --- Executes on button press in closeModelSettings_pushbutton.
function closeModelSettings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handle2main=getappdata(0,'HandleMainGUI');
rapidObject=getappdata(handle2main,'rapidObject');
subsettings.ts = str2double(get(handles.timeStep_edit,'String'));
subsettings.tf = str2double(get(handles.simLength_edit,'String'));
subsettings.verbose = get(handles.verbose_togglebutton,'Value');
subsettings.cost_type = str2double(get(handles.costType_edit,'String'));
subsettings.integrationMethod = get(handles.intMethod_edit,'String');
subsettings.maxIterations = str2double(get(handles.maxIterations_edit,'String'));
subsettings.t_fitness_start = (get(handles.waitUntilFitness_edit,'String'));
subsettings.timeOut = str2double(get(handles.timeOut_edit,'String'));
subsettings.saveHist=get(handles.history_togglebutton,'Value');
tmp=get(handles.uitable1,'Data');
% Make sure that everything is 
rapidObject.fmuInputNames = tmp(1,~cellfun(@isempty,tmp(1,:)));
rapidObject.fmuOutputNames = tmp(2,~cellfun(@isempty,tmp(2,:)));
rapidObject.parameterNames = tmp(3,~cellfun(@isempty,tmp(3,:)));
subsettings.p_min = cell2mat(tmp(4,~cellfun(@isempty,tmp(4,:)))); 
subsettings.p_max = cell2mat(tmp(5,~cellfun(@isempty,tmp(5,:))));
subsettings.p_0 =   cell2mat(tmp(6,~cellfun(@isempty,tmp(6,:))));
subsettings.objective_weights = cell2mat(tmp(7,~cellfun(@isempty,tmp(7,:))));
rapidObject.experimentSettings = setstructfields(rapidObject.experimentSettings,subsettings);
rapidObject.experimentData.expressionReferenceTime = get(handles.measuredTime_edit,'String');
rapidObject.experimentData.expressionReferenceData = get(handles.measuredOutputData_edit,'String');
rapidObject.experimentData.pathToReferenceData = get(handles.measuredOutputPath_edit,'String');
rapidObject.experimentData.expressionInDataTime = get(handles.inputTime_edit,'String');
rapidObject.experimentData.expressionInData = get(handles.inputData_edit,'String');
rapidObject.experimentData.pathToInData = get(handles.inputPath_edit,'String');
rapidObject.experimentSettings.pathToFmuModel = get(handles.FMU_filepath_edit,'String');
close(handles.odeSettings)
