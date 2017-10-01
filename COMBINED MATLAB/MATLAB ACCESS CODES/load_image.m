function load_image(filename,COM, baud_rate)

%filename = 'ByteIMG4.txt'; % PROGRAM FILE

delimiterIn = '\n';
%headerlinesIn = 1;
img_array = importdata(filename,delimiterIn);
img_array = bin2dec(num2str(img_array));

img_array = img_array'; % flatten to 1 row

display('Loading....');
tic
v = mem_write_verify('input',img_array,COM, baud_rate);
toc

if v
    display('Loading Success');
else
    display('Loading FAILED');
end