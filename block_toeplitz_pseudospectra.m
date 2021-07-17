function [] = block_toeplitz_pseudospectra(blockSize, matrixSize, numberOfPerturbations, epsilon, isSymmetric, isDefault, retainMatrix, isHankel)    
    A = [];
    x = [];
    
    if(retainMatrix == 0)
        
        if(isDefault == 1)

           if(isSymmetric == 1)
                A = generate_toeplitz_default_symmetric(blockSize, matrixSize);
            else
                A = generate_toeplitz_default_asymmetric(blockSize, matrixSize);
           end

        else    

            if(isSymmetric == 1)
                A = generate_toeplitz_symmetric(blockSize, matrixSize);
            else
                A = generate_toeplitz_asymmetric(blockSize, matrixSize);
           end

        end
        
        if(isHankel == 1)
           A = fliplr(A); 
        end
        
        save('matrixA.mat', 'A');
    else
        file = matfile('matrixA.mat');
        A = file.A;
        
        if(size(A, 1) ~= blockSize * matrixSize)
            msgbox('Size Mismatch');
            return
        end
        
    end
    
    % Take the current user and todays date 
    date = datetime('now');
    date = datestr(date);
    date = strrep(date, ':', '-');
    username = getenv('USERNAME');

    % Create directory in which the files will be saved
    directory = ['C:\Users\', username, '\Desktop\', date];
    mkdir(directory);
    
    for i = 1 : numberOfPerturbations
        % Generate a random toeplitz matrix in the specified epsilon range
        F = [];
        
        if(isSymmetric == 1)
            F = generate_toeplitz_symmetric(blockSize, matrixSize);
        else
            F = generate_toeplitz_asymmetric(blockSize, matrixSize);
        end
        
        if(isHankel == 1)
           F = fliplr(F); 
        end
        
        c = norm(F) / epsilon;
        E = F / c;
        
        % Calculate the eigenvalues of (A + E)
        eigenvalues = eig(A + E);
        eigenvalues = eigenvalues.';
        x = [x, eigenvalues];
    end
    
    % Plot the combined eigenvalues of the perturbations
    plot(real(x), imag(x), '.');
    axis equal;

    % Wait 1 second
    pause(1); 
    
    % Save all of the data to a folder on the Desktop
    path = fullfile(directory, '\Perturbation_Plot.png');
    saveas(gcf, path);
    writematrix(A, [directory, '\Original_Matrix.txt'], 'Delimiter', 'tab');
end