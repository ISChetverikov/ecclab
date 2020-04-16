function create_polar_config(m, k, crc_vector, sequence_filename, output_directory)
    if nargin < 5
        output_directory = '';
    end
    
    output_filename = sprintf('polar%d_ca%d_CF_k%d.txt', m, strlength(crc_vector), k);
    output_path = fullfile(output_directory, output_filename);
    output_path = replace(output_path, "\", "\\");
    sequence_filename = replace(sequence_filename, "\", "\\");
    
    if isfile(output_path)
        exception = MException("Matlab:FILE_EXISTS", sprintf("File %s already exists.", output_path));
        throw(exception)
    end
    
    if ~isfile(sequence_filename)
        exception = MException("Matlab:FILE_DOES_NOT_EXIST", "File " + sequence_filename + " does not exist.");
        throw(exception)
    end
    
    file_input_ID = fopen(sequence_filename, 'r');
    if (file_input_ID == -1)
        exception = MException("Matlab:CANNOT_OPEN_FILE", "Cannot open file " + sequence_filename + " for reading.");
        throw(exception)
    end
    sequence = fscanf(file_input_ID, '%d');
    if (size(sequence)~=2^m)
        exception = MException("POLAR:SEQ_LENGTH_M_COLLISION",...
            "Length of sequence " + size(sequence)...
            + " is not equal to 2^" + m + ".");
        throw(exception)
    end
    sequence_k = sequence(end-k+1:end);
    bit_mask = zeros(size(sequence));
    for index = sequence_k
        bit_mask(index + 1) = 1;
    end
    fclose(file_input_ID);
    
    fprintf("%s\n", output_path);
    file_output_ID = fopen(output_path, 'w');
    if (file_output_ID == -1)
        exception = MException("Matlab:CANNOT_OPEN_FILE", "Cannot open file " + output_path + " for writing.");
        throw(exception)
    end
    
    comment = "%% " + sprintf("code_name ""CA-Polar m = %d, crc%d, k = %d""\n\n",...
        m, strlength(crc_vector), k);
    fprintf(file_output_ID, comment);
    fprintf(file_output_ID, sprintf("c_m %d\n\n", m));
    fprintf(file_output_ID, "info_bits_mask " + sprintf("%d", bit_mask) + "\n\n");
    fprintf(file_output_ID, "ca_polar_crc " + crc_vector + "\n\n");
    fclose(file_output_ID);
end