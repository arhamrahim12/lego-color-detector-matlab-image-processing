D = dir('MATLAB Drive/*.png');

score = [];

for ind = 1:length(D)
    filename = fullfile(D(ind).folder, D(ind).name);
    [folder, baseFileName, ~] = fileparts(filename);
    mat_filename = fullfile(folder, sprintf('%s.mat', baseFileName));

    if ~isfile(mat_filename) % check for .mat file
        warning('Missing .mat file for %s', filename);
        continue;
    end

    try
        res = findColours(filename); % run findColours on image
        mm = check_answer(res, mat_filename); % compare with solution
        score = [score, mm]; % store match percentage
    catch ME
        warning('Failed processing %s: %s', filename, ME.message);
    end
end

if isempty(score) % check if scores are available
    fprintf('No scores to report.\n');
else
    str = repmat('%.2f ', 1, length(score)); % format scores
    fprintf('Score is: '); % print score header
    fprintf(str, score); % display each score
    fprintf('\nMean score: %.2f\n', mean(score)); % show mean score
end
