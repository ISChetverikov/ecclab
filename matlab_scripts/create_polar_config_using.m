function create_polar_config_using()
    crc = "11001111";
    k = 512;
    m = 10;
    sequence_filename = "polar_seq_1024.txt";
    
    create_polar_config(m, k, crc, sequence_filename, "..\\work\\codes\\polar")
end

