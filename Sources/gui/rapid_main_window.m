%% <Rapid Parameter Identification is a toolbox for automated parameter identification>
%
% Copyright 2015 Luigi Vanfretti, Achour Amazouz, Maxime Baudette, 
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


function varargout = rapid_main_window(varargin)
% RAPID_MAIN_WINDOW MATLAB code for rapid_main_window.fig
%      rapid_main_window, by itself, creates a new rapid_main_window or raises the existing
%      singleton*.
%
%      H = rapid_main_window returns the handle to a new rapid_main_window or the handle to
%      the existing singleton*.
%
%      rapid_main_window('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      rapid_main_window('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 08-Sep-2015 19:46:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @rapid_main_window_OpeningFcn, ...
    'gui_OutputFcn',  @rapid_main_window_OutputFcn, ...
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


% --- Executes just before main is made visible.
function rapid_main_window_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
setappdata(0,'HandleMainGUI',hObject);
try
    path2rapid=getPathToRapid();
    load(fullfile(path2rapid,'core\init\data.mat'),'RaPIdObject');%load standard settings...
    setappdata(handles.MainRaPiDWindow,'RaPIdObject',RaPIdObject);
catch err
    disp err;
    rethrow(err);
end
% if isfield(mySettings,'dataT')
%     set(handles.MeasuredOutputPath_EditableTextfield,'String',mySettings.path2data);
%     set(handles.OutputTimeVectorExpression_EditableTextfield,'String',mySettings.dataT);
%     set(handles.OutputArrayExpression_EditableTextfield,'String',mySettings.dataY);
%     
%     if isfield(mySettings,'inDat')
%         set(handles.InputArrayExpression_EditableTextfield,'String',mySettings.inDat.path);
%         set(handles.InputTimeVectorExpression_EditableTextfield,'String',mySettings.inDat.time);
%         set(handles.InputArrayExpression_EditableTextfield,'String',mySettings.inDat.signal);
%     end
% end


% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.MainRaPiDWindow);


% --- Outputs from this function are returned to the command line.
function varargout = rapid_main_window_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in OptimMethodSelect_popupmenu.
function OptimMethodSelect_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to OptimMethodSelect_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns OptimMethodSelect_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OptimMethodSelect_popupmenu
str = get(handles.OptimMethodSelect_popupmenu,'String');
RaPIdObject=getappdata(handles.MainRaPiDWindow,'RaPIdObject');
RaPIdObject.experimentSettings.optimizationAlgorithm = str{get(handles.OptimMethodSelect_popupmenu,'Value')};


% --- Executes during object creation, after setting all properties.
function OptimMethodSelect_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OptimMethodSelect_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OpenSimulink_pushbutton.
function OpenSimulink_pushbutton_Callback(hObject, eventdata, handles)

% hObject    handle to OpenSimulink_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RaPIdObject=getappdata(handles.MainRaPiDWindow,'RaPIdObject');
set(handles.text8,'String','Running and Visualizing Optimization.');
%set(handles.text8,'BackgroundColor','r');
RaPIdObject.experimentSettings.solverMode='Simulink';
RaPIdObject.experimentSettings.displayMode='Show';
% THIS STUFF MIGHT GO
try
        if exist(RaPIdObject.experimentSettings.pathToSimulinkModel,'file')
            tmp=RaPIdObject.experimentSettings.pathToSimulinkModel;
        elseif ~exist(RaPIdObject.experimentSettings.pathToSimulinkModel,'file') && exist(fullfile(evalin('base','pwd'),RaPIdObject.experimentSettings.pathToSimulinkModel),'file')
            tmp=fullfile(evalin('base','pwd'),RaPIdObject.experimentSettings.pathToSimulinkModel);
        end
            open_system(tmp); 

        % mySettings.realData = transpose(eval(mySettings.dataY));
       % mySettings.realTime = eval(mySettings.dataT);
catch err
    disp err
end


