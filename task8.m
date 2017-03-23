load neutral_img
load smile_img

% reshape 193*162 matrix to vector
neutral = reshape(neutral_img, 193*162, 200);
smile = reshape(smile_img, 193*162, 200);

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