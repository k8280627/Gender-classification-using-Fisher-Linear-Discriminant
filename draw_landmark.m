function draw_landmark(landmark, mean_female_lm, mean_male_lm)
size_lm = size(landmark,1);
if exist('mean_female_lm','var') && exist('mean_male_lm','var')
    landmark = landmark + mean_female_lm + mean_male_lm;
end
for i = 1:size_lm/2
    x(i) = landmark(2*i-1,1);
    y(i) = landmark(2*i,1);
    
end
plot(x,y,'ro');
set(gca,'YDir', 'reverse');
    