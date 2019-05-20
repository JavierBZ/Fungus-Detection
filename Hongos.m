% Investigación Hongos 2019-1 
% Pontificia Universidad Católica de Chile
% Tutor: Paulette Legarraga
% Alumno: Javier Bisbal

pause

%% Primera Parte: Segmentación
% Con Escala de grises

% Hola

clear all

h1 = 'Asp_flavus';
h2 = 'Asp_fumigatus';
h3 = 'Asp_terreus';
h4 = 'Asp_ustus';
h5 = 'Asp_niger';

H = {h1, h2, h3, h4,h5};

N_hongos = size(H,2); % Número de especies a segmentar

Hongos_R = cell(1,size(1,N_hongos));
Hongos_Seg = cell(1,size(1,N_hongos));
    
for k = 1:N_hongos
    Hongos_R(k) = {['Hongos2/' char(H(k)) '_R']};
    Hongos_Seg(k) = {['Hongos2/' char(H(k)) '_R_Seg']};
end

% Hongos_R = {['Hongos2/' h3 '_R'],['Hongos2/' h4 '_R']}; %Editar agregando más hongos
% 
% Hongos_R = {['Hongos2/' h3 '_R'],['Hongos2/' h4 '_R']}; 
% 
% Hongos_Seg = {['Hongos2/' h3 '_R_Seg'],['Hongos2/' h4 '_R_Seg']};

M = 0;
for k = 1:N_hongos
    st = char(Hongos_R(k));
    M = M + size(dir([char(Hongos_R(k)) '/*.tif']),1);
end

%M = n1 + n2;
m = 1;
N_hongos = 2;  % Numero de hongos a clasificar
ff = Bio_statusbar('Segmentando Hongos');
for k = 1:N_hongos
  
    st = char(Hongos_R(k));
    str2 = char(Hongos_Seg(k));
    d = dir([st '/*.tif']);
    
    for i = 1:size(dir([st '/*.tif']),1)
        ff = Bio_statusbar(m/M,ff);
        I = imread([st '/' d(i).name]);
        I(:,:,4) = []  ;%??
        I = imresize(I,0.1);
        gray = rgb2gray(I);
        Seg = (gray<140);
        Seg2 = imopen(Seg,strel('disk',10,6));
        Seg3 = imclose(Seg2,strel('disk',10,6));
        R = Bim_segbalu(I);
    
        bwFilename = sprintf('%s_Seg3.png', d(i).name(1:end-4)); %se guardan en formato png para conservar el formato binario.
        imwrite(R,fullfile(str2,bwFilename));
        m = m + 1;
end
end

delete(ff)


%% Con canales
% 
% R = Im;
% G = Im; 
% B = Im;
% 
% R(:,:,2:3)= 0;
% G(:,:,[1 3])= 0;
% B(:,:,[1 2])= 0;
% 
% figure,
% imshow(R)
% figure,
% imshow(G)
% figure,
% imshow(B)
% 
% n = 1:30;
% 
% st = 'HONGOS_20190417'; %Carpeta con las imágenes
% d = dir([st '/*.tif']);
% 
% m = 1;
% for i = n
%     I = imread([st '/' d(i).name]);
%     
%     gray = I;
%     gray(:,:,[1 2])= [];
%     
%     Seg = gray>200;
%     Seg2 = imopen(Seg,strel('disk',10,6));
%     Seg3 = imclose(Seg2,strel('disk',10,6));
%     
% %     bwFilename = sprintf('%s_Seg1.png', d(i).name); %se guardan en formato png para conservar el formato binario.
% %     imwrite(Seg,fullfile('HONGOS_SEG2',bwFilename));
% %    
% %     bwFilename = sprintf('%s_Seg2.png', d(i).name); %se guardan en formato png para conservar el formato binario.
% %     imwrite(Seg2,fullfile('HONGOS_SEG2',bwFilename));
%    
%     bwFilename = sprintf('%s_Seg3.png', d(i).name); %se guardan en formato png para conservar el formato binario.
%     imwrite(Seg3,fullfile('HONGOS_SEG2',bwFilename));
%    
%    
% %    bwFilename = sprintf('%s_bw.png', d(i).name); %se guardan en formato png para conservar el formato binario.
% %    imwrite(Seg,fullfile('HONGOS_SEG1',bwFilename));
%     
%     m = m + 1;
% end




%% Extracción características
clear all
warning off


h1 = 'Asp_flavus';
h2 = 'Asp_fumigatus';
h3 = 'Asp_terreus';
h4 = 'Asp_ustus';
h5 = 'Asp_niger';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H = {h1, h2, h3,h4}; %%% Editar para escoger hongos a evaluar%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_hongos = size(H,2); % Número de especies a segmentar

Hongos_R = cell(1,size(1,N_hongos));
Hongos_Seg = cell(1,size(1,N_hongos));
    
for k = 1:N_hongos
    Hongos_R(k) = {['Hongos2/' char(H(k)) '_R']};
    Hongos_Seg(k) = {['Hongos2/' char(H(k)) '_R_Seg']};