% --- Executes on button press in RunOptimization_pushbutton.
function RunOptimization_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RunOptimization_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RaPIdObject=getappdata(handles.MainRaPiDWindow,'RaPIdObject');
% mySettings.mode='Simulink';
% [mySettings.realTime, i_t]=unique(mySettings.realTime); % check that we only use unique time stamps
% mySettings.realData=mySettings.realData(i_t,:);

try
    tic
    [sol, hist] = rapid(RaPIdObject);
    assignin('base','sol',sol);
    assignin('base','hist',hist);
    toc
catch err
    set(handles.text8,'BackgroundColor','y');
    set(handles.text8,'String','error');
    rethrow(err);
end
set(handles.text8,'String','Simulation completed.');
set(handles.text8,'BackgroundColor','g');


% --- Executes on button press in OpenPlot_pushbutton.
function OpenPlot_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OpenPlot_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RaPIdObject=getappdata(handles.MainRaPiDWindow,'RaPIdObject');

if exist('sol','var')
    figure
    part.p = sol(1,:);
    [res] = rapid_simuSystem( part,RaPIdObject);
    identifiedSysData = mySettings.lastSimu.res;
    idTime = mySettings.lastSimu.time;
    resInterpo = rapid_interpolate(mySettings.realTime,idTime,identifiedSysData);
    for i = 1:length(mySettings.fmuOutData);
        subplot(100*ceil(length(mySettings.fmuOutData)/2)+20+i)
        plot(mySettings.realTime,mySettings.realData(i,:))
        hold on
        plot(idTime,identifiedSysData(i,:),'--r')
        
        plot(mySettings.realTime,resInterpo(i,:),'--g')
        
        title(mySettings.fmuOutData{i})
        legend('real sys', 'identified sys', 'interpolated data')
    end
else
    warning('No Data to plot...')
end


% --- Executes on button press in GAAlgoSettings_pushbutton.
function GAAlgoSettings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to GAAlgoSettings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gaSettings

% --- Executes on button press in GeneralSettings_pushbutton.
function GeneralSettings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to GeneralSettings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
generalSettings

% --- Executes on button press in PSOAlgoSettings_pushbutton.
function PSOAlgoSettings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PSOAlgoSettings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
psoSettings

% --- Executes on button press in NaiveAlgoSettings_pushbutton.
function NaiveAlgoSettings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to NaiveAlgoSettings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
naiveSettings

% --- Executes on button press in MiscOptions_pushbutton.
function MiscOptions_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to MiscOptions_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
otherSettings

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OpenSimulink_pushbutton.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to OpenSimulink_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RaPIdObject=getappdata(handles.MainRaPiDWindow,'RaPIdObject');
if exist(RaPIdObject.experimentSettings.pathToSimulinkModel,'file')
    open_system(RaPIdObject.experimentSettings.pathToSimulinkModel)
elseif ~exist(RaPIdObject.experimentSettings.pathToSimulinkModel,'file') && exist(fullfile(evalin('base','pwd'),RaPIdObject.experimentSettings.pathToSimulinkModel),'file')
    open_system(fullfile(evalin('base','pwd'),RaPIdObject.experimentSettings.pathToSimulinkModel))
end



function OutputTimeVectorExpression_EditableTextfield_Callback(hObject, eventdata, handles)
% hObject    handle to OutputTimeVectorExpression_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputTimeVectorExpression_EditableTextfield as text
%        str2double(get(hObject,'String')) returns contents of OutputTimeVectorExpression_EditableTextfield as a double


% --- Executes during object creation, after setting all properties.
function OutputTimeVectorExpression_EditableTextfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputTimeVectorExpression_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OutputArrayExpression_EditableTextfield_Callback(hObject, eventdata, handles)
% hObject    handle to OutputArrayExpression_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputArrayExpression_EditableTextfield as text
%        str2double(get(hObject,'String')) returns contents of OutputArrayExpression_EditableTextfield as a double


