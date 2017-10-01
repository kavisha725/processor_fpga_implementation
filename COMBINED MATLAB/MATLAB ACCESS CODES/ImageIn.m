function ImageIn(image,image_bytefile)
Im = imread(image);
ImGr = rgb2gray(Im);
[h,w] = size(ImGr);
ImGr=transpose(ImGr);%check if needed.
OneD_Im = double(ImGr(:));
fileID = fopen(image_bytefile,'w');

%h1 =dec2bin(h,8);
%w1 =dec2bin(w,8);
h_bin = fliplr(de2bi(h));
h_bin = [zeros(1, max(0, 16 - numel(h_bin))), h_bin];
h_MSB1 = binaryVectorToDecimal(h_bin(1:8));
h_MSB2 = binaryVectorToDecimal(h_bin(9:16));

w_bin = fliplr(de2bi(w));
w_bin = [zeros(1, max(0, 16 - numel(w_bin))), w_bin];
w_MSB1 = binaryVectorToDecimal(w_bin(1:8));
w_MSB2 = binaryVectorToDecimal(w_bin(9:16));

fprintf(fileID,'%s \n',dec2bin(h_MSB1,8));
fprintf(fileID,'%s \n',dec2bin(h_MSB2,8));
fprintf(fileID,'%s \n',dec2bin(w_MSB1,8));
fprintf(fileID,'%s \n',dec2bin(w_MSB2,8));
for i = 1:h*w
    pixel = OneD_Im(i);
    fprintf(fileID,'%s \n',dec2bin(pixel,8));
end

fclose(fileID);
end