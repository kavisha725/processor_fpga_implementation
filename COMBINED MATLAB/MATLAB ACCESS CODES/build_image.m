function build_image(byte_arr,image, output_image_bytefile,output_image)
    %save('output_img.txt','byte_arr');
    fileID = fopen(output_image_bytefile,'w');
    
    for i=1:1:length(byte_arr)
        fprintf(fileID,'%u \n',byte_arr(i));
    end
    fclose(fileID);
    
    Im=imread(image);
    ImGr = rgb2gray(Im);
    [input_h,input_w] = size(ImGr);
    
    h = floor(input_h/2);
    w = floor(input_w/2);
    
    img = reshape(byte_arr,w,h);
    %img = reshape(byte_arr,128,128);
    img = (img')/255;
    
    imwrite(img,output_image);
    figure
    imshow(img);
end