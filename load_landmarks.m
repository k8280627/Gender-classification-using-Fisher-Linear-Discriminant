function [data_lm, training_lm, testing_lm] = load_landmarks(varargin)
files = dir('./landmark_87/*.dat');
data_lm = [];
for i = 1:(numel(files))
    f = fullfile('./landmark_87/',files(i).name);
    fid = fopen(f);
    datacell = textscan(fid,'%f %f', 'HeaderLines', 1);
    fclose(fid);
    a = 1;
    for a = 1 : 87
        data_lm(2*a-1,i) = datacell{1,1}(a);
        data_lm(2*a,i) = datacell{1,2}(a);
    end
end
training_lm = data_lm(:,1:150);
testing_lm = data_lm(:,151:177);
