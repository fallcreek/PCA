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

%% Use other non-human image, and try to reconstruct it using all PCs
car_img = imread('car3.jpg');
car_img = car_img(:,:,1);
car_vector = reshape(car_img, 193*162, 1);
figure
hold on
subplot(1,2,1)
imshow(car_img,[]);
title('original img')
u_components = u_sorted;
weights = u_components' * (double(car_vector) - neutral_average);
reconstruct_img = u_components * weights + neutral_average;
    
subplot(1,2,2)  
imshow(reshape(reconstruct_img(:),193,162),[]);
title('reconstruct with all PCs')

phi_reconstruct = reconstruct_img - neutral_average;
phi_ori = (double(car_vector) - neutral_average);

norm(phi_reconstruct - phi_ori)^2

