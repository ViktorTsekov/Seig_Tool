function [toeplitzMatrix] = generate_toeplitz_default_asymmetric(blockSize, matrixSize)
    Q = cell(1, matrixSize * 2);
    
    warning('off');
    count = 1;
    
    for i = 1 : matrixSize * 2
        row = [];
        
        for j = 1 : blockSize
            row = [row, count];      
            count = count + 1;
        end
        
        Q{i} = toeplitz(row); 
    end
    
    vC = 1 : length(Q) / 2;
    vR = length(Q) / 2 : length(Q) - 1;
    
    toeplitzMatrix = cell2mat(Q(toeplitz(vC, vR)));
end

