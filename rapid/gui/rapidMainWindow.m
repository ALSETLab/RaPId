function varargout = rapidMainWindow(varargin)
% RAPIDMAINWINDOW is the main GUI Window for the RaPId Toolbox. It can be
% called directly or by calling the function runRapidGui.
%      rapidMainWindow, by itself, creates a new rapidMainWindow or raises the existing
%      singleton.
%
%      H = rapidMainWindow returns the handle to a new rapidMainWindow or the handle to
%      the existing singleton.
%
%      rapidMainWindow('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in rapidMainWindow.m with the given input arguments.
%
%      rapidMainWindow('Property','Value',...) creates a new rapidMainWindow or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
% See also: RUNRAPIDGUI, RAPID, GUIDE

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

% Last Modified by GUIDE v2.5 09-Mar-2016 13:55:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @rapidMainWindow_OpeningFcn, ...
    'gui_OutputFcn',  @rapidMainWindow_OutputFcn, ...
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
function rapidMainWindow_OpeningFcn(hObject, eventdata, handles, varargin)

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
    rapidObject=RaPIdClass();
    setappdata(handles.MainRaPiDWindow,'rapidObject',rapidObject);
catch err
    disp err;
    rethrow(err);
end


% --- Outputs from this function are returned to the command line.
function varargout = rapidMainWindow_OutputFcn(hObject, eventdata, handles)
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
rapidObject=getappdata(handles.MainRaPiDWindow,'rapidObject');
rapidObject.experimentSettings.optimizationAlgorithm = str{get(handles.OptimMethodSelect_popupmenu,'Value')};
set(handles.SelectedAlgorithmSettings_pushbutton,'String',[rapidObject.experimentSettings.optimizationAlgorithm ' Settings'])


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
rapidObject=getappdata(handles.MainRaPiDWindow,'rapidObject');
set(handles.statusText,'String','Running and Visualizing Optimization.');
%set(handles.statusText,'BackgroundColor','r');
rapidObject.experimentSettings.solverMode='Simulink';
rapidObject.experimentSettings.displayMode='Show';
% THIS STUFF MIGHT GO
try
        if exist(rapidObject.experimentSettings.pathToSimulinkModel,'file')
            tmp=rapidObject.experimentSettings.pathToSimulinkModel;
        elseif ~exist(rapidObject.experimentSettings.pathToSimulinkModel,'file') && exist(fullfile(evalin('base','pwd'),rapidObject.experimentSettings.pathToSimulinkModel),'file')
            tmp=fullfile(evalin('base','pwd'),rapidObject.experimentSettings.pathToSimulinkModel);
        end
            open_system(tmp); 

        % mySettings.realData = transpose(eval(mySettings.dataY));
       % mySettings.realTime = eval(mySettings.dataT);
catch err
    disp(err);
end


% --- Executes on button press in RunOptimization_pushbutton.
function RunOptimization_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RunOptimization_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rapidObject=getappdata(handles.MainRaPiDWindow,'rapidObject');
% mySettings.mode='Simulink';
% [mySettings.realTime, i_t]=unique(mySettings.realTime); % check that we only use unique time stamps
% mySettings.realData=mySettings.realData(i_t,:);

try
    tic
    [sol, hist] = rapid(rapidObject);
    assignin('base','sol',sol);
    assignin('base','hist',hist);
    toc
catch err
    set(handles.statusText,'BackgroundColor','y');
    set(handles.statusText,'String','error');
    if strcmp(err.identifier,'Simulink:Commands:SimAborted')
        disp(err.message);
    else
        rethrow(err);
    end
end
set(handles.statusText,'String','Simulation completed.');
set(handles.statusText,'BackgroundColor','g');


% --- Executes on button press in OpenPlot_pushbutton.
function OpenPlot_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OpenPlot_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rapidObject=getappdata(handles.MainRaPiDWindow,'rapidObject');

% Most stuff below should be inside rapid.m or methods of rapidObject

if isfield(rapidObject.resultData,'parametersFound')
    bestparameters=rapidObject.resultData.parametersFound;
else
    disp('No simulation has been run, plotting the result for parameter start values');
    bestparameters=rapidObject.experimentSettings.p_0;
end
switch lower(rapidObject.experimentSettings.solverMode) % use lower case
    case 'simulink'
        if strcmp(gcs,rapidObject.experimentSettings.modelName) % check if model already loaded
            %NOP
        else
            clear rapid_simuSystem
            tmp=[];
            if exist(rapidObject.experimentSettings.pathToSimulinkModel,'file')
                tmp=rapidObject.experimentSettings.pathToSimulinkModel;
            elseif ~exist(rapidObject.experimentSettings.pathToSimulinkModel,'file') && exist(fullfile(evalin('base','pwd'),rapidObject.experimentSettings.pathToSimulinkModel),'file')
                tmp=fullfile(evalin('base','pwd'),rapidObject.experimentSettings.pathToSimulinkModel);
            end
            load_system(tmp);
        end
        res = rapid_simuSystem(bestparameters,rapidObject);
        if ~isempty(res)
            plot(handles.rapidMainWindowPlot,rapidObject.experimentData.referenceTime,res)
            hold on
            plot(handles.rapidMainWindowPlot,rapidObject.experimentData.referenceTime,rapidObject.experimentData.referenceOutdata,'--r')
            hold off
        else
            error('Failed to simulate');
        end
    case 'ode'
        res = rapid_ODEsolve(bestparameters,rapidObject);
        if ~isempty(res)
            for i = 1:length(rapidObject.fmuOutputNames);  %this should be changed maybe, since FMUoutput is not necessarily what we used for fitness-function
                figure, hold on %For now, plot each comparison i new figure.
                plot(rapidObject.experimentData.referenceTime,rapidObject.experimentData.referenceOutdata(:,i))
                hold on
                plot(rapidObject.experimentData.referenceTime,res(:,i),'--r')
                title(rapidObject.fmuOutputNames{i})
                legend('Reference system:', 'Calibrated system:')
            end
        else
            error('Failed to simulate');
        end
end

    



% --- Executes on button press in GeneralSettings_pushbutton.
function GeneralSettings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to GeneralSettings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
odeSettings


% --- Executes on button press in SelectedAlgorithmSettings_pushbutton.
function SelectedAlgorithmSettings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to SelectedAlgorithmSettings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rapidObject=getappdata(handles.MainRaPiDWindow,'rapidObject');
switch lower(rapidObject.experimentSettings.optimizationAlgorithm)
    case 'pso'
        psoSettings;
    case 'ga'
        gaSettings;
    case 'naive'
        otherSettings;
    case 'cg'
        otherSettings;
    case 'nm'
        otherSettings;
    case 'combi'
        otherSettings;
    case 'psoext'
        otherSettings;
    case 'gaext'
        otherSettings;
    case 'knitro'
        otherSettings;
    case 'fmincon'
        otherSettings;
    case 'pfnew'
        otherSettings;
    otherwise
        error('Seems like there is something wrong with the chosen optimzation selecting string');
end


% --- Executes on button press in SaveContainer_pushbutton.
function SaveContainer_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveContainer_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rapidObject=getappdata(handles.MainRaPiDWindow,'rapidObject');
try
    [filename, pathname, success] = uiputfile('*.mat');
    if  success 
        save(strcat(pathname,filename),'rapidObject')
    else
        disp('User did not save file.');
    end
catch err
    warning(strcat('Could not save the file because of error: ',err.message));
end


% --- Executes on button press in LoadContainer_pushbutton.
function LoadContainer_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadContainer_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%rapidObject=getappdata(handles.MainRaPiDWindow,'rapidObject');
try
    [filename, pathname] = uigetfile;
    if pathname==0
        error('No file selected.');
    end
    cd(pathname);
    containerFileString=strcat(pathname,filename);
    contentOfContainer=whos('-file',containerFileString);
    if length(contentOfContainer)==1  % typical case
        rapidObject=importdata(containerFileString);
    else
        warning('Something went wrong, check the format of the container!')
    end
    if isstruct(rapidObject) % old container
        try
            rapidObject=RaPIdClass(mySettings);
            disp('Converted old container to new, please save this new container');
        catch err
            disp(err.message)
        end
    end
    if exist('rapidObject','var') && isa(rapidObject,'RaPIdClass') % everything is good
        
        setappdata(handles.MainRaPiDWindow,'rapidObject',rapidObject);
        if ~isfield(rapidObject.experimentSettings,'optimizationAlgorithm') % if no algorithm set
            rapidObject.experimentSettings.optimizationAlgorithm='pso';%default to pso
        end
        tmp=find(strcmpi(cellstr(get(handles.OptimMethodSelect_popupmenu,'String')),rapidObject.experimentSettings.optimizationAlgorithm)); % find which one in the list it is
        set(handles.OptimMethodSelect_popupmenu,'Value',tmp); %set selected item in list to reflect choice of algorithm
        tmp2=get(handles.OptimMethodSelect_popupmenu,'String');
        set(handles.SelectedAlgorithmSettings_pushbutton,'String',[tmp2{tmp} ' Settings'])
        if strcmpi(rapidObject.experimentSettings.solverMode,'simulink') % initialize radio buttons here
            tmp1=1;
        else
            tmp1=0;
        end
        set(handles.simulinkselector,'Value',tmp1);
        set(handles.odeselector,'Value',~tmp1);
        
    else
        warning('Something went wrong, check the format of the container!')
    end
catch err
    disp(err.message)
end

% --- Executes on button press in LastResult_pushbutton.
function LastResult_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to LastResult_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    sol=evalin('base','sol');      
    rapidObject=getappdata(handles.MainRaPiDWindow,'rapidObject');
    fprintf('The best parameters,given in workspace variable %s, are:\n','sol')
    fprintf(' %15s',rapidObject.parameterNames{:});
    fprintf('\n');
    fprintf(' %15.4e', sol);
    fprintf('\n');
catch err
    if strcmp(err.identifier,'MATLAB:UndefinedFunction')
        disp('No data in workspace.')
    else
        warning(err.message); %Should not be critical for anything.
    end

end


% --- Executes on button press in ModelSettings_pushbutton.
function ModelSettings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ModelSettings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simulinkSettings


% --- Executes during object creation, after setting all properties.
function MainRaPiDWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MainRaPiDWindow (see GCBO)
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
rapidObject=getappdata(handle2main,'rapidObject');
if strcmp(get(get(source,'SelectedObject'),'String'),'Simulink')
    rapidObject.experimentSettings.solverMode='Simulink';
else
    rapidObject.experimentSettings.solverMode='ODE';
end


% --- Executes during object creation, after setting all properties.
function statusText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to statusText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function rapidMainWindowPlot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rapidMainWindowPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate rapidMainWindowPlot
