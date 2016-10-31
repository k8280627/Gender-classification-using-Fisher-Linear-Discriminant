function [w, eigenface, V,y ,A ,z, lambda]= fisher_discriminant(data, mean_female, mean_male)
%example: data = training_fm_noMean
%       mean_female = mean_female_train
%       mean_male = mean_male_train
B = data'*data;
[V,lambda] = eig(B); %returns ascending eigenvalues, opposite to pca()
%define A
for i = 1:size(B,2)
    eigenface(:,i) = data * V(:,i);
    norm_fisher = norm(eigenface(:,i),2);
    lambda_i = lambda(i,i); 
    A(:,i) = lambda_i^0.5 * eigenface(:,i)/ norm_fisher;
end
%compute y
y = A' * ( mean_female - mean_male);
%compute z
matrix = lambda.^2 * V';
z = pinv(matrix)* y;
%finally compute w
w = data * z;
