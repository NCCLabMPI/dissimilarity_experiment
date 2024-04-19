function[]= MDSPlot(coordinates,dataType)

config;

% load images for the plot 

Y = coordinates;

cd(faceImagesPath);
addpath(genpath(faceImagesPath));
faceImages = {'Face1Center.png','Face2Center.png','Face3Center.png','Face4Center.png','Face5Center.png','Face6Center.png' ...
            'Face7Center.png','Face8Center.png','Face9Center.png','Face10Center.png','Face11Center.png','Face12Center.png','Face13Center.png','Face14Center.png','Face15Center.png'...
            'Face16Center.png','Face17Center.png','Face18Center.png','Face19Center.png','Face20Center.png'};
cd(objectImagesPath)
addpath(genpath(faceImagesPath));
objectImages = {'Object1Center.png','Object2Center.png','Object3Center.png','Object4Center.png','Object5Center.png','Object6Center.png' ...
            'Object7Center.png','Object8Center.png','Object9Center.png','Object10Center.png','Object11Center.png','Object12Center.png','Object13Center.png','Object14Center.png','Object15Center.png'...
            'Object16Center.png','Object17Center.png','Object18Center.png','Object19Center.png','Object20Center.png'};

%specify stimulus Names 
stimulusNames = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'};

%plot images 

if strcmp(dataType,'Face')
    images = faceImages;
elseif strcmp(dataType,'Object')
    images = objectImages;
end

figure;
        xlabel('Distance')
        ylabel('Distance')
         
hold on
              
allImages = {};
for i = 1:numel(images)
currentImage = imread(images{i}); %read the images
allImages{i} = currentImage;
end


for j = 1: numel(allImages) %plot the images on the MDS coordinates

image('XData',[Y(j,1)-1 Y(j,1)+1],'YData',[Y(j,2)-1 Y(j,2)+1],'CData',flipud(cell2mat(allImages(j)))); %rescale and flip the images
text(Y(j,1),Y(j,2),stimulusNames{j},'EdgeColor','magenta','LineWidth',0.1)
hold off
end 
colormap gray %grayscale the image









