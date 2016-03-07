function varargout = simulinkSettings(varargin)
%SIMULINKSETTINGS M-file for simulinkSettings.fig
%      SIMULINKSETTINGS, by itself, creates a new SIMULINKSETTINGS or raises the existing
%      singleton*.
%
%      H = SIMULINKSETTINGS returns the handle to a new SIMULINKSETTINGS or the handle to
%      the existing singleton*.
%
%      SIMULINKSETTINGS('Property','Value',...) creates a new SIMULINKSETTINGS using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to simulinkSettings_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SIMULINKSETTINGS('CALLBACK') and SIMULINKSETTINGS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SIMULINKSETTINGS.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simulinkSettings

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
rapidObject=getappdata(handle2main,'rapidObject');
guidata(hObject, handles);% Update handles structure
string = mfilename('fullpath');
string = string(1:end-length(mfilename)-5);
path = strcat(string,'\model');
set(handles.Simulink_modelpath_edit,'String',path);
set(handles.simulinkModelName_edit,'String','test.mdl');
set(handles.FMUBlockName_edit,'String','FMUme');
set(handles.timeStep_edit,'String',rapidObject.experimentSettings.ts);
set(handles.simLength_edit,'String',rapidObject.experimentSettings.tf);
set(handles.timeOut_edit,'String',rapidObject.experimentSettings.timeOut);
set(handles.intMethod_edit,'String',rapidObject.experimentSettings.integrationMethod);
set(handles.history_togglebutton,'Value',rapidObject.experimentSettings.saveHist);
set(handles.costType_edit,'String',num2str(rapidObject.experimentSettings.cost_type));
tmp=rapidObject.experimentSettings;
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
if ~isempty(rapidObject.fmuInputNames)
    tmp1=(rapidObject.fmuInputNames);
else
    tmp1=dummy;
end

tmp7=rapidObject.experimentSettings.objective_weights;

maxAlloc=max([length(tmp1),length(rapidObject.fmuOutputNames),length(rapidObject.parameterNames)])+1; %allocate space for the longest vector and and an extra editable field
dataAlloc=cell(7,maxAlloc);
dataAlloc(1,1:length(tmp1))=tmp1;
dataAlloc(2,1:length(rapidObject.fmuOutputNames))=rapidObject.fmuOutputNames;
dataAlloc(3,1:length(rapidObject.parameterNames))=rapidObject.parameterNames;
if ~isempty(rapidObject.experimentSettings.p_min)
   
    dataAlloc(4,1:length(rapidObject.experimentSettings.p_min))=num2cell( rapidObject.experimentSettings.p_min);
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
function InputNames_CellEditCallback(hObject, eventdata, handles)
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
inoutData=theData(1:2,:);
parameterData=theData(3:end,:);
% for some reason the table wants to convert to num often?? Taking care of
% it below
%if non-empty string entered
if  ~isempty(eventdata.EditData) % enter data
    if indices(1)<3
        inoutData(indices(1),indices(2))={eventdata.EditData};
    elseif indices(1)==3;
        parameterData(indices(1)-2,indices(2))={eventdata.EditData};
    else
        if ~isnumeric (eventdata.NewData)
            tempData=str2double(eventdata.NewData);
            if isnan(eventdata.NewData)
                warning Please enter a numeric value
            end
        else
            tempData = eventdata.NewData;
        end
        parameterData(indices(1)-2,indices(2))={tempData};
    end
else  %delete data
    if indices(1)<3 
        inoutData(indices(1),indices(2))=cell(1,1);
        if all(cellfun(@isempty,inoutData(:,indices(2))))
            inoutData(:,indices(2))=[];
        end
    elseif indices(1)==3
        parameterData(indices(1)-2,indices(2))=cell(1,1);
        if cellfun(@isempty,parameterData(:,indices(2)))
            parameterData(:,find(all(cellfun(@isempty,parameterData))))='';
        end
    else
        parameterData(indices(1)-2,indices(2))=cell(1,1);
        if cellfun(@isempty,parameterData(:,indices(2)))
            parameterData(:,find(all(cellfun(@isempty,parameterData))))=[];
        end
    end
 
end
if size(inoutData,2)>size(parameterData,2)
    tmp=size(inoutData,2)+1-all(cellfun(@isempty,inoutData(:,end)));
elseif size(inoutData,2)<size(parameterData,2)
    tmp=size(parameterData,2)+1-all(cellfun(@isempty,parameterData(:,end)));
else
    tmp=size(parameterData,2)+1-(all(cellfun(@isempty,inoutData(:,end)))&& all(cellfun(@isempty,parameterData(:,end))));
end
theData=cell(7,tmp);
tmp=size(inoutData,2);
theData(1:2,1:tmp)=inoutData;
theData(3:7,1:size(parameterData,2))=parameterData;
set(hObject,'Data',theData);
set(hObject,'ColumnEditable',true(ones(1,size(theData,2)))); 
tmp7=num2cell(max(2+max(cellfun(@(x)length(x),theData)),10)); % max width + 2 per col. or 10
fontsize=0.65*get(handles.uitable1,'Fontsize'); % assume width is ~65% of height
set(handles.uitable1,'ColumnWidth',cellfun(@(x)(x*fontsize),tmp7,'UniformOutput', false));  
tmp2=cell([1,tmp]);
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
rapidObject=getappdata(handle2main,'rapidObject');
open_system(rapidObject.experimentSettings.pathToSimulinkModel)
% TODO add so that it is runnable!


function saveAll(handles)
handle2main=getappdata(0,'HandleMainGUI');
rapidObject=getappdata(handle2main,'rapidObject');
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
