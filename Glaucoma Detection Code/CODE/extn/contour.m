function [iout,bin_val]=contour(image,val)
data_img=image;
v=val/10;
data_img = double(imread(data_img))./255;  

d = edge(data_img,'canny',v);                    
%subplot(2,2,2); imshow(d); title('d');      
ds = bwareaopen(d,40);                     
%subplot(2,2,3); imshow(ds); title('ds')
iout = data_img;
bin_val = ds;
