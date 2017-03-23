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
figure 
x = 1:1:190
scatter(x, lam_sorted)
title('eigenvalues scatter')
xlabel('number of components')
ylabel('eigenvalues')


% plot top 9 eigenfaces
figure

hold on

subplot(3,3,1)
imshow(reshape(u_sorted(:, 1),193,162),[]);
subplot(3,3,2)
imshow(reshape(u_sorted(:, 2),193,162),[]);
subplot(3,3,3)
imshow(reshape(u_sorted(:, 3),193,162),[]);
subplot(3,3,4)
imshow(reshape(u_sorted(:, 4),193,162),[]);
subplot(3,3,5)
imshow(reshape(u_sorted(:, 5),193,162),[]);
subplot(3,3,6)
imshow(reshape(u_sorted(:, 6),193,162),[]);
subplot(3,3,7)
imshow(reshape(u_sorted(:, 7),193,162),[]);
subplot(3,3,8)
imshow(reshape(u_sorted(:, 8),193,162),[]);
subplot(3,3,9)
imshow(reshape(u_sorted(:, 9),193,162),[]);

