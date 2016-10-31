function [data, training, testing] = load_images(varargin)
files = dir('./face/*.bmp');
data = [];
for i = 1:(numel(files))
    img = double(imread(['./face/',files(i).name]));
    data(:,i) = img(:);
end
training = data(:,1:150);
testing = data(:,151:177);





