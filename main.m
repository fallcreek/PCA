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

%% Reconstruct one of 190 people¡¯s neutral expression image using different number of PCs
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

% plot the scatter of eigenvalues
% figure 
% x = 1:1:190
% scatter(x, lam_sorted)
% title('eigenvalues scatter')
% xlabel('number of components')
% ylabel('eigenvalues')


% figure;imshow(reshape(u_sorted(:,1),193,162),[]);
% figure;imshow(reshape(u_sorted(:,2),193,162),[]);
% figure;imshow(reshape(u_sorted(:,3),193,162),[]);


% reconstruction neutral image
components_list = 10:10:190;
img_number = 2;
figure
hold on
subplot(5,4,1)
imshow(reshape(neutral_190(:,img_number),193,162),[]);
title('original img')
i = 2;
for components = components_list    
    u_components = u_sorted(:, 1:components);
    weights = u_components' * neutral_diff(:,img_number);
    reconstruct_img = u_components * weights + neutral_average;
    
    subplot(5,4,i)  
    imshow(reshape(reconstruct_img(:),193,162),[]);
    title(char(string(components) + string('PCs')))
    i = i + 1;
end

%% Reconstruct one of 190 people¡¯s smiling expression image using different number of PCs

% reconstruction neutral image
components_list = 10:10:190;
img_number = 2;
figure
hold on
subplot(5,4,1)
imshow(reshape(smile_190(:,img_number),193,162),[]);
title('original img')
i = 2;
for components = components_list    
    u_components = u_sorted(:, 1:components);
    weights = u_components' * smile_diff(:,img_number);
    reconstruct_img = u_components * weights + smile_average;
    
    subplot(5,4,i)  
    imshow(reshape(reconstruct_img(:),193,162),[]);
    title(char(string(components) + string('PCs')))
    i = i + 1;
end

%% Reconstruct one of the other 10 people¡¯s neutral expression image using different number of PCs

% reconstruction neutral image
components_list = 10:10:190;
img_number = 191;
figure
hold on
subplot(5,4,1)
imshow(reshape(neutral(:,img_number),193,162),[]);
title('original img')
i = 2;
for components = components_list    
    u_components = u_sorted(:, 1:components);
    weights = u_components' * (double(neutral(:,img_number)) - neutral_average);
    reconstruct_img = u_components * weights + neutral_average;
    
    subplot(5,4,i)  
    imshow(reshape(reconstruct_img(:),193,162),[]);
    title(char(string(components) + string('PCs')))
    i = i + 1;
end

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

%% Adding noise to one of the other 10 people¡¯s neutral expression image, 
% and reconstruct the image using different number of PCs. Try different level of Gaussian noise.

% reconstruction neutral image
mean = 0.5;
var = 0.01;

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


%% Recompute the PCs using first 190 people¡¯s neutral expression image, but with first person¡¯s image contaminated by noise. Try to reconstruct that person¡¯s noisy image using different number of PCs. Explain why the noise is not removed at all when using all the PCs.

% only use the first 190 figures
neutral_190_with_noise = double(neutral(:,2:190));
mean = 0;
var = 0.01;

% contaminate the first image by noise

neutral_190_with_noise = [double(imnoise(neutral(:,1), 'gaussian', mean, var)), neutral_190_with_noise];

% calculate the average vector
neutral_average_with_noise = sum(neutral_190_with_noise')' .* 1/190;

% subtract average
neutral_diff_with_noise = neutral_190_with_noise - neutral_average_with_noise;

% Reconstruct one of 190 people¡¯s neutral expression image using different number of PCs
% eigenvalues and eigenvectors of A'A
[v_with_noise, lam_with_noise] = eig(neutral_diff_with_noise' * neutral_diff_with_noise);
lam_with_noise = diag(lam_with_noise);

% best M eigenvectors of AA' 
u_with_noise = neutral_diff_with_noise * v_with_noise;

% normlize u
for i = 1:size(u_with_noise,2)
    u_with_noise(:,i) = u_with_noise(:,i) / norm(u_with_noise(:,i));
end

% sort eigenvalues and eigenvectors
[lam_sorted_with_noise, index_with_noise] = sort(lam, 'descend');
u_sorted_with_noise = u_with_noise(:,index_with_noise);

% reconstruction neutral image
components_list = 10:10:190;
img_number = 1;
figure
hold on
subplot(5,4,1)
imshow(reshape(neutral_190_with_noise(:,img_number),193,162),[]);
title('original img with noise')
i = 2;
for components = components_list    
    u_components = u_sorted_with_noise(:, 1:components);
    weights = u_components' * neutral_diff_with_noise(:,img_number);
    reconstruct_img = u_components * weights + neutral_average_with_noise;
    
    subplot(5,4,i)  
    imshow(reshape(reconstruct_img(:),193,162),[]);
    title(char(string(components) + string('PCs')))
    i = i + 1;
end