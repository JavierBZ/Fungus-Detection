function varargout = Fungus_classification(varargin)
% FUNGUS_CLASSIFICATION MATLAB code for Fungus_classification.fig
%      FUNGUS_CLASSIFICATION, by itself, creates a new FUNGUS_CLASSIFICATION or raises the existing
%      singleton*.
%
%      H = FUNGUS_CLASSIFICATION returns the handle to a new FUNGUS_CLASSIFICATION or the handle to
%      the existing singleton*.
%
%      FUNGUS_CLASSIFICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FUNGUS_CLASSIFICATION.M with the given input arguments.
%
%      FUNGUS_CLASSIFICATION('Property','Value',...) creates a new FUNGUS_CLASSIFICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Fungus_classification_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Fungus_classification_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Fungus_classification


% Last Modified by GUIDE v2.5 30-May-2019 11:47:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Fungus_classification_OpeningFcn, ...
                   'gui_OutputFcn',  @Fungus_classification_OutputFcn, ...
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


% --- Executes just before Fungus_classification is made visible.
function Fungus_classification_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Fungus_classification (see VARARGIN)

% Choose default command line output for Fungus_classification
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Fungus_classification wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Fungus_classification_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
    
C = get(handles.listbox1,{'string','value'});
handles.H = C{1}(C{2})';

handles.Hayhongos = 1;

handles.output = hObject;
guidata(hObject, handles);

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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Extract features


%[handles.X,handles.Xn,handles.Xtrain,handles.Xtest,handles.dtrain,handles.dtest] = Feature_Extraction2(handles.H,0.75);

N_hongos = size(handles.H,2); % Número de especies a segmentar

Hongos_R = cell(1,size(1,N_hongos));
Hongos_Seg = cell(1,size(1,N_hongos));
    
for k = 1:N_hongos
    Hongos_R(k) = {['Hongos2/' char(handles.H(k))]};
    Hongos_Seg(k) = {['Hongos2/' char(handles.H(k)) '_R_Seg']};
end

M = 0;
handles.N_Segmentations = zeros(N_hongos,1); 
for k = 1:N_hongos
    str2 = char(Hongos_Seg(k));
    d2 = dir([str2 '/*.png']);
    
    for i = 1:size(dir([str2 '/*.png']),1)
    R = imread([str2 '/' d2(i).name]);
    
    BW = bwareaopen(R,20);
    
    [L,n] = bwlabel(BW);
    
    M = M + n;
    handles.N_Segmentations(k) = n ; 
    
    end
    
    
end



m = 1;
nf = 36;%*3 ;% + 6*3; %% Número de características a extraer 36
handles.X = zeros(M,nf);


c = zeros(1,N_hongos);


ff = Bio_statusbar('Procesando Hongos');
for k = 1:N_hongos
    st = char(Hongos_R(k));
    str2 = char(Hongos_Seg(k));
    d = dir([st '/*.tif']);
   
    d2 = dir([str2 '/*.png']);
    
    %save('hola.mat','d','d2')
    
    for i = 1:size(dir([st '/*.tif']),1)
        
        for Segs = 1:size(dir([str2 '/*.png']),1)
         
%         d(i).name(1:end-4)
%         d2(Segs).name(1:end-8)
% %                 
           
        if (d(i).name(1:end-4) == d2(Segs).name(1:end-8)) 
       
        
            ff = Bio_statusbar(m/M,ff);
    
            I = imread([st '/' d(i).name]);
            R = imread([str2 '/' d2(Segs).name]);
        
            BW = bwareaopen(R,20);
            [L,n] = bwlabel(BW);
            region = 1;
            for p = 1:n
          
                R = (L==region);  
             
               J = rgb2gray(I);
        
%         
                %b(2).name = 'basicint';  b(2).options.show=1;
                b(1).name = 'lbp';  b(1).options.show=0;
        
                                b(1).options.vdiv        = 1;           % three vertical divition
                                b(1).options.hdiv        = 1;           % three horizontal   divition
                                b(1).options.samples     = 8;           % number of neighbor samples 
                                b(1).options.mappingtype = 'ri';        % rotation invariant LBP
            
                options.b = b;
                %options.colstr = 'rgb';
                options.colstr = 'i';
                [handles.X(m,:),handles.Xn]= Bfx_int(J,R,options);
        
                region = region + 1;
                m = m + 1;
                c(k) = c(k) + 1; 
      
            end
        
        end
        
        end
    end
end
 
delete(ff);

%Separamos en datos de training y testing

% for k = 1:N_hongos
%     st = char(Hongos_R(k));
%     c(k) = size(dir([st '/*.tif']),1);
% end

