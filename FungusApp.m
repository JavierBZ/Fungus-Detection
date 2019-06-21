function varargout = FungusApp(varargin)
% FUNGUSAPP MATLAB code for FungusApp.fig
%      FUNGUSAPP, by itself, creates a new FUNGUSAPP or raises the existing
%      singleton*.
%
%      H = FUNGUSAPP returns the handle to a new FUNGUSAPP or the handle to
%      the existing singleton*.
%
%      FUNGUSAPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FUNGUSAPP.M with the given input arguments.
%
%      FUNGUSAPP('Property','Value',...) creates a new FUNGUSAPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FungusApp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FungusApp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FungusApp

% Last Modified by GUIDE v2.5 10-Jun-2019 19:14:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FungusApp_OpeningFcn, ...
                   'gui_OutputFcn',  @FungusApp_OutputFcn, ...
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


% --- Executes just before FungusApp is made visible.
function FungusApp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FungusApp (see VARARGIN)

% Choose default command line output for FungusApp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FungusApp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FungusApp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
switch get(handles.popupmenu1,'Value')
    
    case 1 
        handles.FungiName = 'Asp_flavus';
    case 2 
        handles.FungiName = 'Asp_fumigatus';   
    case 3 
        handles.FungiName = 'Asp_lentus'; 
    case 4 
        handles.FungiName = 'Asp_nidulans';
    case 5 
        handles.FungiName = 'Asp_niger';   
    case 6 
        handles.FungiName = 'Asp_terreus';          
    case 7 
        handles.FungiName = 'Asp_ustus';  
    case 8 
        handles.FungiName = 'Mica'; 
    case 9 
        handles.FungiName = 'Penny';  
    case 10 
        handles.FungiName = 'scopu';          
   
end

handles.FungiDir = ['Hongos2/' char(handles.FungiName)];
handles.FungiDir_Seg = ['Hongos2/' char(handles.FungiName) '_R_Seg'];

handles.D = dir([handles.FungiDir '/*.tif']);
% D = dir([handles.FungiDir '/*.tif']);
% save('hola.mat','D');
handles.ImageNumber = 1;
handles.ImageName = handles.D(handles.ImageNumber).name;
set(handles.text3, 'String', handles.ImageName);
handles.Image = imread([handles.FungiDir '/' handles.D(handles.ImageNumber).name]);

axes(handles.axes1)
imshow(handles.Image,[])

baseFileName = [handles.D(handles.ImageNumber).name(1:end-4) '_Seg.png']
fullFileName = fullfile(handles.FungiDir_Seg, baseFileName);

if exist(fullFileName, 'file')
  % File doesn't exist -- didn't find it there.  Check the search path for it.
  handles.binaryImage = imread(fullFileName);
  
  
  burnedImage = handles.Image;
  burnedImage(handles.binaryImage==1) = 255;
  
  axes(handles.axes2)
  imshow(burnedImage,[])

else
  axes(handles.axes2)
  plot(0,0)
  
end
    
handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Next_image

axes(handles.axes3)
plot(0,0)

handles.ImageNumber = handles.ImageNumber + 1;

if handles.ImageNumber > size(handles.D,1)
    handles.ImageNumber = 1;
end

handles.ImageName = handles.D(handles.ImageNumber).name;
set(handles.text3, 'String', handles.ImageName);
handles.Image = imread([handles.FungiDir '/' handles.D(handles.ImageNumber).name]);

axes(handles.axes1)
imshow(handles.Image,[])


baseFileName = [handles.D(handles.ImageNumber).name(1:end-4) '_Seg.png']
fullFileName = fullfile(handles.FungiDir_Seg, baseFileName)

if exist(fullFileName, 'file')

  handles.binaryImage = imread(fullFileName);
  
  axes(handles.axes3)
  imshow(handles.binaryImage,[])
  %imshow(handles.binaryImage);
 % size(handles.binaryImage)
 % handles.binaryImage = rgb2gray(handles.binaryImage);
 
