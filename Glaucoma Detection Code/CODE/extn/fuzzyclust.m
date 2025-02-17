function [L,C,LUT]=fuzzyclust(im,c)

Imin=double(min(im(:)));
Imax=double(max(im(:)));
I=(Imin:Imax)';

H=hist(double(im(:)),I);
H=H(:);

% Initialize cluster centroid
if numel(c)>1
    C=c;
    c=numel(c);
else
    dI=(Imax-Imin)/c;
    C=Imin+dI/2:dI:Imax;
end


IH=I.*H; dC=Inf;
while dC>1E-6
    
    C0=C;
    
  
    D=abs(bsxfun(@minus,I,C));
    
   
    [Dmin,LUT]=min(D,[],2); %#ok<*ASGLU>
    for j=1:c
        C(j)=sum(IH(LUT==j))/sum(H(LUT==j));
    end
    
    dC=max(abs(C-C0));
    
end
L=lookuptable(im,LUT);

