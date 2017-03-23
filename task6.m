load neutral_img
load smile_img

% reshape 193*162 matrix to vector
neutral = reshape(neutral_img, 193*162, 200);
smile = reshape(smile_img, 193*162, 200);

% only use the first 190 figures
neutral_190 = double(neutral(:,1:190));
smile_190 = double(smile(:,1:190));

% calculate the average vector
neutral_average = sum(neutral_190')' .* 1/190;
smile_average = sum(smile_190')' .* 1/190;

% subtract average
neutral_diff = neutral_190 - neutral_average;
smile_diff = smile_190 - smile_average;

% eigenvalues and eigenvectors of A'A
[v, lam] = eig(neutral_diff' * neutral_diff);
lam = diag(lam);

% best M eigenvectors of AA' 
u = neutral_diff * v;

% normlize u
for i = 1:size(u,2)
    u(:,i) = u(:,i) / norm(u(:,i));
end

% sort eigenvalues and eigenvectors
[lam_sorted, index] = sort(lam, 'descend');
u_sorted = u(:,index);

%% Rotate one of 190 people¡¯s neutral expression image with different degrees and try to reconstruct it using all PCs
img_number = 1;
img_vector = neutral(:,img_number);
img_ori = reshape(img_vector, 193, 162);
neutral_average_rotate = reshape(neutral_average, 193, 162);

figure
hold on
degrees = 45:45:360;
i = 1;
for degree = degrees
    img_rotate = imrotate(img_ori, degree, 'crop');
    average_rotate = imrotate(neutral_average_rotate, degree, 'crop');
    
    subplot(4, 4, i)
    imshow(img_rotate,[]);
    title(char(string('degree = ') + string(degree) + string(' : original')))
    i = i + 1;
    
    img_rotate = reshape(img_rotate, 193 * 162, 1);
    average_rotate = reshape(average_rotate, 193 * 162, 1);
    u_components = u_sorted;
    weights = u_components' * (double(img_rotate) - average_rotate);
    reconstruct_img = u_components * weights + average_rotate;
    subplot(4, 4, i)
    imshow(reshape(reconstruct_img, 193, 162),[]);
    title(char(string('degree = ') + string(degree) + string(' : reconstruct')))
    i = i + 1;
end