handles.d = Bds_labels(c);


[handles.Xtrain,handles.dtrain,handles.Xtest,handles.dtest] = Bds_stratify(handles.X,handles.d,0.8);







%[handles.Xtrain,handles.Xtest] = Post_processing(handles.Xtrain,handles.Xtest);

%%Clean
handles.sclean = Bfs_clean(handles.Xtrain,1);
%handles.Xtrain = handles.Xtrain(:,s);


%Normalización
M = size(handles.Xtest(:,handles.sclean),1); 
[handles.Xtrain,handles.a,handles.b] = Bft_norm(handles.Xtrain(:,handles.sclean),1);
handles.Xtest = handles.Xtest(:,handles.sclean).*(ones(M,1)*handles.a) + ones(M,1)*handles.b;



M = size(handles.X(:,handles.sclean),1); 
handles.X = handles.X(:,handles.sclean).*(ones(M,1)*handles.a) + ones(M,1)*handles.b;
 
% 
% else
% uiwait(msgbox("Seleccione hongos por favor"));


handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Feature Selection





% %[handles.Xtrain,handles.Xtest] = Selection(handles.Xtrain,handles.Xtest,dtrain,20);
% op.m = 15;                     % 10 features will be selected
% op.show = 0;                   % display results
% op.b.name = 'fisher';          % SFS with Fisher
% handles.sfs = Bfs_sfs(handles.Xtrain,double(handles.dtrain),op);   % index of selected features
% % 
% % handles.Xtrain = handles.Xtrain(:,handles.sfs);
% % handles.Xtest = handles.Xtest(:,handles.sfs);
% 
% handles.X = handles.X(:,handles.sfs);

    b(1).name = 'knn';   b(1).options.k = 3;                              % KNN with 5 neighbors
    b(2).name = 'knn';   b(2).options.k = 5;                              % KNN with 7 neighbors
    b(3).name = 'lda';   b(3).options.p = [];                             % LDA
    b(4).name = 'qda';   b(4).options.p = [];                             % QDA
    %b(6).name = 'nnglm'; b(6).options.method = 3; b(6).options.iter = 10; % Nueral network
    b(5).name = 'libsvm';b(5).options.kernel = '-t 0';                    % rbf-SVM
    b(6).name = 'dmin';  b(6).options = [];                               % Euclidean distance
    b(7).name = 'maha';  b(7).options = [];                               % Mahalanobis distance
    
op.strat=1; op.b = b; op.v = 5; op.show = 1; op.c = 0.95;        	  % 10 groups cross-validation

[handles.p,handles.ci] = Bev_crossval(handles.X,handles.d,op);                                        % cross valitadion


uiwait(msgbox("Selección terminada y entrenamiento con validación cruzada terminado"));

handles.output = hObject;
guidata(hObject, handles);



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

%Clasificadores

switch get(handles.popupmenu1,'Value')
    
    case 1 
        %[handles.Acc,handles.ops] = Classifier(handles.Xtrain,handles.Xtest,handles.dtrain,handles.dtest,1);
%         handles.Classifier = 1;
%         options.k = 1; 
%         handles.ops = Bcl_knn(handles.Xtrain,handles.dtrain,options) ; 
%         dpred = Bcl_knn(handles.Xtest,handles.ops);

        handles.Acc = handles.p(1);
        handles.Conf = handles.ci(1,:);
        
    case 2 
    %[handles.Acc,handles.ops] = Classifier(handles.Xtrain,handles.Xtest,handles.dtrain,handles.dtest,1);
%         handles.Classifier = 1;
%         options.k = 1; 
%         handles.ops = Bcl_knn(handles.Xtrain,handles.dtrain,options) ; 
%         dpred = Bcl_knn(handles.Xtest,handles.ops);

    handles.Acc = handles.p(1);
    handles.Conf = handles.ci(1,:);
        
        
        
    case 3 
%         %[handles.Acc,handles.ops] = Classifier(handles.Xtrain,handles.Xtest,handles.dtrain,handles.dtest,2); 
%         handles.Classifier = 2;
%         options.p = []; 
%         handles.ops = Bcl_lda(handles.Xtrain,handles.dtrain,options) ; 
%         dpred = Bcl_lda(handles.Xtest,handles.ops);
        handles.Acc = handles.p(3);
        handles.Conf = handles.ci(3,:);
        
    case 4 
        %[handles.Acc,handles.ops] = Classifier(handles.Xtrain,handles.Xtest,handles.dtrain,handles.dtest,3);
