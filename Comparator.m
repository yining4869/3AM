function varargout = Comparator(varargin)
% COMPARATOR MATLAB code for Comparator.fig
%      COMPARATOR, by itself, creates a new COMPARATOR or raises the existing
%      singleton*.
%
%      H = COMPARATOR returns the handle to a new COMPARATOR or the handle to
%      the existing singleton*.
%
%      COMPARATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPARATOR.M with the given input arguments.
%
%      COMPARATOR('Property','Value',...) creates a new COMPARATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Comparator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Comparator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Comparator

% Last Modified by GUIDE v2.5 26-Mar-2017 18:00:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Comparator_OpeningFcn, ...
                   'gui_OutputFcn',  @Comparator_OutputFcn, ...
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


% --- Executes just before Comparator is made visible.
function Comparator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Comparator (see VARARGIN)

% Choose default command line output for Comparator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Comparator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Comparator_OutputFcn(hObject, eventdata, handles) 
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
global a1,global a2,global a3;
index=1;
g=9.8; % Gravity constant
sam_rate=str2num(cell2mat(inputdlg('Input sample rate:','Sample rate')));
% leg='';
while(index)
    % Read in data
    [file_name,~,index]=uigetfile('*.xlsx','Open data file');
%     leg={char(leg);file_name}
    if(~index) 
        break
    end 
    raw_data=xlsread(file_name,1);
    acce=g.*raw_data(:,2:4);
    
    % Cancle noise
    acce(:,1)=acce(:,1)-mean(acce(:,1));
    acce(:,2)=acce(:,2)-mean(acce(:,2));
    acce(:,3)=acce(:,3)-mean(acce(:,3));
    
    st_index=Get_start(acce,sam_rate);
    acce=acce(st_index:end,:);
    si=size(acce);
    
    % Time
    x=(0:1/sam_rate:(si-1)/sam_rate)';
    
%     % Detect acceleration
%     acce_index=Acce_index(acce,sam_rate);
%     
%     % Detect deceleration
%     dece_index=Dece_index(acce,sam_rate);
    
    axes(handles.axes1);
    a1=gca;
    plot(x,acce(:,1));
    title('Ax');
    ylabel('Ax m/s^2');
    xlabel('t /s');
    hold on;zoom on;
%     legend(leg);
    
    axes(handles.axes2);
    a2=gca;
    plot(x,acce(:,2));
    title('Ay');
    ylabel('Ay m/s^2');
    xlabel('t /s');
    hold on;zoom on;
%     legend(leg);
    
    axes(handles.axes3);
    a3=gca;
    plot(x,acce(:,3));
    title('Az');
    ylabel('Az m/s^2');
    xlabel('t /s');
    hold on;zoom on;
%     legend(leg);
end


% --------------------------------------------------------------------
function uipushtool4_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a1,global a2,global a3;
cla(a1,'reset');
cla(a2,'reset');
cla(a3,'reset');