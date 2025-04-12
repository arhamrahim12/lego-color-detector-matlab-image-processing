function max_match = check_answer(answer, filename)
% Function to check the correctness of an answer against the expected solution.

arguments
    answer (4,4) cell  % validate 'answer'
    filename string    % validate 'filename'
end

load(filename, 'res'); % load solution

testMatFormat(answer) % check answer format

matches = cell(1, 8); % init matches array

res2 = res; % copy of res
for i = 1:4 % rotations
    matches{i} = cellfun(@strcmp, answer, res2); % check match
    res2 = rot90(res2); % rotate
end

res2 = fliplr(res); % flip res
for i = 5:8 % flipped rotations
    matches{i} = cellfun(@strcmp, answer, res2); % check match
    res2 = rot90(res2); % rotate
end

sum2 = @(x) sum(x, 'all'); % sum function

best_match = cellfun(sum2, matches) / 16 * 100; % calc match percentage

max_match = max(best_match); % find max match
end
