function write_mem(mem_sel,byte_array,COM,baud_rate)
    
    if strcmp(mem_sel,'program')
        mem_byte = 255;
    elseif strcmp(mem_sel,'input')
        mem_byte = 253;
    elseif strcmp(mem_sel,'output')
        mem_byte = 251;
    else
        mem_byte = 0;
    end
    
    if mem_byte ~= 0
        s = serial(COM,'BaudRate',baud_rate);   %com8 19200
        fopen(s);

        datalen = length(byte_array);

        data_bin = fliplr(de2bi(datalen));
        data_bin = [zeros(1, max(0, 24 - numel(data_bin))), data_bin]; 

        MSB1 = binaryVectorToDecimal(data_bin(1:8));
        MSB2 = binaryVectorToDecimal(data_bin(9:16));
        MSB3 = binaryVectorToDecimal(data_bin(17:24));

        seq = [mem_byte MSB1 MSB2 MSB3 byte_array];

        % writing
        for i = 1:1:length(seq)
            %display(seq(i));
            %while (~strcmp(s.TransferStatus, 'idle'))
            %end
            fwrite(s,seq(i),'uint8');
        end
        
        fclose(s);
        delete(s);
        clear s;
    end
end