function ssd_array = Gauss_dwnSmpl3_while(image,output_image_bytefile)% 
% NOT in assembly
Im=imread(image);
ImGr = rgb2gray(Im);

% registers RH and RW loaded by two specific memory locations in RAM
% loaded by UART
[h,w] = size(ImGr);

% NOT in assembly
figure
imshow(ImGr); 
ImGr=transpose(ImGr);

% input flat image RAM
OneD_Im = double(ImGr(:));

% output flat image RAM
temp_Im = zeros(floor(h/2)*floor(w/2),1);
% RAM address pointer for output image (register)ARK
k = 0;


Conv_sum=double(0); % NOT in assembly

% hard coded in assembly
ker_centre = 4;%4
ker_middle = 2;%2
ker_corner = 1;%1
ker_sum = ker_corner*4 + ker_middle*4 + ker_centre;
%%%%%%%%%%%%%%

% register RJ
j = 0;
% register RX           sampling pointer
x = 0;  
while j <= h - 2    % for do-while -2 not needed
    j = j+2;    
    x = x + w;          % increment row
    
    % register RI
    i = 0;
    while i <= w - 2      % for do-while -2 not needed
        i = i + 2;
        x = x + 2;      % increment 2:1 coloumn
            
        % register RS
        Conv_sum = 0;
        
        %following must be in this order grays and yellows
        Conv_sum = Conv_sum + (OneD_Im(x)*ker_centre);
        x = x - w;
        Conv_sum = Conv_sum + (OneD_Im(x)*ker_middle);
        x = x - 1;
        Conv_sum = Conv_sum + (OneD_Im(x)*ker_corner);
        x = x + w;
        Conv_sum = Conv_sum + (OneD_Im(x)*ker_middle);  %x-1

        if (h-j)~=0
            x = x + w;
            Conv_sum = Conv_sum + (OneD_Im(x)*ker_corner);
            x = x + 1;
            Conv_sum = Conv_sum + (OneD_Im(x)*ker_middle); %x+w
        else
            x = x + 1;
            x = x + w;
        end

        if (w-i)~=0
            x = x + 1;
            if (h-j)~=0
                Conv_sum = Conv_sum + (OneD_Im(x)*ker_corner);%x+w+1
                x = x - w;
            else
                x = x - w;
                %Conv_sum = Conv_sum + (OneD_Im(x)*ker_corner);%x+1
            end     %x+1
            Conv_sum = Conv_sum + (OneD_Im(x)*ker_middle);
            x = x - w;
            Conv_sum = Conv_sum + (OneD_Im(x)*ker_corner); %x-w+1
            
            x = x + w;
            x = x - 1;
        else
            x = x - w;
        end
        
        
        
        Conv_sum = floor(Conv_sum/(ker_sum));
        k = k + 1;
        temp_Im(k) = Conv_sum;
        
        
        
    end
    %if w is odd add 1 for i incremnts to equal to w ADDRXAC
    if w - i ~= 0
        x = x + 1;
    end
end

fil_ds_Im = uint8(temp_Im); 

%filename = 'output_img4.txt'; % PROGRAM FILE
filename = output_image_bytefile;

delimiterIn = '\n';
%headerlinesIn = 1;
img_array = uint8(importdata(filename,delimiterIn));
cpu_img = reshape(img_array,[floor(w/2),floor(h/2)]);
figure
imshow(cpu_img');
title('down sampled- CPU');

ssd = fil_ds_Im - img_array;
ssd_img = reshape(ssd,[floor(w/2),floor(h/2)]);
ssd = ssd .* ssd;
ssd_tot = sum(ssd);

display(ssd_tot);

result = reshape(fil_ds_Im,[floor(w/2),floor(h/2)]); 
figure
imshow(result');
title('down sampled- MATLAB');
ssd_array = ssd_img;
figure
imshow(ssd_img);
title('ssd');
end
