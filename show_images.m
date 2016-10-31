w = 1;
imshow(mat2gray(reshape(testing(:,w),256,256)));
figure
imshow(mat2gray(reshape(reconstructed_face_test_warpback(:,w),256,256)));