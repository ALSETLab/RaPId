function varargout = simulinkSettings(varargin)
%SIMULINKSETTINGS is the GUI to view and modify the Simulink-related settings in
% the RaPId Toolbox. It is, and should only, be called from the function rapidMainWindow.
%
%      SIMULINKSETTINGS, by itself, creates a new SIMULINKSETTINGS or raises the existing
%      singleton.
%
%      SIMULINKSETTINGS('CALLBACK') and SIMULINKSETTINGS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SIMULINKSETTINGS.m with the given input
%      arguments.
%
%
% See also: RAPID, ODESETTINGS, RAPIDMAINWINDOW, GUIDE

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

% Last Modified by GUIDE v2.5 03-Mar-2016 18:57:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simulinkSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @simulinkSettings_OutputFcn, ...
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


% --- Executes just before simulinkSettings is made visible.
function simulinkSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

handles.output = hObject;
handle2main=getappdata(0,'HandleMainGUI');
rapidSettings=getappdata(handle2main,'rapidSettings');
guidata(hObject, handles);% Update handles structure
set(handles.timeStep_edit,'String',rapidSettings.experimentSettings.ts);
set(handles.simLength_edit,'String',rapidSettings.experimentSettings.tf);
set(handles.timeOut_edit,'String',rapidSettings.experimentSettings.timeOut);
set(handles.intMethod_edit,'String',rapidSettings.experimentSettings.integrationMethod);
set(handles.history_togglebutton,'Value',rapidSettings.experimentSettings.saveHist);
set(handles.costType_edit,'String',num2str(rapidSettings.experimentSettings.cost_type));
tmp=rapidSettings.experimentSettings;
if isfield(tmp,'pathToSimulinkModel')
    set(handles.Simulink_modelpath_edit,'String',tmp.pathToSimulinkModel);
end
if isfield(tmp,'modelName')
    set(handles.simulinkModelName_edit,'String',tmp.modelName);
end
if isfield(tmp,'blockName')
    set(handles.FMUBlockName_edit,'String',tmp.blockName);
end
if isfield(tmp,'scopeName')
    set(handles.scopeName_edit,'String',tmp.scopeName);
end
dummy=cellstr(['';'']); %make sure that we have no empty cell arrays
if ~isempty(rapidSettings.fmuInputNames)
    tmp1=(rapidSettings.fmuInputNames);
else
    tmp1=dummy;
end

tmp7=rapidSettings.experimentSettings.objective_weights;

maxAlloc=max([length(tmp1),length(rapidSettings.fmuOutputNames),length(rapidSettings.parameterNames)])+1; %allocate space for the longest vector and and an extra editable field
dataAlloc=cell(7,maxAlloc);
dataAlloc(1,1:length(tmp1))=tmp1;
dataAlloc(2,1:length(rapidSettings.fmuOutputNames))=rapidSettings.fmuOutputNames;
dataAlloc(3,1:length(rapidSettings.parameterNames))=rapidSettings.parameterNames;
if ~isempty(rapidSettings.experimentSettings.p_min)
   
    dataAlloc(4,1:length(rapidSettings.experimentSettings.p_min))=num2cell( rapidSettings.experimentSettings.p_min);
end
if ~isempty(rapidSettings.experimentSettings.p_min)
    dataAlloc(5,1:length(rapidSettings.experimentSettings.p_max))=num2cell(rapidSettings.experimentSettings.p_max);
end
if ~isempty(rapidSettings.experimentSettings.p_min)
    dataAlloc(6,1:length(rapidSettings.experimentSettings.p_0))=num2cell(rapidSettings.experimentSettings.p_0);
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
if rapidSettings.experimentSettings.verbose==1
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
    set(handles.maxIterations_edit,'String',int2str(rapidSettings.experimentSettings.maxIterations))
end

try
    set(handles.waitUntilFitness_edit,'String',num2str(rapidSettings.experimentSettings.t_fitness_start));
end
if isprop(rapidSettings,'experimentData') && isfield(rapidSettings.experimentData, 'pathToReferenceData')  %we take care of Data settings pane in the next few lines
        set(handles.measuredOutputPath_edit,'String',rapidSettings.experimentData.pathToReferenceData);
        set(handles.measuredTime_edit,'String',rapidSettings.experimentData.expressionReferenceTime);
        set(handles.measuredOutputData_edit,'String',rapidSettings.experimentData.expressionReferenceData);
        if isfield(rapidSettings.experimentData,'pathToInData')
            set(handles.inputPath_edit,'String',rapidSettings.experimentData.pathToInData);
            set(handles.inputTime_edit,'String',rapidSettings.experimentData.expressionInDataTime);
            set(handles.inputData_edit,'String',rapidSettings.experimentData.expressionInData);
        end
