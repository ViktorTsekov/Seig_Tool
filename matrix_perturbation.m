function [] = matrix_perturbation(A, numberOfPetrubations)
    % Take current user and todays date 
    date = datetime('now');
    date = datestr(date);
    date = strrep(date, ':', '-');
    username = getenv('USERNAME');

    % Create directory in which the files will be saved
    directory = ['C:\Users\', username, '\Desktop\', date];
    mkdir(directory);

    % Call seigtool
    seigtool(A)

    % Wait 1 second
    pause(1);

    % Take screen shot of the pseudospectra
    take_screen_capture;
    
    % Save the matrix and the image of the pseudospectra to a file
    writematrix(A, [directory, '\Original_Matrix.txt'], 'Delimiter', 'tab');
    imwrite(imgData, [directory, '\Pseudospectra.png']);

    currentPerturbation = 1;

    for i = 1 : numberOfPetrubations
        % Create the perturbed matrix
        currentPerturbation = currentPerturbation * (1 / 10);
        E = A + currentPerturbation;
        perturbedMatrix = A + E; 

        % Create a sub-directory into the main folder
        subDirectory = [directory, '\', sprintf('Perturbation-%d', i)];
        mkdir(subDirectory);

        % Get the eigenvalues of the matrix
        eigenvalues = eig(perturbedMatrix);

        % Call seigtool
        seigtool(perturbedMatrix);

        % Wait 1 second
        pause(1);

        % Take screen shot of the pseudospectra
        take_screen_capture;
        
        % Close the opened pseudospectra figure
        close all;

        % Save the matrix, the eigenvalues and the image of the pseudospectra to a file
        writematrix(perturbedMatrix, [subDirectory, '\Perturbed_Matrix.txt'], 'Delimiter', 'tab');
        writematrix(eigenvalues, [subDirectory, '\Eigenvalues.txt'], 'Delimiter', 'tab');
        imwrite(imgData, [subDirectory, '\Pseudospectra.png']);
    end
    
end