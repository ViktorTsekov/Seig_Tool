function [] = sv_tool(blockSize, matrixSize, numberOfPerturbations, epsilon, isSymmetric, matrixA)
    %% sv_tool aims to inspect the properties of block toeplitz matrices by generating a number of perturbations of matrix A and ploting their eigenvalues on a 2D plot
    
    A = [];
    x = [];
    
    % If two arguments are given set default values to:
    % numberOfPerturbations, epsilon, isSymmetric
    if(nargin == 2)
        numberOfPerturbations = 10000;
        epsilon = 0.1;
        isSymmetric = 0;
    end
    
    % If three arguments are given set default values to:
    % epsilon, isSymmetric
    if(nargin == 3)
        epsilon = 0.1;
        isSymmetric = 0;
    end
    
    % If four arguments are given set default value to:
    % isSymmetric
    if(nargin == 4)
        isSymmetric = 0;
    end
    
    % Check if a matrix is given by the user and if it is not generate a
    % default one
    if nargin == 6
        
        %If a matrix is specified check if it is of the correct size
        if(size(matrixA, 1) ~= blockSize * matrixSize)
            error('Size mismatch');
        end
        
        A = matrixA;      

    else
        
        if(isSymmetric == 1)
            A = generate_toeplitz_default_symmetric(blockSize, matrixSize);
        else
            A = generate_toeplitz_default_asymmetric(blockSize, matrixSize);
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
    
    % Take screenshot of the plot
    image = capture_screen(610, 30, 700, 600); % [left top width height]
    
    % Save all of the data to a folder on the Desktop
    imwrite(image, [directory, '\Perturbation_Plot.png']);
    writematrix(A, [directory, '\Original_Matrix.txt'], 'Delimiter', 'tab');
    writematrix(epsilon, [directory, '\Epsilon.txt'], 'Delimiter', 'tab');
    writematrix(numberOfPerturbations, [directory, '\Number_of_Perturbations.txt'], 'Delimiter', 'tab');
end