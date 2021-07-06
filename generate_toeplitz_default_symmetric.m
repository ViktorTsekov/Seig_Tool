function [toeplitzMatrix] = generate_toeplitz_default_symmetric(blockSize, matrixSize)
    Q = cell(1, matrixSize);
    
    count = 1;
    
    for i = 1 : matrixSize
        row = [];
        
        for j = 1 : blockSize
            row = [row, count];      
            count = count + 1;
        end
        
        Q{i} = toeplitz(row); 
    end
    
    toeplitzMatrix = cell2mat(Q(toeplitz(1 : length(Q))));
end

