function labedge = edge_track(labimg)
set1 = labimg(:,:,1);
set2 = labimg(:,:,2);
set3 = labimg(:,:,3);
[M, N] = size(set1);
tot_len = M*N;
temp_arry = set1;
temp_arry(1, :) = [];
L_rise = [temp_arry; set1(M, :)];
temp_arry = set1;
temp_arry(M, :) = [];
L_fall = [set1(1, :); temp_arry];
temp_arry = set1;
temp_arry(:, N) = [];
L_right = [set1(:, 1) temp_arry];
temp_arry = set1;
temp_arry(:, 1) = [];
L_left = [temp_arry set1(:, N)];
L_edge = abs(L_fall-L_rise)+abs(L_right-L_left);


temp_arry = set2;
temp_arry(1, :) = [];
A_rise = [temp_arry; set2(M, :)];
temp_arry = set2;
temp_arry(M, :) = [];
A_fall = [set2(1, :); temp_arry];
temp_arry = set2;
temp_arry(:, N) = [];
A_right = [set2(:, 1) temp_arry];
temp_arry = set2;
temp_arry(:, 1) = [];
A_left = [temp_arry set2(:, N)];
A_edge = abs(A_fall-A_rise)+abs(A_right-A_left);

temp_arry = set3;
temp_arry(1, :) = [];
B_rise = [temp_arry; set3(M, :)];
temp_arry = set3;
temp_arry(M, :) = [];
B_fall = [set3(1, :); temp_arry];
temp_arry = set3;
temp_arry(:, N) = [];
B_right = [set3(:, 1) temp_arry];
temp_arry = set3;
temp_arry(:, 1) = [];
B_left = [temp_arry set3(:, N)];
B_edge = abs(B_fall-B_rise)+abs(B_right-B_left);

labedge = L_edge + A_edge + B_edge;

end