function y = command2dev(varargin)
    
    
    switch nargin
        case 2  % sin bram command2dev('command', COM_port); sin
             s = serialport(varargin{2}, 115200); 
            switch varargin{1}
                case 'sumVec'
                    command = 1;
                case 'avgVec'
                    command = 2;
                case 'eucDist'
                    command = 3;
                case 'manDist'
                    command = 4;
                otherwise
                    command = 0;
            end
        case 3  % con bram command2dev('readVec', 'BRAMA', COM_port);
            s = serialport(varargin{3}, 115200);
            switch varargin{1}
                case 'readVec'
                switch varargin{2}
                    case 'BRAMA'
                        command = 11;
                    case 'BRAMB'
                        command = 12;
                end
            end
    end     
                  
    write(s, 3 ,"uint8")
    write(s, command,"uint8")

    if command == 1 
        size_lsb  = read(s, 1, "uint8");
        sizeLSB   = dec2bin(size_lsb, 8);
        size_msb  = read(s, 1, "uint8");
        sizeMSB   = dec2bin(size_msb, 8);
        size = [sizeMSB sizeLSB];
        SIZE = (bin2dec(size) + 1);
        y = zeros(1, SIZE);
        for i=1:SIZE
            lsb_read = read(s, 1, "uint8");
            LSB_READ = dec2bin(lsb_read, 8);
            msb_read = read(s, 1, "uint8");
            MSB_READ = dec2bin(msb_read, 8);
            READ = [MSB_READ LSB_READ];
            y(1,i) = bin2dec(READ);
        end
        y = y';
        
    elseif command == 2
        size_lsb  = read(s, 1, "uint8");
        sizeLSB   = dec2bin(size_lsb, 8);
        size_msb  = read(s, 1, "uint8");
        sizeMSB   = dec2bin(size_msb, 8);
        size = [sizeMSB sizeLSB];
        SIZE = (bin2dec(size) + 1);
        y = zeros(1, SIZE);
        for i=1:SIZE
            lsb_read = read(s, 1, "uint8");
%             LSB_READ = dec2bin(lsb_read, 8);
%             msb_read = read(s, 1, "uint8");
%             MSB_READ = dec2bin(msb_read, 8);
%             READ = [MSB_READ LSB_READ];
            y(1,i) = lsb_read; %bin2dec(READ);
        end
        y = y';
        
    elseif command == 3 || command == 4
        s1=  read(s, 1, "uint8");
        S1 = dec2bin(s1, 8);
        s2 = read(s, 1, "uint8");
        S2 = dec2bin(s2, 8);
        s3 = read(s, 1, "uint8");
        S3 = dec2bin(s3, 8);
        s4 = read(s, 1, "uint8");
        S4 = dec2bin(s4, 8);
        S = [S4 S3 S2 S1];
        y = bin2dec(S);   
        
    elseif command == 11 || command == 12 
        size_lsb  = read(s, 1, "uint8");
        sizeLSB   = dec2bin(size_lsb, 8);
        size_msb  = read(s, 1, "uint8");
        sizeMSB   = dec2bin(size_msb, 8);

        size = [sizeMSB sizeLSB];
        SIZE = bin2dec(size) + 1

        rvOut = read(s, SIZE, "uint8");
        y = rvOut;
    end

end