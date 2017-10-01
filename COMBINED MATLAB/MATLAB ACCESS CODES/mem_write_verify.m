function verified = mem_write_verify(mem_sel,byte_array,COM,baud_rate)
    write_mem(mem_sel,byte_array,COM,baud_rate);
    read_array = read_mem(mem_sel,COM,baud_rate);
    
    if (isequal(byte_array,read_array))
        verified = 1;
    else
        verified = 0;
    end
end