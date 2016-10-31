function [training, testing,...
    mean_female_train, mean_female_test, mean_male_train, mean_male_test] = load_female_male(varargin)
female_files = dir('./female_face/*.bmp');
male_files = dir('./male_face/*.bmp');
test_num = 10;
for i = 1:(numel(female_files))
    img = double(imread(['./female_face/',female_files(i).name]));
    if numel(female_files) - i >= test_num
        training(:,i) = img(:); %75 female faces
    else 
        testing(:, test_num - (numel(female_files) - i)) = img(:);
    end
end
mean_female_train = mean(training,2);
mean_female_test = mean(testing,2);

train_female_size = size(training, 2);
test_female_size = size(testing, 2);
for i = 1:(numel(male_files))
    img = double(imread(['./male_face/',male_files(i).name]));
    if numel(male_files) - i >= test_num
        training(:,train_female_size + i) = img(:); %78 male faces
        training_male(:,i) = img(:);
    else 
        testing(:, test_female_size + test_num - (numel(male_files) - i)) = img(:);
        testing_male(:,i) = img(:);
    end
end
mean_male_train = mean(training_male,2);
mean_male_test = mean(testing_male,2);



