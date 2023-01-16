
function write2dev(file, BRAMX, COM)

    portStatus = exist('s', 'var');
    if ~portStatus
        s = serialport(COM, 115200);
    end
    
    switch BRAMX
        case 'BRAMA'
            bram = 1;
        case 'BRAMB' 
            bram = 2;
    end
    
    readFile =fopen(file, 'rt');
    C = textscan(readFile, '%d');
    C = cast(C{1}, "uint8");
    fclose(readFile);
    N = length(C) ;
    
    % se envía la BRAM escogida
    write(s, bram, "uint8")
    % se envía el largo del vector
    Nbin = dec2bin(N-1, 16);
    % primero LSB
    lsb= Nbin(9:end);
    LSB = bin2dec(lsb);
    write(s, LSB, "uint8");
    % luego MSB
    msb = Nbin(1:end/2);
    MSB = bin2dec(msb);
    write(s, MSB, "uint8");

    % se envía cada elemento del vector
    for i=1:N
        write(s, C(i), "uint8")
    end
end


% requisitos funcionales
% automatizar llenado de memorias
% enviandolos con un solo stream
% se asume archivos con máximo 1024 elementos y sin errores