%Do fisher Linear Discriminant to classify female and male faces 
%load female and male data
[training_fm,  testing_fm, ...
   mean_female_train, mean_female_test, mean_male_train, mean_male_test ] = load_female_male();
%do FDA on training face data to find the fisherface
[fisherface]= fisher_discriminant(training_fm, mean_female_train, mean_male_train);
%start classification
y_face_test = (fisherface'*testing_fm); % 90% accuracy!
%do FDA on training landmark data to find the fisherface for landmark
[training_fm_lm, testing_fm_lm, mean_female_train_lm, mean_male_train_lm] = load_female_male_landmarks();
[fisherface_lm]= fisher_discriminant(training_fm_lm, mean_female_train_lm, mean_male_train_lm);
y_lm_test = (fisherface_lm'*testing_fm_lm); % 85% accuracy!
%find mean of training faces
mean_lm_train = (mean_female_train_lm * 75 + mean_male_train_lm * 78)/153;
%warp training faces to mean landmark
training_fm_warped = warp_images(training_fm, training_fm_lm, mean_lm_train);
testing_fm_warped = warp_images(testing_fm, testing_fm_lm, mean_lm_train);
%pca to warped training face data
[evectors_fda, score_fda, evalues_fda] = pca(training_fm_warped');
%reconstruct training and testing faces
mean_fm_warped = mean(training_fm_warped,2);
e_10 = evectors_fda(:,1:10);
project = e_10'*(training_fm_warped - repmat(mean_fm_warped, 1, size(training_fm_warped,2)));
reconstructed_face_train_fda= e_10*project + repmat(mean_fm_warped, 1, size(training_fm_warped,2));
project = e_10'*(testing_fm_warped - repmat(mean_fm_warped, 1, size(testing_fm_warped,2)));
reconstructed_face_test_fda= e_10*project + repmat(mean_fm_warped, 1, size(testing_fm_warped,2));

%warp mean female training face and also reconstruct it
mean_female_train_warped = warp_images(mean_female_train, mean_female_train_lm, mean_lm_train);
project = e_10'*(mean_female_train_warped - mean_fm_warped);
reconstructed_female_face_test_fda= e_10*project + mean_fm_warped;
%warp mean male training face and also reconstruct it so that we can do fda
%later
mean_male_train_warped = warp_images(mean_male_train, mean_male_train_lm, mean_lm_train);
project = e_10'*(mean_male_train_warped - mean_fm_warped);
reconstructed_male_face_test_fda= e_10*project +mean_fm_warped;

%fda on warped training and compute fisherface
[fisherface_warped]= fisher_discriminant(reconstructed_face_train_fda,reconstructed_female_face_test_fda , reconstructed_male_face_test_fda);
%do classification 
y_face_test_warped =(fisherface_warped'* reconstructed_face_test_fda); % 90% accuracy

