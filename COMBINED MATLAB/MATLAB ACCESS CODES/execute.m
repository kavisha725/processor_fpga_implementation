function execute(COM,baud_rate)

s = serial(COM,'BaudRate',baud_rate);
fopen(s);

fwrite(s,240,'uint8');
tic
display('Executing');

while(~s.BytesAvailable)    % wait for end byte to come
end
toc

byte_end = fread(s,1,'uint8');

if( byte_end == 239)
    display('Executed');
else
    display('ERROR');
end

fclose(s);
delete(s);
clear s;
end