%         handles.Classifier = 3;
%         options.p = []; 
%         handles.ops = Bcl_qda(handles.Xtrain,handles.dtrain,options) ; 
%         dpred = Bcl_qda(handles.Xtest,handles.ops);
        handles.Acc = handles.p(4);
        handles.Conf = handles.ci(4,:);
        
    case 5 
        %[handles.Acc,handles.ops] = Classifier(handles.Xtrain,handles.Xtest,handles.dtrain,handles.dtest,4);
%         % Clasificador SVM
%         handles.Classifier = 4;
%         options.kernel = '-t 0';
%         options.show = 0;
%         handles.ops = Bcl_libsvm(handles.Xtrain,handles.dtrain,options);   % rbf-SVM classifier training
%         
%         dpred = Bcl_libsvm(handles.Xtest,handles.ops);    % rbf-SVM classifier testing
        handles.Acc = handles.p(5);
        handles.Conf = handles.ci(5,:);
       
end


set(handles.text2, 'String', strcat(num2str(handles.Acc*100),'%',' Ci [',num2str(handles.Conf(1)*100)...
    , ',',num2str(handles.Conf(2)*100),']'));


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


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[file,path] = uigetfile('*.tif');

path_Seg = strcat(path(1:end-1),'_R_Seg');

if exist(path_Seg, 'file')
    
            I = imread([path '/' file]);
            R = imread([path_Seg '/' strcat(file(1:end-4),'_Seg.png')]);
        
            BW = bwareaopen(R,20);
            [L,n] = bwlabel(BW);
            nf = 36;
            X_prueba = zeros(n,nf) ;
            region = 1;
            for p = 1:n
          
                R = (L==region);  
             
               J = rgb2gray(I);
        
%         
                %b(2).name = 'basicint';  b(2).options.show=1;
                b(1).name = 'lbp';  b(1).options.show=1;
        
                                b(1).options.vdiv        = 1;           % three vertical divition
                                b(1).options.hdiv        = 1;           % three horizontal   divition
                                b(1).options.samples     = 8;           % number of neighbor samples 
                                b(1).options.mappingtype = 'ri';        % rotation invariant LBP
            
                options.b = b;
                %options.colstr = 'rgb';
                options.colstr = 'i';
                [Xprueba(p,:),Xn_prueba]= Bfx_int(J,R,options);
        
                region = region + 1;
             
      
            end
            
            Xprueba = Xprueba(:,handles.sclean);
            
            
            M = size(Xprueba,1); 

            Xprueba = Xprueba.*(ones(M,1)*handles.a) + ones(M,1)*handles.b;
            
            
            Xprueba = Xprueba(:,handles.sfs);
            
            
 
            
           
            switch get(handles.popupmenu1,'Value')
    
            case 1 
                %[handles.Acc,handles.ops] = Classifier(handles.Xtrain,handles.Xtest,handles.dtrain,handles.dtest,1);
              
                handles.dpredtest = Bcl_knn(Xprueba,handles.ops);
                
        
        
            case 2 
                %[handles.Acc,handles.ops] = Classifier(handles.Xtrain,handles.Xtest,handles.dtrain,handles.dtest,2); 
               
                handles.dpredtest = Bcl_lda(Xprueba,handles.ops);
                
        
            case 3 
                %[handles.Acc,handles.ops] = Classifier(handles.Xtrain,handles.Xtest,handles.dtrain,handles.dtest,3);
                
                handles.dpredtest = Bcl_qda(Xprueba,handles.ops);
                
        
            case 4 
                %[handles.Acc,handles.ops] = Classifier(handles.Xtrain,handles.Xtest,handles.dtrain,handles.dtest,4);
                % Clasificador SVM
                handles.dpredtest = Bcl_libsvm(Xprueba,handles.ops);    % rbf-SVM classifier testing
                
       
            end

Resultados = cell(length(handles.dpredtest),1);          
for q =  1:length(handles.dpredtest)
    for h = 1:length(handles.H)
        if (handles.dpredtest == h)
            Resultados(q) = handles.H(h);
            
        end
        
    end
    
end
        
Resultados_str = '';

for i = 1:length(Resultados)
    strcat(Resultados_str,string(Resultados(i)));
end
    
    

%set(handles.text3, 'String', Resultados_str);
set(handles.text3, 'String', num2str(handles.dpredtest'));
            
 
axes(handles.axes1)
imshow(I,[]);

axes(handles.axes2)
imshow(L,[]);
            
            
            
else
    
   uiwait(msgbox("Imagen no segmentada")); 


end

handles.output = hObject;
guidata(hObject, handles);
