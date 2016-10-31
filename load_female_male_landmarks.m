function [training_lm, testing_lm, mean_train_female_lm, mean_train_male_lm] = load_female_male_landmarks(varargin)
f_files = dir('./female_landmark_87/*.txt');
m_files = dir('./male_landmark_87/*.txt');
f_num = numel(f_files);
m_num = numel(m_files);
female_train_lm = [];
female_test_lm = [];
male_train_lm = [];
male_test_lm =[];
for i = 1:f_num
    f = fullfile('./female_landmark_87/',f_files(i).name);
    fid = fopen(f);
    datacell = textscan(fid,'%f %f');
    fclose(fid);
    a = 1;
    for a = 1 : 87
        if f_num - i >= 10
            female_train_lm(2*a-1,i) = datacell{1,1}(a);
            female_train_lm(2*a,i) = datacell{1,2}(a);
        else 
            %disp(numel(f_files));
            female_test_lm(2*a-1,10-f_num+i) = datacell{1,1}(a);
            female_test_lm(2*a,10-f_num+i) = datacell{1,2}(a);
        end
    end
end
for i = 1:m_num
    f = fullfile('./male_landmark_87/',m_files(i).name);
    fid = fopen(f);
    datacell = textscan(fid,'%f %f');
    fclose(fid);
    a = 1;
    for a = 1 : 87
        if m_num - i >= 10
            male_train_lm(2*a-1,i) = datacell{1,1}(a);
            male_train_lm(2*a,i) = datacell{1,2}(a);
        else 
            male_test_lm(2*a-1,10-m_num +i) = datacell{1,1}(a);
            male_test_lm(2*a,10-m_num +i) = datacell{1,2}(a);
        end
    end
end
training_lm = horzcat(female_train_lm, male_train_lm);
testing_lm = horzcat(female_test_lm, male_test_lm);
mean_train_female_lm = mean(female_train_lm,2);
mean_train_male_lm = mean(male_train_lm,2);


