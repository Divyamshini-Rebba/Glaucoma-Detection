function daq_cont = cont_det(img, klabels)
hori = [-1, -1, 0, 1, 1, 1, 0, -1];
vert = [0, -1, -1, -1, 0, 1, 1, 1];
[ht, wt, maap] = size(img);
daq_cont = uint8(zeros(ht, wt));
mainindex = 0;
cind = 0;
for j = 1: ht
    for k = 1: wt
        np = 0;
        for i = 1: 8
            x = k+hori(1, i);
            y = j+vert(1, i);
            if (x>0&&x<=wt&&y>0&&y<ht)
               if (klabels(j, k)~=klabels(y, x))
                   np = np+1;
               end
            end
        end
        if (np>2)
            daq_cont(j, k) = 255;
        end
    end
end

            