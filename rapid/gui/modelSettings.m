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


function varargout = modelSettings(varargin)
% RAPID_GUI MATLAB code for rapid_gui.fig
%      RAPID_GUI, by itself, creates a new RAPID_GUI or raises the existing
%      singleton*.
%
%      H = RAPID_GUI returns the handle to a new RAPID_GUI or the handle to
%      the existing singleton*.
%
%      RAPID_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RAPID_GUI.M with the given input arguments.
%
%      RAPID_GUI('Property','Value',...) creates a new RAPID_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rapid_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rapid_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rapid_gui

% Last Modified by GUIDE v2.5 02-Mar-2016 14:36:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rapid_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @rapid_gui_OutputFcn, ...
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


% --- Executes just before rapid_gui is made visible.
function rapid_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rapid_gui (see VARARGIN)
% Choose default command line output for rapid_gui
handles.output = hObject;
handle2main=getappdata(0,'HandleMainGUI');
RaPIdObject=getappdata(handle2main,'RaPIdObject');
guidata(hObject, handles);% Update handles structure
string = mfilename('fullpath');
string = string(1:end-length(mfilename)-5);
path = strcat(string,'\model');
set(handles.Simulink_modelpath_edit,'String',path);
set(handles.simulinkModelName_edit,'String','test.mdl');
set(handles.FMUBlockName_edit,'String','FMUme');
set(handles.FMU_filepath_edit,'String','path to your .fmu here');
tmp=RaPIdObject.experimentSettings;
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
if isfield(tmp,'pathToFmuModel')
    set(handles.FMU_filepath_edit,'String',tmp.pathToFmuModel);
end




% --- Outputs from this function are returned to the command line.
function varargout = rapid_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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


% --- Executes on button press in FMU_filepath_pushbutton.
function FMU_filepath_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to FMU_filepath_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FILENAME, PATHNAME] = uigetfile({'*.fmu','FMU-files'},'Select the FMU file that you want to simulate (NB only FMI 1.0 for ODE-solving!)');
set(handles.FMU_filepath_edit,'String',fullfile(PATHNAME,FILENAME))

% --- Executes on button press in closeModelSettings_pushbutton.
function closeModelSettings_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to closeModelSettings_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handle2main=getappdata(0,'HandleMainGUI');
RaPIdObject=getappdata(handle2main,'RaPIdObject');
[~,tmp,~]=fileparts(get(handles.simulinkModelName_edit,'String'));
RaPIdObject.experimentSettings.modelName = tmp;
RaPIdObject.experimentSettings.blockName = get(handles.FMUBlockName_edit,'String');
RaPIdObject.experimentSettings.scopeName = get(handles.scopeName_edit,'String');
RaPIdObject.experimentSettings.pathToFmuModel = get(handles.FMU_filepath_edit,'String');
RaPIdObject.experimentSettings.pathToSimulinkModel = get(handles.Simulink_modelpath_edit,'String');
close(gcf)



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


% --- Executes on button press in openSimulink_pushbutton.
function openSimulink_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to openSimulink_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handle2main=getappdata(0,'HandleMainGUI');
RaPIdObject=getappdata(handle2main,'RaPIdObject');
% RaPIdObject.experimentSettings.modelName = get(handles.simulinkModelName_edit,'String');
% RaPIdObject.experimentSettings.blockName = get(handles.FMUBlockName_edit,'String');
% RaPIdObject.experimentSettings.scopeName = get(handles.scopeName_edit,'String');
% RaPIdObject.experimentSettings.pathToFmuModel = get(handles.FMU_filepath_edit,'String');
% RaPIdObject.experimentSettings.pathToSimulinkModel = get(handles.Simulink_modelpath_edit,'String');
open_system(RaPIdObject.experimentSettings.pathToSimulinkModel)


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