% --- Executes during object creation, after setting all properties.
function OutputArrayExpression_EditableTextfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputArrayExpression_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MeasuredOutputSelection_pushbutton.
function MeasuredOutputSelection_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to MeasuredOutputSelection_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile();
set(handles.MeasuredOutputPath_EditableTextfield,'String',strcat(pathname,filename));


% --- Executes on button press in SendSettings_pushbutton.
function SendSettings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to SendSettings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RaPIdObject=getappdata(handles.MainRaPiDWindow,'RaPIdObject');
RaPIdObject.experimentData.expressionReferenceTime = get(handles.OutputTimeVectorExpression_EditableTextfield,'String');
RaPIdObject.experimentData.expressionReferenceData = get(handles.OutputArrayExpression_EditableTextfield,'String');
RaPIdObject.experimentData.pathToReferenceData = get(handles.MeasuredOutputPath_EditableTextfield,'String');
RaPIdObject.experimentData.expressionInDataTime = get(handles.InputTimeVectorExpression_EditableTextfield,'String');
RaPIdObject.experimentData.expressionInData = get(handles.InputArrayExpression_EditableTextfield,'String');
RaPIdObject.experimentData.pathToInData = get(handles.PathToInputData_EditableTextfield,'String');

% --- Executes on button press in SaveContainer_pushbutton.
function SaveContainer_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveContainer_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RaPIdObject=getappdata(handles.MainRaPiDWindow,'RaPIdObject');
[filename, pathname] = uiputfile('*.mat');
if exist('sol','var')
    save(strcat(pathname,filename),'RaPIdObject','sol','hist');
else
    save(strcat(pathname,filename),'RaPIdObject')
end


% --- Executes on button press in LoadContainer_pushbutton.
function LoadContainer_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadContainer_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%RaPIdObject=getappdata(handles.MainRaPiDWindow,'RaPIdObject');
[filename, pathname] = uigetfile;
load(strcat(pathname,filename));
oldFolder = cd(pathname);
contentOfContainer=who('-file',strcat(pathname,filename));
if any(strcmp(contentOfContainer,'mySettings'))
        try
            RaPIdObject=RaPIdClass(mySettings);
            disp('Converted old container to new, please save this new container');
        catch err
            disp(err.message)
        end
end
if exist('RaPIdObject','var') && isa(RaPIdObject,'RaPIdClass')
    setappdata(handles.MainRaPiDWindow,'RaPIdObject',RaPIdObject);
    if ~isfield(RaPIdObject.experimentSettings,'optimizationAlgorithm') % if no algorithm set
        RaPIdObject.experimentSettings.optimizationAlgorithm='pso';%default to pso
    end
    tmp=find(strcmp(cellstr(get(handles.OptimMethodSelect_popupmenu,'String')),RaPIdObject.experimentSettings.optimizationAlgorithm)); % find which one in the list it is
    set(handles.OptimMethodSelect_popupmenu,'Value',tmp); %set selected item in list to reflect choice of algorithm
    
    if strcmp(RaPIdObject.experimentSettings.solverMode,'Simulink') % initialize radio buttons here
        tmp1=1;
    else
        tmp1=0;
    end
    set(handles.simulinkselector,'Value',tmp1);
    set(handles.odeselector,'Value',~tmp1);
    if isprop(RaPIdObject,'experimentData') && isfield(RaPIdObject.experimentData, 'pathToReferenceData')  %we take care of Data settings pane in the next few lines
        set(handles.MeasuredOutputPath_EditableTextfield,'String',RaPIdObject.experimentData.pathToReferenceData);
        set(handles.OutputTimeVectorExpression_EditableTextfield,'String',RaPIdObject.experimentData.expressionReferenceTime);
        set(handles.OutputArrayExpression_EditableTextfield,'String',RaPIdObject.experimentData.expressionReferenceData);
        if isfield(RaPIdObject.experimentData,'pathToInData')
            set(handles.PathToInputData_EditableTextfield,'String',RaPIdObject.experimentData.pathToInData);
            set(handles.InputTimeVectorExpression_EditableTextfield,'String',RaPIdObject.experimentData.expressionInDataTime);
            set(handles.InputArrayExpression_EditableTextfield,'String',RaPIdObject.experimentData.expressionInData);
        end
    end
