function varargout = Motion_monitor(varargin)
% MOTION_MONITOR MATLAB code for Motion_monitor.fig
%      MOTION_MONITOR, by itself, creates a new MOTION_MONITOR or raises the existing
%      singleton*.
%
%      H = MOTION_MONITOR returns the handle to a new MOTION_MONITOR or the handle to
%      the existing singleton*.
%
%      MOTION_MONITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTION_MONITOR.M with the given input arguments.
%
%      MOTION_MONITOR('Property','Value',...) creates a new MOTION_MONITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Motion_monitor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Motion_monitor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Motion_monitor

% Last Modified by GUIDE v2.5 07-Mar-2017 20:27:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Motion_monitor_OpeningFcn, ...
                   'gui_OutputFcn',  @Motion_monitor_OutputFcn, ...
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


% --- Executes just before Motion_monitor is made visible.
function Motion_monitor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Motion_monitor (see VARARGIN)

% Choose default command line output for Motion_monitor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Motion_monitor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Motion_monitor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global acce;global x;
axes(handles.axes1);
plot(x,acce(:,1));
title('Ax');
ylabel('Ax m/s^2');
xlabel('t /s');
% legend('Sample Rate=50Hz','Location','southeast');
axes(handles.axes4);
plot(x,acce(:,2));
title('Ay');
ylabel('Ay m/s^2');
xlabel('t /s');
axes(handles.axes7);
plot(x,acce(:,3));
title('Az');
ylabel('Az m/s^2');
xlabel('t /s');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global velo;global x;
axes(handles.axes2);
plot(x,velo(:,1));
title('Vx');
ylabel('Vx m/s');
xlabel('t /s');
% legend('Sample Rate=50Hz','Location','southeast');
axes(handles.axes5);
plot(x,velo(:,2));
title('Vy');
ylabel('Vy m/s');
xlabel('t /s');
axes(handles.axes8);
plot(x,velo(:,3));
title('Vz');
ylabel('Vz m/s');
xlabel('t /s');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dis;global x;global h;
axes(handles.axes3);
plot(x,dis(:,1));
title('Dx');
ylabel('Dx m');
xlabel('t /s');
% legend('Sample Rate=50Hz','Location','southeast');
axes(handles.axes6);
plot(x,dis(:,2));
title('Dy');
ylabel('Dy m');
xlabel('t /s');
axes(handles.axes9);
plot(x,dis(:,3));
title('Dz');
ylabel('Dz m');
xlabel('t /s');
hold on;
plot(x,h);
hold off;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global acce;global velo;global dis;global x;global h;
file_name=uigetfile({'*.xlsx';'*.xlsm'},'Open data file');

[ acce,velo,dis,x,h ] = Calculation( file_name );

set(hObject,'visible','off');


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global acce;global velo;global dis;global x;global h;
file_name=uigetfile('*.xlsx','Open data file');

[ acce,velo,dis,x,h ] = Calculation( file_name );
