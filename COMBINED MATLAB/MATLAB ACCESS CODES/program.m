function program(filename,COM,baud_rate)
%filename = 'addsum.byt'; % PROGRAM FILE

delimiterIn = '\n';
%headerlinesIn = 1;
ins_array = importdata(filename,delimiterIn);
ins_array = bin2dec(num2str(ins_array));

ins_array = ins_array'; % flatten to 1 row

display('Programming....');
tic
v = mem_write_verify('program',ins_array,COM,baud_rate);
toc

if v
    display('Program Success');
else
    display('Program FAILED');
end