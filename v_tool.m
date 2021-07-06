function [] = v_tool(A, numberOfPerturbations, epsilon)
    
    % If one argument is given set default values to: numberOfPerturbations and epsilon 
    if(nargin == 1)
        numberOfPerturbations = 10000;
        epsilon = 0.1;
    end
    
    % If two arguments are given set default value to epsilon 
    if(nargin == 2)
        epsilon = 0.1;
    end
    
    % Take the current user and todays date 
    date = datetime('now');
    date = datestr(date);
    date = strrep(date, ':', '-');
    username = getenv('USERNAME');

    % Create directory in which the files will be saved
    directory = ['C:\Users\', username, '\Desktop\', date];
    mkdir(directory);
    
    x = [];
    n = size(A, 1);
    
    for iteration = 1 : numberOfPerturbations
        % Create a random NxN matrix in the specified epsilon range
        F = rand(n).*exp(2 * pi * 1i * rand(n));
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