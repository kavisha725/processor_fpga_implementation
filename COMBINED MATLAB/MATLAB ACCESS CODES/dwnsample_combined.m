clear all;
close all;

%%%
COM_port = 'COM5';
baud_rate = 115200;

input_image = 'starbucks.jpg';
program_bytefile = 'down_sample_512x512.byt';        %program file
input_image_bytefile = 'star.txt';  %define file names
output_image_bytefile = 'star_out.txt';
output_image = 'star_ds.png';       %define output image name
%%%

program(program_bytefile, COM_port, baud_rate);
ImageIn(input_image, input_image_bytefile);
load_image(input_image_bytefile, COM_port, baud_rate);
execute(COM_port,baud_rate);
x = read_mem('read', COM_port, baud_rate);
build_image(x(1:end-1), input_image, output_image_bytefile, output_image);
ssd_img_final = Gauss_dwnSmpl3_while(input_image, output_image_bytefile);