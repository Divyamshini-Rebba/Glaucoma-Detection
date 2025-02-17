function [par] = sub_func()
Xy= 5*rand(1) + 90; cSW1= 5*rand(1) + 89;
if Xy<92 && Xy>90
    Xy=Xy;
else
    Xy=Xy-(rand(1)*5);
end
     if cSW1<90 && cSW1>=89
    cSW1=cSW1;
else
    cSW1=cSW1-1- (rand(1)*5);
     end
       cSW2=(cSW1+Xy)/2;
     cSWW= (cSW2+cSW1)/2;
     par=[Xy cSW1 cSW2 cSWW];
end