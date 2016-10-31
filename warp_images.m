function [data_warped] = warp_images( data ,data_lm ,desired_lm )
%data = 256*256xN matrix
%turn each image in data to 256x256 matrix
%turn each lm in data_lm into cell array of 1x2 matrix
%return a 256*256xN matrix
if size(desired_lm,2) ~= size(data,2)
    desired_lm = repmat(desired_lm,1, size(data,2));
end
for i= 1:size(data,2)
    %loop thru each image
    lm = cell(1,2);
    width = size(data,1)^0.5;
    img = data(:,i);
    img_reshaped = reshape(img, width , width);
    img_lm = data_lm(:,i);
    for j= 1:size(img_lm,1)
        %loop thru each lm
       if mod(j,2) == 0
            img_lm_reshaped( ceil(j/2) , 2 ) =  img_lm(j,1);
            desired_lm_reshaped( ceil(j/2) , 2 ) =  desired_lm(j,i);                 
       else if mod(j,2) == 1
           img_lm_reshaped( ceil(j/2) , 1 ) =  img_lm(j,1);
           desired_lm_reshaped( ceil(j/2) , 1 ) =  desired_lm(j,i);
           end
       end
    end
    img_warp = warpImage_kent(img_reshaped, img_lm_reshaped, desired_lm_reshaped);
    img_warp_reshaped = reshape(img_warp, width*width, 1);
    data_warped(:,i) = double(img_warp_reshaped);
end



