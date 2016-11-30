Epsilon = 20;

% mn = min(min(min(min(movie))));
% mx = max(max(max(max(movie))));
% copymovie=movie;
% movie = uint8(floor(  (movie-mn)*255./(mx-mn) ));

background = uint8(median(movie(:,:,:,500:1000),4));
% frames = movie(:,:,:,I);





for i =1:5:2000
    mask = (movie(:,:,:,i)-background)>Epsilon;
    BW = mask(:,:,1);
    CC = bwconncomp(BW);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = sort(numPixels);
%     BW(CC.PixelIdxList{idx}) = 0;
%     onefish = findcomponent(mask);
%     twofish=[255*onefish movie(:,:,:,i)];
    im = ones(size(BW));
    for j =1:7
        im(CC.PixelIdxList{idx(length(biggest)-j)})=0;
    end
    twofish = [255*im movie(:,:,1,i)];
    imshow(twofish);
    pause(0.000001);
end


function fish = findcomponent(im)
    imageHeight = size(im,1);
    imageWidth = size(im,2);
    
    fish = zeros(size(im));
    for i = 4:imageHeight-3
        for j = 4:imageWidth-3
            patch = im(i-3:i+3,j-3:j+3,:);
            if sum(sum(sum(patch)))>30 %TODO:see if there is an objective way to choose this value
                fish(i,j,:)=1;
            end
        end
    end
end