%    I = handles.Image;
%    B = handles.binaryImage;
%    save('hola.mat','I','B')
  burnedImage = handles.Image;
  burnedImageR = burnedImage(:,:,1);
  
  burnedImageR(double(handles.binaryImage)==1) = 255;
  
  burnedImage(:,:,1) = burnedImageR;
  
%   figure,
%   imshow(burnedImage,[])
%   
%   figure,
%   imshow(handles.binaryImage,[])
%   
  
  
  axes(handles.axes2)
  imshow(burnedImage,[])

else
  axes(handles.axes2)
  plot(0,0)
  
end




handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% New Segment button
figure,
imshow(handles.Image, []);
axis on;
title('Original Image', 'FontSize', 16);
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
uiwait(msgbox(message));

hFH = imfreehand();

handles.binaryImage = hFH.createMask();
xy = hFH.getPosition;


% Burn line into image by setting it to 255 wherever the mask is true.
burnedImage = handles.Image;
burnedImage(handles.binaryImage) = 255;

close Figure 1

axes(handles.axes2)
imshow(burnedImage,[])

bwFilename = sprintf('%s_Seg.png', handles.D(handles.ImageNumber).name(1:end-4)); %se guardan en formato png para conservar el formato binario.
imwrite(handles.binaryImage,fullfile(handles.FungiDir_Seg ,bwFilename));



handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Add Segmentation button

burnedImage = handles.Image;
burnedImage(handles.binaryImage==1) = 255;

figure,
imshow(burnedImage, []);
axis on;
title('Original Image', 'FontSize', 16);
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish. Please try to not pass through previous segmentations (red areas)');
uiwait(msgbox(message));

hFH = imfreehand();

binaryImage = hFH.createMask();
xy = hFH.getPosition;

M = handles.binaryImage;
N = binaryImage;
save('hola.mat','M','N')


handles.binaryImage = double(handles.binaryImage) + double(binaryImage);


burnedImage = handles.Image;
burnedImage(handles.binaryImage==1) = 255;

close Figure 1

axes(handles.axes2)
imshow(burnedImage,[])

bwFilename = sprintf('%s_Seg.png', handles.D(handles.ImageNumber).name(1:end-4)); %se guardan en formato png para conservar el formato binario.
imwrite(handles.binaryImage,fullfile(handles.FungiDir_Seg ,bwFilename));



handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes3)
plot(0,0)

handles.ImageNumber = handles.ImageNumber - 1;

if handles.ImageNumber < 1
    handles.ImageNumber = 1;
end

handles.ImageName = handles.D(handles.ImageNumber).name;
set(handles.text3, 'String', handles.ImageName);
handles.Image = imread([handles.FungiDir '/' handles.D(handles.ImageNumber).name]);

axes(handles.axes1)
imshow(handles.Image,[])


baseFileName = [handles.D(handles.ImageNumber).name(1:end-4) '_Seg.png']
fullFileName = fullfile(handles.FungiDir_Seg, baseFileName)

if exist(fullFileName, 'file')

  handles.binaryImage = imread(fullFileName);
  
  axes(handles.axes3)
  imshow(handles.binaryImage,[])
  %imshow(handles.binaryImage);
 % size(handles.binaryImage)
 % handles.binaryImage = rgb2gray(handles.binaryImage);
 
%    I = handles.Image;
%    B = handles.binaryImage;
%    save('hola.mat','I','B')
  burnedImage = handles.Image;
  burnedImageR = burnedImage(:,:,1);
  
  burnedImageR(handles.binaryImage==1) = 255;
  
  burnedImage(:,:,1) = burnedImageR;
  
%   figure,
%   imshow(burnedImage,[])
%   
%   figure,
%   imshow(handles.binaryImage,[])
%   
  
  
  axes(handles.axes2)
  imshow(burnedImage,[])

else
  axes(handles.axes2)
  plot(0,0)
  
end




handles.output = hObject;
guidata(hObject, handles);