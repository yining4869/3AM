function varargout = Compare_acceleration(varargin)
% COMPARE_ACCELERATION MATLAB code for Compare_acceleration.fig
%      COMPARE_ACCELERATION, by itself, creates a new COMPARE_ACCELERATION or raises the existing
%      singleton*.
%
%      H = COMPARE_ACCELERATION returns the handle to a new COMPARE_ACCELERATION or the handle to
%      the existing singleton*.
%
%      COMPARE_ACCELERATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPARE_ACCELERATION.M with the given input arguments.
%
%      COMPARE_ACCELERATION('Property','Value',...) creates a new COMPARE_ACCELERATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Compare_acceleration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Compare_acceleration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Compare_acceleration

% Last Modified by GUIDE v2.5 29-Mar-2017 19:49:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Compare_acceleration_OpeningFcn, ...
                   'gui_OutputFcn',  @Compare_acceleration_OutputFcn, ...
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


% --- Executes just before Compare_acceleration is made visible.
function Compare_acceleration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Compare_acceleration (see VARARGIN)

% Choose default command line output for Compare_acceleration
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Compare_acceleration wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Compare_acceleration_OutputFcn(hObject, eventdata, handles) 
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
global a1,global a2,global a3;global a4,global a5,global a6;
duration=4;
index=1;
sam_rate=str2num(cell2mat(inputdlg('Input sample rate:','Sample rate')));
while(index)
    % Read in data
    [file_name,~,index]=uigetfile({'*.xlsx';'*.xlsm'},'Open data file');
    if(~index) 
        break
    end 
    raw_data=xlsread(file_name,1);
    acce=9.8.*raw_data(:,2:4);
    
    % Cancle noise
    % acce(:,1)=acce(:,1)-mean(acce(:,1));
    % acce(:,2)=acce(:,2)-mean(acce(:,2));
    acce(:,3)=acce(:,3)-acce(1,3);
    
    st_index=Get_start(raw_data,sam_rate);
    acce=acce(st_index:end,:);
    si=size(acce);
    
    % Time
    x=(0:1/sam_rate:(si-1)/sam_rate)';
    
    % Detect acceleration
    acce_index=Acce_index(acce,sam_rate);
    
    % Detect deceleration
    dece_index=Dece_index(acce,sam_rate);
    
    axes(handles.axes1);
    a1=gca;
    plot(x(acce_index:acce_index+sam_rate*duration-1),acce(acce_index:acce_index+sam_rate*duration-1,1));
    title('Acceleration Ax');
    ylabel('Ax m/s^2');
    xlabel('t /s');
    hold on;zoom on;
    
    axes(handles.axes2);
    a2=gca;
    plot(x(acce_index:acce_index+sam_rate*duration-1),acce(acce_index:acce_index+sam_rate*duration-1,2));
    title('Acceleration Ay');
    ylabel('Ay m/s^2');
    xlabel('t /s');
    hold on;zoom on;
    
    axes(handles.axes3);
    a3=gca;
    plot(x(acce_index:acce_index+sam_rate*duration-1),acce(acce_index:acce_index+sam_rate*duration-1,3));
    title('Acceleration Az');
    ylabel('Az m/s^2');
    xlabel('t /s');
    hold on;zoom on;
    
    axes(handles.axes4);
    a4=gca;
    plot(x(dece_index:dece_index+sam_rate*duration-1),acce(dece_index:dece_index+sam_rate*duration-1,1));
    title('Deceleration Ax');
    ylabel('Ax m/s^2');
    xlabel('t /s');
    hold on;zoom on;
    
    axes(handles.axes5);
    a5=gca;
    plot(x(dece_index:dece_index+sam_rate*duration-1),acce(dece_index:dece_index+sam_rate*duration-1,2));
    title('Deceleration Ay');
    ylabel('Ay m/s^2');
    xlabel('t /s');
    hold on;zoom on;
    
    axes(handles.axes6);
    a6=gca;
    plot(x(dece_index:dece_index+sam_rate*duration-1),acce(dece_index:dece_index+sam_rate*duration-1,3));
    title('Deceleration Az');
    ylabel('Az m/s^2');
    xlabel('t /s');
    hold on;zoom on;
end


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a1,global a2,global a3;global a4,global a5,global a6;
cla(a1,'reset');
cla(a2,'reset');
cla(a3,'reset');
cla(a4,'reset');
cla(a5,'reset');
cla(a6,'reset');
