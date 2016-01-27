function varargout = SSAsettings(varargin)
% SSASETTINGS MATLAB code for SSAsettings.fig
%      SSASETTINGS, by itself, creates a new SSASETTINGS or raises the existing
%      singleton*.
%
%      H = SSASETTINGS returns the handle to a new SSASETTINGS or the handle to
%      the existing singleton*.
%
%      SSASETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SSASETTINGS.M with the given input arguments.
%
%      SSASETTINGS('Property','Value',...) creates a new SSASETTINGS or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SSAsettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SSAsettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SSAsettings

% Last Modified by GUIDE v2.5 03-Dec-2015 13:15:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SSAsettings_OpeningFcn, ...
                   'gui_OutputFcn',  @SSAsettings_OutputFcn, ...
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

% --- Executes just before SSAsettings is made visible.
function SSAsettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SSAsettings (see VARARGIN)

% Choose default command line output for SSAsettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes SSAsettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);

RaPIdObject=getappdata(getappdata(0,'HandleMainGUI'),'RaPIdObject');
DymolaPath= RaPIdObject.DymolaPath;
DymolaModelName=RaPIdObject.DymolaModelName;
if isempty(DymolaPath) || isempty(DymolaModelName)
    DymolaPath=[ getenv('USERPROFILE') '\Documents\Dymola'];
    DymolaModelName='Nordic44.System.Nordic44';
    
    RaPIdObject.DymolaPath=DymolaPath;
    RaPIdObject.DymolaModelName=DymolaModelName;
end

set(handles.DymolaPath,'string',[RaPIdObject.DymolaPath '\' RaPIdObject.DymolaModelName]);

refmode=RaPIdObject.ReferenceMode;
if ~isempty(refmode)
    set(handles.loaded_mode,'string',num2str(refmode));
else
    set(handles.loaded_mode,'string','Not specified');
end
        

% --- Outputs from this function are returned to the command line.
function varargout = SSAsettings_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName,FilterIndex] = uigetfile('*.mat','Select Estimated/Referent Mode');

try
    mode_est_res=cell2mat(struct2cell(load([PathName FileName])));
    if ~isnumeric(mode_est_res)|| ~isscalar(mode_est_res) || isreal(mode_est_res)
        error('The selected file does not contain appropriate data')
        h = msgbox('File not loaded','Error loading reference mode'); 
    else
        set(handles.loaded_mode,'string',num2str(mode_est_res));
        RaPIdObject=getappdata(getappdata(0,'HandleMainGUI'),'RaPIdObject');
        RaPIdObject.ReferenceMode=mode_est_res;
    end
    
catch err
    disp(err.message)
    
end
  
% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the Close_button flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to Close_button the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end
set(handles.loaded_mode, 'String', 0);


% Update handles structure
guidata(handles.figure1, handles);


% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close();


% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close()


% --- Executes on button press in OKbutton.
function OKbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OKbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.loaded_mode, 'String')=='0';
    h = msgbox('Mode estimatiion result not loaded','Warning','warn')
end
close()


% --- Executes on button press in DymolaPathButton.
function DymolaPathButton_Callback(hObject, eventdata, handles)
% hObject    handle to DymolaPathButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RaPIdObject=getappdata(getappdata(0,'HandleMainGUI'),'RaPIdObject');

folder_name =[ getenv('USERPROFILE') '\Documents\Dymola'];
[FileName,PathName,FilterIndex] = uigetfile('*.mo','Select Estimated/Referent Mode', folder_name);
RaPIdObject.DymolaPath=PathName;
RaPIdObject.DymolaModelName=FileName;
set(handles.DymolaPath,'string',[PathName '\' FileName]);
