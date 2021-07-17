function [] = unstructured_pseudospectra(matrixSize, numberOfPerturbations, epsilon, isDefault, retainMatrix)
    A = [];
    x = [];
    
    if(retainMatrix == 0)
        
        if(isDefault == 1)
            A = randi([0, 1000], [matrixSize, matrixSize]);
        else
            A = rand(matrixSize).*exp(2 * pi * 1i * rand(matrixSize));
        end
        
        save('matrixA.mat', 'A');
    else
        file = matfile('matrixA.mat');
        A = file.A;
        
        if(size(A, 1) ~= matrixSize)
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
    
    for iteration = 1 : numberOfPerturbations
        % Create a random NxN matrix in the specified epsilon range
        F = rand(matrixSize).*exp(2 * pi * 1i * rand(matrixSize));
        c = norm(F) / epsilon;
        E = F / c;
        
        % Calculate the eigenvalues of (A + E)
        eigenvalues = eig(A + E);
        eigenvalues = eigenvalues.';
        x = [x, eigenvalues];
    end
    
    % Plot the combined eigenvalues of the perturbations
    plot(real(x), imag(x), '.r');
    axis equal;   
    
    % Wait 1 second
    pause(1);
    
    % Save all of the data to a folder on the Desktop
    path = fullfile(directory, '\Perturbation_Plot.png');
    saveas(gcf, path);
    writematrix(A, [directory, '\Original_Matrix.txt'], 'Delimiter', 'tab');
end