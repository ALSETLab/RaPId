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

% Last Modified by GUIDE v2.5 09-Mar-2016 16:46:41

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
rapidSettings=RaPIdClass();
rapidObject=Rapid(rapidSettings);
setappdata(handles.MainRaPiDWindow,'rapidObject',rapidObject);
setappdata(handles.MainRaPiDWindow,'rapidSettings',rapidSettings);


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
rapidObject.rapidSettings.experimentSettings.optimizationAlgorithm = str{get(handles.OptimMethodSelect_popupmenu,'Value')};
set(handles.SelectedAlgorithmSettings_pushbutton,'String',[rapidObject.rapidSettings.experimentSettings.optimizationAlgorithm ' Settings'])


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
    [sol, hist] = rapidObject.runIdentification();
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
signals=rapidObject.plotBestTracking(handles.rapidMainWindowPlot);
set(handles.plotselect_pop,'String',num2cell(signals))
set(handles.plotselect_pop,'Value',1)
set(hObject,'Enable','on');




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
switch lower(rapidObject.rapidSettings.experimentSettings.optimizationAlgorithm)
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
rapidSettings=getappdata(handles.MainRaPiDWindow,'rapidSettings');
try
    [filename, pathname, success] = uiputfile('*.mat');
    if  success 
        rapidSettings.makePathsRelative(pathname)
        save(strcat(pathname,filename),'rapidSettings')
        cd(pathname); %paths are now relative to this container
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
        rapidSettings=importdata(containerFileString);
    else
        warning('Something went wrong, check the format of the container!')
    end
    if isstruct(rapidSettings) % old container
        try
            rapidSettings=RaPIdClass(mySettings);
            disp('Converted old container to new, please save this new container');
        catch err
            disp(err.message)
        end
    end
    if exist('rapidSettings','var') && isa(rapidSettings,'RaPIdClass') % everything is good
        if ~isfield(rapidSettings.experimentSettings,'optimizationAlgorithm') % if no algorithm set
            rapidSettings.experimentSettings.optimizationAlgorithm='pso';%default to pso
        end
        tmp=find(strcmpi(cellstr(get(handles.OptimMethodSelect_popupmenu,'String')),rapidSettings.experimentSettings.optimizationAlgorithm)); % find which one in the list it is
        set(handles.OptimMethodSelect_popupmenu,'Value',tmp); %set selected item in list to reflect choice of algorithm
        tmp2=get(handles.OptimMethodSelect_popupmenu,'String');
        set(handles.SelectedAlgorithmSettings_pushbutton,'String',[tmp2{tmp} ' Settings'])
        if strcmpi(rapidSettings.experimentSettings.solverMode,'simulink') % initialize radio buttons here
            tmp1=1;
        else
            tmp1=0;
        end
        rapidObject=Rapid(rapidSettings);
        setappdata(handles.MainRaPiDWindow,'rapidSettings',rapidSettings);
        setappdata(handles.MainRaPiDWindow,'rapidObject',rapidObject);
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
    fprintf(' %15s',rapidObject.rapidSettings.parameterNames{:});
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
    rapidObject.rapidSettings.experimentSettings.solverMode='Simulink';
else
    rapidObject.rapidSettings.experimentSettings.solverMode='ODE';
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


% --- Executes on selection change in plotselect_pop.
function plotselect_pop_Callback(hObject, eventdata, handles)
% hObject    handle to plotselect_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'));
val=get(hObject,'Value');
if val~=0
rapidObject=getappdata(handles.MainRaPiDWindow,'rapidObject');
plot(handles.rapidMainWindowPlot,rapidObject.resultData.res(:,val), rapidObject.experimentData.referenceTime);
hold(handles.rapidMainWindowPlot, 'on')
plot(handles.rapidMainWindowPlot,rapidObject.experimentData.referenceOutdata(:,val), rapidObject.experimentData.referenceTime,'r')
hold(handles.rapidMainWindowPlot, 'off')
end

% --- Executes during object creation, after setting all properties.
function plotselect_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotselect_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',1)
set(hObject,'Enable','inactive');

