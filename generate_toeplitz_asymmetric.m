function [toeplitzMatrix] = generate_toeplitz_asymmetric(blockSize, matrixSize)
    Q = cell(1, matrixSize * 2);
    
    warning('off');
    
    for i = 1 : matrixSize * 2
        F = rand(blockSize).*exp(2 * pi * 1i * rand(blockSize));
        
        Q{i} = F;
    end
    
    vC = 1 : length(Q) / 2;
    vR = length(Q) / 2 : length(Q) - 1;
    
    toeplitzMatrix = cell2mat(Q(toeplitz(vC, vR)));
end

