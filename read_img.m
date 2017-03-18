% read imgs
path = string('img/')
for i = 1:200   
    filepath_neutral = path + string(i) + string('a.jpg');
    filepath_smile = path + string(i) + string('b.jpg');
    neutral_img(:,:,i) = imread(char(filepath_neutral));
    smile_img(:,:,i) = imread(char(filepath_smile));
end

save neutral_img neutral_img
save smile_img smile_img
