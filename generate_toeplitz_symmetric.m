function [toeplitzMatrix] = generate_toeplitz_symmetric(blockSize, matrixSize)
    Q = cell(1, matrixSize);
    
    for i = 1 : matrixSize       
        F = rand(blockSize).*exp(2 * pi * 1i * rand(blockSize));
        
        Q{i} = F;
    end
    
    toeplitzMatrix = cell2mat(Q(toeplitz(1 : length(Q))));
end

