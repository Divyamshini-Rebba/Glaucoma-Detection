function grop_dq = sp_perfor(img_Lab, kseedsl, kseedsa, kseedsb, ini_hori, ini_verti, STEP, compactness)
[ht, wt, maap] = size(img_Lab);
[ini_sq xxxxx]= size(kseedsl);
img_Lab = double(img_Lab);
grop_dq = zeros(ht, wt);
grop_dat = zeros(ini_sq,1);
inv = zeros(ini_sq,1);
dat_l = zeros(ini_sq,1);
seq_aa = zeros(ini_sq,1);
seq_ab = zeros(ini_sq,1);
vec_hori = zeros(ini_sq,1);
vec_vert = zeros(ini_sq,1);
invwt = 1/((double(STEP)/double(compactness))*(double(STEP)/double(compactness)));
distvec = 100000*ones(ht, wt);
numk = ini_sq;
for itr = 1: 10  
    dat_l = zeros(ini_sq, 1);
    seq_aa = zeros(ini_sq, 1);
    seq_ab = zeros(ini_sq, 1);
    vec_hori = zeros(ini_sq, 1);
    vec_vert = zeros(ini_sq, 1);
    grop_dat = zeros(ini_sq, 1);
    inv = zeros(ini_sq, 1);
    distvec = double(100000*ones(ht, wt));
    for n = 1: numk
        y1 = max(1, ini_verti(n, 1)-STEP);
        y2 = min(ht, ini_verti(n, 1)+STEP);
        x1 = max(1, ini_hori(n, 1)-STEP);
        x2 = min(wt, ini_hori(n, 1)+STEP);
        for y = y1: y2
            for x = x1: x2
                dist_lab = (img_Lab(y, x, 1)-kseedsl(n, 1))^2+(img_Lab(y, x, 2)-kseedsa(n, 1))^2+(img_Lab(y, x, 3)-kseedsb(n, 1))^2;
                dist_xy = (double(y)-ini_verti(n, 1))*(double(y)-ini_verti(n, 1)) + (double(x)-ini_hori(n, 1))*(double(x)-ini_hori(n, 1));
                dist = dist_lab + dist_xy*invwt;
                if (dist<distvec(y, x))
                    distvec(y, x) = dist;
                    grop_dq(y, x) = n;
                end
            end
        end
    end
    ind = 1;
    for r = 1: ht
        for c = 1: wt
            dat_l(grop_dq(r, c),1) = dat_l(grop_dq(r, c),1)+img_Lab(r, c, 1);
            seq_aa(grop_dq(r, c),1) = seq_aa(grop_dq(r, c),1)+img_Lab(r, c, 2);
            seq_ab(grop_dq(r, c),1) = seq_ab(grop_dq(r, c),1)+img_Lab(r, c, 3);
            vec_hori(grop_dq(r, c),1) = vec_hori(grop_dq(r, c),1)+c;
            vec_vert(grop_dq(r, c),1) = vec_vert(grop_dq(r, c),1)+r;
            grop_dat(grop_dq(r, c),1) = grop_dat(grop_dq(r, c),1)+1;
        end
    end
    for m = 1: ini_sq
        if (grop_dat(m, 1)<=0)
            grop_dat(m, 1) = 1;
        end
        inv(m, 1) = 1/grop_dat(m, 1);
    end
    for m = 1: ini_sq
        kseedsl(m, 1) = dat_l(m, 1)*inv(m, 1);
        kseedsa(m, 1) = seq_aa(m, 1)*inv(m, 1);
        kseedsb(m, 1) = seq_ab(m, 1)*inv(m, 1);
        ini_hori(m, 1) = vec_hori(m, 1)*inv(m, 1);
        ini_verti(m, 1) = vec_vert(m, 1)*inv(m, 1);
    end
end


end