else
    warning('Something went wrong, check the format of the container!')
end


% --- Executes on button press in LastResult_pushbutton.
function LastResult_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to LastResult_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if exist('sol','var')  %To be fixed
    results;  
else
    warning('No data to look at...')
end


% --- Executes on button press in PathSettings_pushbutton.
function PathSettings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PathSettings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pathSettings

function MeasuredOutputPath_EditableTextfield_Callback(hObject, eventdata, handles)
% hObject    handle to MeasuredOutputPath_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MeasuredOutputPath_EditableTextfield as text
%        str2double(get(hObject,'String')) returns contents of MeasuredOutputPath_EditableTextfield as a double


% --- Executes during object creation, after setting all properties.
function MeasuredOutputPath_EditableTextfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MeasuredOutputPath_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MeasuredInputSelection_pushbutton.
function MeasuredInputSelection_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to MeasuredInputSelection_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile();
set(handles.PathToInputData_EditableTextfield,'String',strcat(pathname,filename));


function InputArrayExpression_EditableTextfield_Callback(hObject, eventdata, handles)
% hObject    handle to InputArrayExpression_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InputArrayExpression_EditableTextfield as text
%        str2double(get(hObject,'String')) returns contents of InputArrayExpression_EditableTextfield as a double


% --- Executes during object creation, after setting all properties.
function InputArrayExpression_EditableTextfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InputArrayExpression_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function InputTimeVectorExpression_EditableTextfield_Callback(hObject, eventdata, handles)
% hObject    handle to InputTimeVectorExpression_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InputTimeVectorExpression_EditableTextfield as text
%        str2double(get(hObject,'String')) returns contents of InputTimeVectorExpression_EditableTextfield as a double


% --- Executes during object creation, after setting all properties.
function InputTimeVectorExpression_EditableTextfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InputTimeVectorExpression_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function InputDataArrayexpression_EditableTextfield_Callback(hObject, eventdata, handles)
% hObject    handle to InputArrayExpression_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InputArrayExpression_EditableTextfield as text
%        str2double(get(hObject,'String')) returns contents of InputArrayExpression_EditableTextfield as a double


% --- Executes during object creation, after setting all properties.
function InputDataArrayexpression_EditableTextfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InputArrayExpression_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function MainRaPiDWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MainRaPiDWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in FMUGenerationOptions_pushbutton.
function FMUGenerationOptions_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to FMUGenerationOptions_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
generateFmu;


function PathToInputData_EditableTextfield_Callback(hObject, eventdata, handles)
% hObject    handle to PathToInputData_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PathToInputData_EditableTextfield as text
%        str2double(get(hObject,'String')) returns contents of PathToInputData_EditableTextfield as a double


% --- Executes during object creation, after setting all properties.
function PathToInputData_EditableTextfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PathToInputData_EditableTextfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Logo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
axes(hObject)
imshow(fullfile(getPathToRapid,'gui','logoz.png'))
% Hint: place code in OpeningFcn to populate axis1


% --- Executes during object creation, after setting all properties.
function SolverSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SolverSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'SelectionChangeFcn',@selcbk);
set(hObject,'SelectedObject',[]);  % No selection
set(hObject,'Visible','on');


% --- Handle toggling between different solver method
function selcbk(source,eventdata) 
handle2main=getappdata(0,'HandleMainGUI');
RaPIdObject=getappdata(handle2main,'RaPIdObject');
if strcmp(get(get(source,'SelectedObject'),'String'),'Simulink')
    RaPIdObject.experimentSettings.solverMode='Simulink';
else
    RaPIdObject.experimentSettings.solverMode='ODE';
end
