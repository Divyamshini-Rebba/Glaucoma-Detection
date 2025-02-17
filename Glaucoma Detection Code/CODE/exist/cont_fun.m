function grouping = cont_fun(img_Lab, labels, K)
hori = [-1, 0, 1, 0];
vert = [0, -1, 0, 1];
[ht, wt, maap] = size(img_Lab);
[M, N] = size(labels);
nor_pix = (ht*wt)/K;  
grouping = (-1)*ones(M, N);
label = 1;
adjlabel = 1;
horz_sq = zeros(ht*wt, 1);
vert_daq = zeros(ht*wt, 1);
m = 1;
n = 1;

for j = 1: ht
    for k = 1: wt
        if (0>grouping(m, n))
            grouping(m, n) = label;
            horz_sq(1, 1) = k;
            vert_daq(1, 1) = j;
            for i = 1: 4
                x = horz_sq(1, 1)+hori(1, i);
                y = vert_daq(1, 1)+vert(1, i);
                if (x>0 && x<=wt && y>0 && y<=ht)
                    if (grouping(y, x)>0)
                        adjlabel = grouping(y, x);
                    end
                end
            end
            count = 2;
            c = 1;
            while (c<=count)
                for i = 1: 4
                    x = horz_sq(c, 1)+hori(1, i);
                    y = vert_daq(c, 1)+vert(1, i);
                    if (x>0 && x<=wt && y>0 && y<=ht)
                        if (0>grouping(y, x) && labels(m, n)==labels(y, x))
                            horz_sq(count, 1) = x;
                            vert_daq(count, 1) = y;
                            grouping(y, x) = label;
                            count = count+1;
                        end
                    end
                end
                c = c+1;
            end
            if (count<(nor_pix/4))
                for c = 1: (count-1)
                    grouping(vert_daq(c, 1), horz_sq(c, 1)) = adjlabel;
                end
                label = label-1;
            end
            label = label+1;
            %%%%%%%%%%%%%%
        end
        n = n+1;
        if (n>wt)
            n = 1;
            m = m+1;
        end
        %%%%%%%%%%%%
    end
end

end


