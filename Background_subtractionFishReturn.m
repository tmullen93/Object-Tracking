function [fish]= Background_subtractionFishReturn(movie,background,speedLight,numFish)


Epsilon = 10;

% mn = min(min(min(min(movie))));
% mx = max(max(max(max(movie))));
% copymovie=movie;
% movie = uint8(floor(  (movie-mn)*255./(mx-mn) ));

%background = uint8(mean(movie(:,:,:,1:1000),4));
% frames = movie(:,:,:,I);



height=size(movie,1);
width=size(movie,2);
numFrame = size(movie,4);
%numFish=5;
%speedLight=12;
fish=-99*ones(numFish,7,numFrame);
fullComp=cell(numFrame,1);
%backGroundLarge=zeros(height,width,3,speedLight);
for i =speedLight:numFrame
    for j=1:speedLight
        backGroundLarge(:,:,:,j)=background;
    end
    
    
    mask = (movie(:,:,:,i-speedLight+1:i)-backGroundLarge)>Epsilon;
    sumMask=sum(mask,4)==speedLight;
    mask2= sum(sumMask,3)>=1;
    CC = bwconncomp(mask2);
    %z=zeros(height,width);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [~,idx] = sort(numPixels);%%%add threshold on size in general delete if number of pixels is lower than threshold even if in top 10
    %movieUpdate=movie(:,:,:,i);
    %CENT=regionprops(CC,'Centroid');
    fullComp(i)={CC};
    loopend=min(length(idx),numFish);
    
    for j=1:loopend
        
        pixelI=CC.PixelIdxList{idx(end-j+1)};
        %listCent(j,:,i)=CENT(j).Centroid;
        [xIdx, yIdx] = ind2sub([height, width], pixelI);
        fish(j,1,i) = min(xIdx);
        fish(j,2,i) = min(yIdx);
        fish(j,3,i) = max(xIdx);
        fish(j,4,i) = max(yIdx);
        fish(j,5,i)=floor((fish(j,1,i)+fish(j,3,i))/2);
        fish(j,6,i)=floor((fish(j,2,i)+fish(j,4,i))/2);
        fish(j,7,i)=0;
        %         box=BB(j).BoundingBox;
        %         hold on
        %         rectangle('Position',box,'EdgeColor','g','LineWidth', 3)
        %         hold off
        %z(CC.PixelIdxList{idx(end-j+1)})=1;
        
        %movieUpdate=crossHair(CC.PixelIdxList{idx(end-j+1)},movieUpdate);
        
    end
    
    
    
    
    %     mask3(:,:,1)=z;
    %     mask3(:,:,2)=z;
    %     mask3(:,:,3)=z;
    %     onefish = findcomponent(mask);
    
    %twofish=[ movieUpdate];%255*mask3 background];
    %imshow(twofish);
    %pause(.000001)
end
end
% function [im] =  crossHair(pixelI,im)
% [xIdx, yIdx] = ind2sub([size(im,1), size(im,2)], pixelI);
% min_x = min(xIdx);
% min_y = min(yIdx);
% max_x = max(xIdx);
% max_y = max(yIdx);
% 
% %min_y
% im(min_x:max_x, min_y:min_y+3, 1, :)=0;
% im(min_x:max_x, min_y:min_y+3, 2, :)=255;
% im(min_x:max_x, min_y:min_y+3, 3, :)=0;
% 
% %max_y
% im(min_x:max_x, max_y-3:max_y, 1, :)=0;
% im(min_x:max_x, max_y-3:max_y, 2, :)=255;
% im(min_x:max_x, max_y-3:max_y, 3, :)=0;
% 
% %min_x
% im(min_x:min_x+3, min_y:max_y, 1, :)=0;
% im(min_x:min_x+3, min_y:max_y, 2, :)=255;
% im(min_x:min_x+3, min_y:max_y, 3, :)=0;
% 
% %max_x
% im(max_x-3:max_x, min_y:max_y, 1, :)=0;
% im(max_x-3:max_x, min_y:max_y, 2, :)=255;
% im(max_x-3:max_x, min_y:max_y, 3, :)=0;
% end

% function fish = findcomponent(im)
%     imageHeight = size(im,1);
%     imageWidth = size(im,2);
%
%     fish = zeros(size(im));
%     for i = 4:imageHeight-3
%         for j = 4:imageWidth-3
%             patch = im(i-3:i+3,j-3:j+3,:);
%             if sum(sum(sum(patch)))>69 %TODO:see if there is an objective way to choose this value
%                 fish(i,j,:)=1;
%             end
%         end
%     end
% end