end


% UIWAIT makes simulinkSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simulinkSettings_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% Model Path Settings Pane

% --- Executes on button press in Simulink_modelpath_pushbutton.
function Simulink_modelpath_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Simulink_modelpath_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FILENAME, PATHNAME] = uigetfile({'*.mdl;*.slx','Simulink-files'},'Select the Simulink file that contains the FMU block you want to simulate');


try
    load_system(strcat(PATHNAME,FILENAME));
    listOfFMUblocks=find_system(gcs,'regexp','on','Type','block','FunctionName','sfun_fmu_.');
    close_system(gcs);
    if isempty(listOfFMUblocks)
        disp('There seems to be no valid FMU-blocks in the Simulink model');
    elseif length(listOfFMUblocks)==1
        FMUblock=listOfFMUblocks{:};
        set(handles.FMUBlockName_edit,'String',FMUblock);
    end
catch err
    disp(err.message);
end
set(handles.Simulink_modelpath_edit,'String',strcat(PATHNAME,FILENAME));
set(handles.simulinkModelName_edit,'String',FILENAME);


function simulinkModelName_edit_Callback(hObject, eventdata, handles)
% hObject    handle to simulinkModelName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of simulinkModelName_edit as text
%        str2double(get(hObject,'String')) returns contents of simulinkModelName_edit as a double


% --- Executes during object creation, after setting all properties.
function simulinkModelName_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simulinkModelName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FMUBlockName_edit_Callback(hObject, eventdata, handles)
% hObject    handle to FMUBlockName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FMUBlockName_edit as text
%        str2double(get(hObject,'String')) returns contents of FMUBlockName_edit as a double


% --- Executes during object creation, after setting all properties.
function FMUBlockName_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FMUBlockName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scopeName_edit_Callback(hObject, eventdata, handles)
% hObject    handle to scopeName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scopeName_edit as text
%        str2double(get(hObject,'String')) returns contents of scopeName_edit as a double


% --- Executes during object creation, after setting all properties.
function scopeName_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scopeName_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Simulink_modelpath_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Simulink_modelpath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Simulink_modelpath_edit as text
%        str2double(get(hObject,'String')) returns contents of Simulink_modelpath_edit as a double


% --- Executes during object creation, after setting all properties.
function Simulink_modelpath_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Simulink_modelpath_edit (see GCBO)
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
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
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
saveAll(handles)
close(handles.simulinkSettings)



% --- Executes on button press in openSimulink_pushbutton.
function openSimulink_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to openSimulink_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveAll(handles)
handle2main=getappdata(0,'HandleMainGUI');
rapidSettings=getappdata(handle2main,'rapidSettings');
open_system(rapidSettings.experimentSettings.pathToSimulinkModel)
% TODO add so that it is runnable!


function saveAll(handles)
handle2main=getappdata(0,'HandleMainGUI');
rapidSettings=getappdata(handle2main,'rapidSettings');
subsettings.pathToSimulinkModel = get(handles.Simulink_modelpath_edit,'String');
subsettings.modelName = get(handles.simulinkModelName_edit,'String');
subsettings.blockName = get(handles.FMUBlockName_edit,'String');
subsettings.scopeName = get(handles.scopeName_edit,'String');
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
rapidSettings.fmuInputNames = tmp(1,~cellfun(@isempty,tmp(1,:)));
rapidSettings.fmuOutputNames = tmp(2,~cellfun(@isempty,tmp(2,:)));
rapidSettings.parameterNames = tmp(3,~cellfun(@isempty,tmp(3,:)));
subsettings.p_min = cell2mat(tmp(4,~cellfun(@isempty,tmp(4,:)))); 
subsettings.p_max = cell2mat(tmp(5,~cellfun(@isempty,tmp(5,:))));
subsettings.p_0 =   cell2mat(tmp(6,~cellfun(@isempty,tmp(6,:))));
subsettings.objective_weights = cell2mat(tmp(7,~cellfun(@isempty,tmp(7,:))));
rapidSettings.experimentSettings = setstructfields(rapidSettings.experimentSettings,subsettings);
rapidSettings.experimentData.expressionReferenceTime = get(handles.measuredTime_edit,'String');
rapidSettings.experimentData.expressionReferenceData = get(handles.measuredOutputData_edit,'String');
rapidSettings.experimentData.pathToReferenceData = get(handles.measuredOutputPath_edit,'String');
rapidSettings.experimentData.expressionInDataTime = get(handles.inputTime_edit,'String');
rapidSettings.experimentData.expressionInData = get(handles.inputData_edit,'String');
rapidSettings.experimentData.pathToInData = get(handles.inputPath_edit,'String');
