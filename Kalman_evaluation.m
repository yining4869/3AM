function varargout = Kalman_evaluation(varargin)
% KALMAN_EVALUATION MATLAB code for Kalman_evaluation.fig
%      KALMAN_EVALUATION, by itself, creates a new KALMAN_EVALUATION or raises the existing
%      singleton*.
%
%      H = KALMAN_EVALUATION returns the handle to a new KALMAN_EVALUATION or the handle to
%      the existing singleton*.
%
%      KALMAN_EVALUATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KALMAN_EVALUATION.M with the given input arguments.
%
%      KALMAN_EVALUATION('Property','Value',...) creates a new KALMAN_EVALUATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Kalman_evaluation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Kalman_evaluation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Kalman_evaluation

% Last Modified by GUIDE v2.5 14-May-2017 11:55:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Kalman_evaluation_OpeningFcn, ...
                   'gui_OutputFcn',  @Kalman_evaluation_OutputFcn, ...
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


% --- Executes just before Kalman_evaluation is made visible.
function Kalman_evaluation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Kalman_evaluation (see VARARGIN)

% Choose default command line output for Kalman_evaluation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Kalman_evaluation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Kalman_evaluation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a1;
cla(a1,'reset');


% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a1;
index=1;
sam_rate=str2num(cell2mat(inputdlg('Input sample rate:','Sample rate')));

% Read in acceleration data and height data
[file_name,~,index]=uigetfile({'*.xlsx';'*.xlsm'},'Open data file');
raw_data=xlsread(file_name,1);
u=9.8.*raw_data(:,4);
u=u-u(1,1);
y=raw_data(:,end);
y=y-y(1,1);

% Define system
duration=size(u,1);
sam_rate=50;
dt=1/sam_rate;
a=[1 dt;0 1];
b=[dt^2/2;dt];
c=[1 0];
d=0;
% sys=ss(a, b, c, d, dt, 'inputname', 'a', 'outputname', 'h');

% Define main variables
% u=1.5;
Q=[0;0];
Q_est=Q;
sta_noi_mag=1;    % State estimation noise
mea_noi_mag=1;    % Measurement estimation noise
e_x=sta_noi_mag^2*[dt^4/4 dt^3/2;dt^3/2 dt^2];
e_z=mea_noi_mag^2;
P=e_x;

% Initiate result variables
Q_loc=[];   % Actual height data
vel=[]; % Actual velocity data
Q_loc_mea=[];   % Measured height data

% Simulate
for t=0:dt:(duration-1)/sam_rate
%     sta_noi=sta_noi_mag*randn*[(dt^2/2);dt];
%     Q=a*Q+b*u(t/dt+1)+sta_noi;
    i=floor(t/dt+1);
    Q=a*Q+b*u(i);
%     mea_noi=mea_noi_mag*randn;
%     y=c*Q+mea_noi;
    Q_loc=[Q_loc;Q(1)];
    Q_loc_mea=[Q_loc_mea;y(i)];
    vel=[vel;Q(2)];
end

% Do kalman filter
Q_loc_est=[];
vel_est=[];
Q=[0;0];
P_est=P;
P_mag_est=[];
state_pre=[];
var_pre=[];
for t=1:length(Q_loc);
    Q_est=a*Q_est+b*u(i);
    state_pre=[state_pre;Q_est(1)];
    P=a*P*a'+e_x;
    var_pre=[var_pre;P];
    K=P*c'*inv(c*P*c'+e_z);
    Q_est=Q_est+K*(Q_loc_mea(t)-c*Q_est);
    P=(eye(2)-K*c)*P;
    Q_loc_est=[Q_loc_est;Q_est(1)];
    vel_est=[vel_est;Q_est(2)];
    P_mag_est=[P_mag_est;P(1)];
end

% Plot
axes(handles.axes1);
a1=gca;
tt=0:dt:(duration-1)/sam_rate;
plot(tt,Q_loc);
hold on;
plot(tt,Q_loc_mea);
plot(tt,Q_loc_est);
zoom on;
hold off;
legend('Calculated','Measured','Filtered');
xlabel('Time/s');
ylabel('Displacement/m');
