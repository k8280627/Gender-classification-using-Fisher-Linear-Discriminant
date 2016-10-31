function tight_subplot_all(data, num_face_ver, num_face_hor, lm)
ha = tight_subplot( num_face_ver, num_face_hor ,[.01 .03],[.1 .01],[.01 .01]);
num_face= size(data,2);
for i= 1:num_face
    axes(ha(i));
    if lm == 0
        img = mat2gray(reshape(data(:,i),256,256));
        imshow(img);
    else
        draw_landmark(data(:,i));    
    end
end

