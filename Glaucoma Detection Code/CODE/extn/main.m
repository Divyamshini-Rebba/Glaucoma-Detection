clc
clear all
close all
warning off
[filename, pathname] = uigetfile({'*.jpg;*.tiff;*.png;*.bmp'},'Pick a file');
f = fullfile(pathname, filename);
disp('Reading image')
name=filename;
[pathstr, count, ext] = fileparts(f);
img = imread(name);
res_img = imresize(img,[256 256]);
gr_img = rgb2gray(res_img);
figure(1),imshow(gr_img),title('Input Image')
pause(0.2)
 h = fspecial('unsharp');
filt_img = imfilter(res_img(:,:,2),h);
h = fspecial('disk',4);
filt_img = imfilter(filt_img,h);
figure(2),imshow(filt_img),title('Filtered Image')
pause(0.2);
bw = im2bw(filt_img,0.43);
figure(3),imshow(bw),title('BW Image')
se = strel('disk',5);
BW_erod = imopen(bw,se);
se = strel('disk',5);
BW_dil = imdilate(BW_erod,se);
figure(4),imshow(BW_dil),title('Optic Disc')
[L, numrical] = bwlabel(BW_dil);
identy=regionprops(L,'all');
if numrical == 0
   
        disp('1:Optic Disc - Not Spotted')
newdatabase = [];
elseif numrical > 1
newdatabase = [];
database = regionprops(L,'basic');

for counterdata = 1:length(database)
if ((database(counterdata).Centroid(1) >= 75 && database(counterdata).Centroid(1) <= 110) || ...
(database(counterdata).Centroid(1) >= 160 && database(counterdata).Centroid(1) <= 190)) && ...
(database(counterdata).Centroid(2) >= 110 && database(counterdata).Centroid(2) <= 145)
newdatabase = database(counterdata);
end
end
else
database = regionprops(L,'basic');

if database.Centroid(2) < 100 || database.Centroid(2) > 150
 disp('3:Optic Disc - Not Spotted')
 msg = cell(3,1);
     msg{1} =sprintf('Regular Tissue not GLAUCOMA Type ');
    msg{2} = sprintf('Dont Need Medical Attention');
     msg{3} = sprintf('Happy Life');
     msgbox (msg)
newdatabase = [];
%break;
else
newdatabase = database;
end
end
%if ~isempty(newdatabase)
if newdatabase.BoundingBox(3) < 50
newdatabase.BoundingBox(1) = newdatabase.BoundingBox(1) - ...
(50 - newdatabase.BoundingBox(3))/2;
newdatabase.BoundingBox(3) = 50;
end
if newdatabase.BoundingBox(4) < 50
newdatabase.BoundingBox(2) = newdatabase.BoundingBox(2) - ...
(50 - newdatabase.BoundingBox(4))/2;
newdatabase.BoundingBox(4) = 50;
end
if newdatabase.BoundingBox(3) > 100
newdatabase.BoundingBox(3) = 100;
end
if newdatabase.BoundingBox(4) > 140
newdatabase.BoundingBox(2) = newdatabase.BoundingBox(2) + 20;
newdatabase.BoundingBox(4) = 110;
end

region = imcrop(gr_img,newdatabase.BoundingBox);

uiloc = find(any(region<3));

if isempty(uiloc)
ROI = region;
elseif uiloc(1) == 1
ROI = region(:,uiloc(length(uiloc))+1:end);
else
ROI = region(:,1:uiloc(1)-1);
end
 figure(5),imshow(ROI),title('Input to Contour detection')
 pause(0.5)
imwrite(ROI,'ODisc.tif')
imag='ODisc.tif';
va=6;
[output,BW]=contour(imag,va);
output(:,:,1) = output;                           
output(:,:,2) = output(:,:,1);                    
output(:,:,3) = output(:,:,1);                    
output(:,:,2) = min(output(:,:,2) + BW, 1.0);     
output(:,:,3) = min(output(:,:,3) + BW, 1.0);     
subplot(2,2,4); imshow(output); title('output');  
pause(1)
figure;

L2=bwlabel(BW_erod,8);

STATS=regionprops(L,'all');

[B,L,N,A] = bwboundaries(L2);

%Display results
%%%%%%%%%%%%%%%%%%%%%%%%%%
q=2;c=3;
%img=out;
Imin=double(min(gr_img(:)));
Imax=double(max(gr_img(:)));
I=(Imin:Imax)';
H=hist(gr_img(:),I);
H=H(:);
if numel(c)>1
    C=c;
    c=numel(c);
else
    [~,C]=fuzzyclust(gr_img,c);
end
 I=repmat(I,[1 c]); dC=Inf;
while dC>1E-6
    
    C0=C;
    
    D=abs(bsxfun(@minus,I,C));
    D=D.^(2/(q-1))+eps;
    
    
    U=bsxfun(@times,D,sum(1./D,2));
    U=1./(U+eps);
    
    
    UH=bsxfun(@times,U.^q,H);
    C=sum(UH.*I,1)./sum(UH,1);
    C=sort(C,'ascend'); 
    
    dC=max(abs(C-C0));
    
end

[Umax,LUT]=max(U,[],2);
L=lookuptable(gr_img,LUT);
figure('color','w')
subplot(1,2,1), imshow(gr_img)
set(get(gca,'Title'),'String','ORIGINAL')
 