end

M = 0;
for k = 1:N_hongos
    st = char(Hongos_R(k));
    M = M + size(dir([char(Hongos_R(k)) '/*.tif']),1);
end



m = 1;
nf = 36*3 % + 6*3; %% Número de características a extraer 36
X = zeros(M,nf);


ff = Bio_statusbar('Procesando Hongos');
for k = 1:N_hongos
    st = char(Hongos_R(k));
    str2 = char(Hongos_Seg(k));
    d = dir([st '/*.tif']);
    d2 = dir([str2 '/*.png']);
    
    for i = 1:size(dir([st '/*.tif']),1)
        ff = Bio_statusbar(m/M,ff);
    
        I = imread([st '/' d(i).name]);
        R = imread([str2 '/' d2(i).name]);
        I(:,:,4) = []  ;%??
        J = rgb2gray(I);
        
%         
        %b(2).name = 'basicint';  b(2).options.show=1;
        b(1).name = 'lbp';  b(1).options.show=1;
        
                            b(1).options.vdiv        = 1;           % three vertical divition
                            b(1).options.hdiv        = 1;           % three horizontal   divition
                            b(1).options.samples     = 8;           % number of neighbor samples 
                            b(1).options.mappingtype = 'ri';        % rotation invariant LBP
        
        options.b = b;
        options.colstr = 'rgb';
        %options.colstr = 'i';
        [X(m,:),Xn]= Bfx_int(I,[],options);

        m = m + 1;
    end
end
 
delete(ff);
%% Post procesamiento características

%Separamos en datos de training y testing

c = zeros(1,N_hongos);
for k = 1:N_hongos
    st = char(Hongos_R(k));
    c(k) = size(dir([st '/*.tif']),1);
end

d = Bds_labels(c);

[Xtrain,dtrain,Xtest,dtest] = Bds_stratify(X,d,0.7);

%%Clean
 s = Bfs_clean(Xtrain,1);
 Xclean = Xtrain(:,s);


%Normalización
M = size(Xtest(:,s),1); 
[Xtrain,a,b] = Bft_norm(Xtrain(:,s),1);
Xtest = Xtest(:,s).*(ones(M,1)*a) + ones(M,1)*b;

%Labels de hongos
% c = [12 13];
% Ytrain = Bds_labels(c);
% Ytest = Bds_labels([3 2]);


%% Selección de características
op.m = 20;                     % 10 features will be selected
op.show = 1;                   % display results
op.b.name = 'fisher';          % SFS with Fisher
s = Bfs_sfs(Xtrain,double(dtrain),op);   % index of selected features

%% Clasificador KNN

options.k = 1; %Modificamos el parámetro k para hacer knn con k=1
dpred = Bcl_knn(Xtrain(:,s),dtrain,Xtest(:,s),options) ; 
%dpred = Bcl_knn(Xtrain,dtrain,Xtest,options) ; %Obtenemos vector que predice las clases
Acc = Bev_performance(dpred,dtest)

%% Clasificador LDA

op.p = [];
dpred = Bcl_lda(Xtrain(:,s),dtrain,Xtest(:,s),op);
accuracy = Bev_performance(dpred,dtest)

%% Clasificador QDA

op1.p = [];
dpred = Bcl_qda(Xtrain(:,s),dtrain,Xtest(:,s),op1);
accuracy = Bev_performance(dpred,dtest)  

%% Ver que esta pasando :O
close all


figure
hold on
for p = 1:size(Xtest,1)
    if (dtest(p)==1)
        color = 'r';
        p1 = plot(Xtest(p,s),'r');
    elseif (dtest(p)==2)
        color = 'b';
        p2 = plot(Xtest(p,s),'b');
    elseif (dtest(p)==3)
        color = 'b';
        p3 = plot(Xtest(p,s),'g');   
    elseif (dtest(p)==4)
        color = 'b';
        p4 = plot(Xtest(p,s),'y');
    end
    
end


legend([p1 p2],h1,h4)
%legend([p1 p2 p3],h1,h2,h3)
%legend([p1 p2 p3 p4],h1,h2,h3,h4)
title('Vectores de características hongos de prueba')
hold off

figure
hold on
for p = 1:size(Xtrain,1)
    if (dtrain(p)==1)
        color = 'r';
        p1 = plot(Xtrain(p,s),'r');
    elseif (dtrain(p)==2)
        color = 'b';
        p2 = plot(Xtrain(p,s),'b');
    elseif (dtrain(p)==3)
        color = 'r';
        p3 = plot(Xtrain(p,s),'g');
    elseif (dtrain(p)==4)
        color = 'b';
        p4 = plot(Xtrain(p,s),'y');
    end
    
end

legend([p1 p2],h1,h4)
%legend([p1 p2 p3],h1,h2,h3)
%legend([p1 p2 p3 p4],h1,h2,h3,h4)
title('Vectores de características hongos de entrenamiento')
hold off

