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

%% Reconstruct one of 190 people��s neutral expression image using different number of PCs
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

%% Reconstruct one of 190 people��s smiling expression image using different number of PCs
% eigenvalues and eigenvectors of A'A
[v, lam] = eig(smile_diff' * smile_diff);
lam = diag(lam);

% best M eigenvectors of AA' 
u = smile_diff * v;

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

%% Reconstruct one of 190 people��s neutral expression image using different number of PCs
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
car_img = imread('car.jpg');
imcrop(I,[0 0 130 112]);
car_vector = reshape(car_img, 193*162, 1);
components_list = 10:10:190;
figure
hold on
subplot(5,4,1)
imshow(car_img,[]);
title('original img')
i = 2;
for components = components_list    
    u_components = u_sorted(:, 1:components);
    weights = u_components' * (double(car_vector) - neutral_average);
    reconstruct_img = u_components * weights + neutral_average;
    
    subplot(5,4,i)  
    imshow(reshape(reconstruct_img(:),193,162),[]);
    title(char(string(components) + string('PCs')))
    i = i + 1;
end