Lrgb=zeros([numel(L) 3],'uint8');
for i=1:3
    Lrgb(L(:)==i,i)=255;
end
Lrgb=reshape(Lrgb,[size(gr_img) 3]);

subplot(1,2,2), imshow(Lrgb,[])
set(get(gca,'Title'),'String','Cluster(C=3)')

%%%%%%%%%%%%%%%%%%%

figure; imshow(L2);title('BackGround Detected');
figure;imshow(L2);title('Blob Detected');

hold on;

for k=1:length(B),

if(~sum(A(k,:)))
boundary = B{k};
plot(boundary(:,2), boundary(:,1),'r','LineWidth',2);
end

end
BW2 = bwmorph(L2,'remove');
figure;
imshow(BW2);
title('boundary scaling');
BW3 = bwmorph(BW2,'skel',Inf);
figure;
imshow(BW3);
title('Skeleteon extraxt');
B = bwboundaries(BW3);
figure;
imshow(BW3)
text(10,10,strcat('\color{green}Objects Found:',num2str(length(B))))
hold on

disp('Computing pattern...')
val = zeros(size(gr_img,1)-size(ROI,1),size(gr_img,2)-size(ROI,2));
for i = 1:size(gr_img,1)-size(ROI,1)
for j = 1:size(gr_img,2)-size(ROI,2)
portion = gr_img(i:i+size(ROI,1)-1,j:j+size(ROI,2)-1);
val(i,j) = corr2(ROI,portion);
end 
end
[r,c] = find(val == 1);
rect = [c r size(ROI,2) size(ROI,1)];

figure(7),imshow(gr_img),title('Region Segmented');
rectangle('Position',rect,'EdgeColor','g');
cooccur_matri = graycomatrix(gr_img,'Offset',[2 0;0 2]);
stats = glc_feature_analysis(cooccur_matri,0);
energy = stats.energ;
entrophy = stats.entro;
contust = stats.contr;
autoCorr = stats.autoc;
prob = stats.maxpr;
homog = stats.homop;
feat1=[energy entrophy contust autoCorr prob homog];
somenames={'Energy','Entrophy','Contust','AutoCorr','Prob','Homog'};
figure;
bar(feat1);
grid on;
axis on;
title('Feature Extractd');
RegionNo = size(STATS, 1);
RegionECD = zeros(1, RegionNo);
load data1;load data2;feat1 =autoCorr;
load data3;load data4
T=[data1,data2,data3,data4];
x=[0 0 1 1];
for k = 1 : 5:RegionNo           

	RegionArea = STATS(k).Area;		
	RegionPerimeter = STATS(k).Perimeter;		
	RegionCentroid = STATS(k).Centroid;		
	RegionECD(k) = sqrt(4 * RegionArea / pi);					
	%fprintf(1,'#%2d            %11.1f %8.1f %8.1f %8.1f % 8.1f\n', k,  RegionArea, RegionPerimeter, RegionCentroid, RegionECD(k));
Y=RegionECD(k);
end
dcnn.start=1; % just intiationg dcnn object
 dcnn=initialcnn(dcnn,[60 60 ]);
 dcnn=cnnConvLayer(dcnn, 9, [5 5], 'rect'); % 1 Convolution Layer
 dcnn=cnnPoolLayer(dcnn, 2, 'mean');        % 1 Pooling Layer
 dcnn=cnnConvLayer(dcnn, 15, [5 5], 'rect');% 2 Convolution Layer
 dcnn=cnnPoolLayer(dcnn, 2, 'mean');        % 2 Pooling Layer
 dcnn=cnnConvLayer(dcnn, 21, [5 5], 'rect');% 3 Convolution Layer
 dcnn=cnnPoolLayer(dcnn, 2, 'mean');        % 3 Pooling Layer

dcnn = functioncnn(dcnn, res_img);
net = dcnn.layers{1,7}.featuremaps{1,1};
net = round(net(:)');
%Training_feat(ii,:) = net;

[net1,para]= De_Conve_funnet(minmax(T),[20 10 1],{'logsig','logsig','purelin'},'trainrp');
net1.trainParam.show = 1000;
net1.trainParam.lr = 0.04;
net1.trainParam.epochs = 7000;
net1.trainParam.goal = 1e-5;

%train the neural network using the input,target and the created network
[net1] = train(net1,T,x);
%save the network
save net1 net1
y = (round(sim(net1,data1))+Y);

   
if y>49.5
    msg = cell(2,1);
     msg{1} =sprintf('BEGIN GLAUCOMA LEVEL ');
    msg{2} = sprintf('May be a TISSUE');
    msgbox (msg)
else
    msg = cell(3,1);
     msg{1} =sprintf('MELIGIANT GLAUCOMA LEVEL ');
    msg{2} = sprintf('Need Medical Attention');
     msg{3} = sprintf('Consult Doctor');
     msgbox (msg)
end
somenames={'Accuracy','Specifity','Sensitivity','Precision'};
figure;
bar(para);
set(gca,'xticklabel',somenames)
xlabel('Parameters ');ylabel('values');
title('Features Parameters');
grid on;axis on;
fprintf('Accuracy = %f\n',para(1));
fprintf('Specifity = %f\n',para(2));
fprintf('Sensitivity = %f\n',para(3));
fprintf('Precision = %f\n',para(4));