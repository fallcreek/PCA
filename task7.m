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

%% Adding noise to one of the other 10 people¡¯s neutral expression image, 
% and reconstruct the image using different number of PCs. Try different level of Gaussian noise.

img_number = 191
% reconstruction neutral image
mean = 0.5;
var = 0.1;

ori_img = neutral(:,img_number);
noise_img = imnoise(ori_img, 'gaussian', mean, var);

figure
hold on
subplot(6,2,1)
imshow(reshape(ori_img,193,162),[]);
title('original img')

subplot(6,2,2)
imshow(reshape(noise_img,193,162),[]);
t = string('original img with white guassian noise') + string('N(') + string(mean) + string(',') + string(var) + string(')');
title(char(t))

% reconstruction neutral image
components_list = 10:20:190;
img_number = 191;
i = 3;
for components = components_list    
    u_components = u_sorted(:, 1:components);
    weights = u_components' * (double(noise_img) - neutral_average);
    reconstruct_img = u_components * weights + neutral_average;
    
    subplot(6,2,i)  
    imshow(reshape(reconstruct_img(:),193,162),[]);
    title(char(string(components) + string('PCs')))
    i = i + 1;
end
