function varargout = Comparator_frequency(varargin)
% COMPARATOR_FREQUENCY MATLAB code for Comparator_frequency.fig
%      COMPARATOR_FREQUENCY, by itself, creates a new COMPARATOR_FREQUENCY or raises the existing
%      singleton*.
%
%      H = COMPARATOR_FREQUENCY returns the handle to a new COMPARATOR_FREQUENCY or the handle to
%      the existing singleton*.
%
%      COMPARATOR_FREQUENCY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPARATOR_FREQUENCY.M with the given input arguments.
%
%      COMPARATOR_FREQUENCY('Property','Value',...) creates a new COMPARATOR_FREQUENCY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Comparator_frequency_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Comparator_frequency_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Comparator_frequency

% Last Modified by GUIDE v2.5 23-Apr-2017 15:31:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Comparator_frequency_OpeningFcn, ...
                   'gui_OutputFcn',  @Comparator_frequency_OutputFcn, ...
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


% --- Executes just before Comparator_frequency is made visible.
function Comparator_frequency_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Comparator_frequency (see VARARGIN)

% Choose default command line output for Comparator_frequency
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Comparator_frequency wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Comparator_frequency_OutputFcn(hObject, eventdata, handles) 
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
global a1,global a2;global lin_sty;
index=1;
g=9.8; % Gravity constant
sam_rate=str2num(cell2mat(inputdlg('Input sample rate:','Sample rate')));
while(index)
     % Read in data
    [file_name,~,index]=uigetfile({'*.xlsx';'*.xlsm'},'Open data file');
    if(~index) 
        break
    end 
%     if(~exist('leg','var'))
%         leg='';
%     end
%     leg=[leg;file_name];
    raw_data=xlsread(file_name,1);
    acce=g.*raw_data(:,2:4);
    
    % Cancle noise
%     acce(:,1)=acce(:,1)-mean(acce(:,1));
%     acce(:,2)=acce(:,2)-mean(acce(:,2));
    acce(:,3)=acce(:,3)-mean(acce(:,3));
    
    st_index=Get_start(raw_data,sam_rate);
    acce=acce(st_index:end,:);
    si=size(acce,1);
    
    % Time
    x=(0:1/sam_rate:(si-1)/sam_rate)';

    if(isempty(lin_sty))
        lin_sty='-';
    end
    % Draw time domain figure
    axes(handles.axes1);
    a1=gca;
    plot(x,acce(:,3),'LineStyle',lin_sty);
    title('Az');
    ylabel('Az m/s^2');
    xlabel('t /s');
    hold on;zoom on;
%     legend(leg);

    % Calculate Fourier transform
    acce_ft=fft(acce(:,3));
    acce_ft=acce_ft(1:floor(si/2)+1);
    acce_ft(2:end-1)=2*acce_ft(2:end-1);
    fre=(sam_rate/si)*(0:si/2);     % Frequency sequence

    axes(handles.axes2);
    a2=gca;
    plot(fre,abs(acce_ft),'LineStyle',lin_sty);
    title('Amplitude');
%     ylabel('Az m/s^2');
    xlabel('Frequency/Hz');
    hold on;zoom on;
%     legend(leg);
end


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a1,global a2;
cla(a1,'reset');
cla(a2,'reset');


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
global lin_sty;
val=get(handles.listbox1,'Value');
if val==1
    lin_sty='-';
elseif val==2
    lin_sty='-.';
else
    lin_sty='-';
end


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
