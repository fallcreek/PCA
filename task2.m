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

components_list = 10:10:190;
img_number = 1; % 37
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

phi_reconstruct = reconstruct_img - neutral_average;
phi_ori = neutral_diff(:,img_number);

norm(phi_reconstruct - phi_ori)^2