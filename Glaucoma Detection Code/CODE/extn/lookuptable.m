function L=lookuptable(im,LUT)

Imin=min(im(:));
Imax=max(im(:));
I=Imin:Imax;
L=zeros(size(im),'uint8');
for k=1:max(LUT)
        i=find(LUT==k);
    i1=i(1);
    if numel(i)>1
        i2=i(end);
    else
        i2=i1;
    end
    
    
    bw=im>=I(i1) & im<=I(i2);
    L(bw)=k;
    
end

