function mem_out = read_mem(mem_sel,COM,baud_rate)
    if strcmp(mem_sel,'program')
        mem_byte = 254;
    elseif strcmp(mem_sel,'input')
        mem_byte = 252;
    elseif strcmp(mem_sel,'output')
        mem_byte = 250;
    elseif strcmp(mem_sel,'read')
        mem_byte = 249;
    else
        mem_byte = 0;
    end
    
    if mem_byte ~= 0
        s = serial(COM,'BaudRate',baud_rate); %com8
        s.InputBufferSize = 270000;%8192; % increase buffer size if neccessary
        fopen(s);

        fwrite(s,mem_byte,'uint8');
        dataout = [];
        
        while(~s.BytesAvailable)    % wait for first byte to come
        end
        %pause(0.01);
        
        i = 0;
        while(s.BytesAvailable)
            i = i + 1;
            %display(i);
            dataout = [dataout fread(s,1,'uint8')];
        end
        
        fclose(s);
        delete(s);
        clear s;
        
        mem_out = dataout;
    end
end