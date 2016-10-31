clear all;
close all;
%load landmarks & images
[data_lm, training_lm, testing_lm] = load_landmarks();
[data , training, testing ] = load_images();
%do PCA on training data
[evectors, score, evalues] = pca(training');
width = 256;
height = 256;
num_eface = 20;
%get first 20 eigenvectors
evectors20 = evectors(:,1:num_eface);
mean_face_train = mean(training,2);
%plot
ha = tight_subplot(4,5,[.01 .03],[.1 .01],[.01 .01]);
for i= 1:num_eface
    axes(ha(i));
    img = mat2gray(reshape(evectors20(:,i),width,height));
    imshow(img);
    %%save first 20 eigenfaces
    %filename = sprintf('e%d.bmp',i);
    %f = fullfile('./face/eigenface_20/',filename);
    %imwrite(img, f);
end
%reconstruct test images by eigenvectors and calculate reconstruction error
mean_face_test = mean(testing,2);
for i = 1:size(evectors,2)
    total_construction_error= 0;
    for j = 1:size(testing,2)
        test_face = testing(:,j);
        e_i = evectors(:,1:i);
        project = e_i'*(test_face - mean_face_train);
        reconstruction_face = e_i*project + mean_face_train;
        total_construction_error = total_construction_error + sum((reconstruction_face - test_face).^2)/length(test_face);
    end
    total_face_construction_error(i) = total_construction_error/27;
    %disp(total_construction_error/27);
end
% do the same on the landmarks(warp)
num_warp = 5;
mean_warp_train = mean(training_lm,2);
[eigenwarp, eigenwarp_score, eigenwarp_value] = pca(training_lm');
eigenwarp5 = eigenwarp(:,1:num_warp);
%add mean to eigenwarp5
eigenwarp5_plus_mean = repmat(mean_warp_train,1,num_warp) + eigenwarp5;
%plot eigenwarp5_plus_mean
for i = 1:size(eigenwarp,2)
    total_warp_construction_error_j = 0
    for j = 1:size(testing_lm,2)
        test_warp = testing_lm(:,j);
        e_i = eigenwarp(:,1:i);
        project = e_i'*(test_warp - mean_warp_train);
        reconstruction = e_i*project + mean_warp_train;
        for k = 1:size(test_warp,1)/2
            x_square = (reconstruction(2*k-1,1) - test_warp(2*k-1,1)).^2;
            y_square = (reconstruction(2*k,1) - test_warp(2*k,1)).^2;
            total_warp_construction_error_j = total_warp_construction_error_j +  ((x_square + y_square)^0.5)/87; %/length(test_warp);
        end
    end
    total_warp_construction_error(i) = total_warp_construction_error_j/27; %/length(test_warp);
end


%warp training images to mean
[training_warped] = warp_images( training ,training_lm ,mean_warp_train );
%do pca on warped_training
[evectors_warped, score_warped, evalues_warped] = pca(training_warped');
%project testing_lm to top 10 eigenwarping of training
eigenwarp_10 = eigenwarp(:,1:10);
project = eigenwarp_10'*(testing_lm - repmat(mean_warp_test, 1, size(testing_lm,2)));
reconstructed_warp_test= eigenwarp_10*project + repmat(mean_warp_test, 1, size(testing_lm,2));

%warp testing faces to mean lm of training
[testing_warped] = warp_images( testing , testing_lm ,mean_warp_train );
%project testing_warped to k eigenfaces of training
for k=1: size(evectors_warped,2)
    e_k = evectors_warped(:,1:k);
    project = e_k'*(testing_warped - repmat(mean_face_train, 1, size(testing_warped,2)));
    reconstructed_face_test= e_k*project + repmat(mean_face_train, 1, size(testing_warped,2));
    %now its lm is at mean of training lm, so we need to warp to reconstructed warped test lm
    [reconstructed_face_test_warpback] = warp_images( reconstructed_face_test , ...
    repmat(mean_warp_train, 1 , size(reconstructed_face_test,2)) , reconstructed_warp_test);
    total_testing_reconstructed_error(k) = sum( sum((testing - reconstructed_face_test_warpback).^2,1)/size(testing,2),2)/256^2;
    disp(total_testing_reconstructed_error(k));
end 
% for i = 1:size(evectors_warped,2)
%     for j = 1:size(testing_warped,2)
%         test_face = testing_warped(:,j);
%         e_i = evectors_warped(:,1:i);
%         project = e_i'*(test_face - mean_face_train);
%         reconstructed_face_test(:,j) = e_i*project + mean_face_train;
%         %total_construction_error = total_construction_error + sum((reconstruction - test_face).^2)/length(test_face);
%     end 
%     [reconstructed_face_test_warpback] = warp_images( reconstructed_face_test , ...
%     repmat(mean_warp_train, 1 , size(reconstructed_face_test,2)) , reconstructed_warp_test);
%     total_testing_reconstructed_error(i) = sum( sum((testing - reconstructed_face_test_warpback).^2,1)/size(testing_warped,2),2)/256^2;
%     %disp(total_testing_reconstructed_error(i));
% end

%synthesize 20 random faces
for i = 1:20
    warp_random = randn(1,10);
    face_random = randn(1,10);
    new_warp = mean_warp_train + sum(eigenwarp_10_weighted.*repmat(warp_random, size(eigenwarp,1), 1),2);
    new_face = mean_face_train + sum(evectors_warped_10_weighted.*repmat(face_random, size(evectors_warped,1), 1),2);
    new_face_warped(:,i) = warp_images(new_face, mean_warp_train ,new_warp); %from where to warp ??
    %save random faces
    img = mat2gray(reshape(new_face_warped(:,i),width,height));
    %filename = sprintf('random_face%d.bmp',i);
    %f = fullfile('./face/random_face_20/',filename);
    %imwrite(img, f);
end