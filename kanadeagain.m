% load traffic_frames

m=328;
n=640;
Epsilon=0.025;
numFish=20;
% movie = ((movie-background)>Epsilon);
m=30;
 for m =1:4:5000
fr1 = movie(:, :, :, m);
fr2 = movie(:, :, :, m+5);
% figure();
% subplot 211
% imshow(fr1);
im1 = im2double(rgb2gray(fr1));
% subplot 212
% imshow(fr2);
im2 = im2double(rgb2gray(fr2));

ww = 40;
w = round(ww/2);

% Reduce the size of the image
sc = 1.5;
im2c = imresize(im2, 1/sc);
back = imresize(im2double(rgb2gray(background)),1/sc);
subtracted = ((im2c-back)>Epsilon);
CC = bwconncomp(subtracted);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = sort(numPixels);
for fishidx=1:numFish
        pixelI=CC.PixelIdxList{idx(end-fishidx+1)};
        %listCent(j,:,i)=CENT(j).Centroid;
        [xIdx, yIdx] = ind2sub([size(subtracted,1), size(subtracted,2)], pixelI);
        fish(fishidx,1,m) = min(xIdx);
        fish(fishidx,2,m) = min(yIdx);
        fish(fishidx,3,m) = max(xIdx);
        fish(fishidx,4,m) = max(yIdx);
end
fish=floor(fish*sc);
% figure()
% imshow(subtracted)
C1 = corner(subtracted);
C1 = C1*sc;

% Discard coners near the margin of the image
k = 1;
for i = 1:size(C1,1)
    x_i = C1(i, 2);
    y_i = C1(i, 1);
    if x_i-w>=1 && y_i-w>=1 && x_i+w<=size(im1,1)-1 && y_i+w<=size(im1,2)-1
      C(k,:) = C1(i,:);
      k = k+1;
    end
end
% Plot corners on the image
% figure();
% imshow(fr2);
% hold on
% plot(C(:,1), C(:,2), 'r*');

Ix_m = conv2(im1,[-1 1; -1 1], 'valid'); % partial on x
Iy_m = conv2(im1, [-1 -1; 1 1], 'valid'); % partial on y
It_m = conv2(im1, ones(2), 'valid') + conv2(im2, -ones(2), 'valid'); % partial on t
u = zeros(length(C),1);
v = zeros(length(C),1);

% within window ww * ww
for k = 1:length(C(:,2))
    i = floor(C(k,2));
    j = floor(C(k,1));
      Ix = Ix_m(i-w:i+w, j-w:j+w);
      Iy = Iy_m(i-w:i+w, j-w:j+w);
      It = It_m(i-w:i+w, j-w:j+w);

      Ix = Ix(:);
      Iy = Iy(:);
      b = -It(:); % get b here

      A = [Ix Iy]; % get A here
      nu = pinv(A)*b;

      u(k)=nu(1);
      v(k)=nu(2);
end;

%figure();
mag = u.^2 + v.^2;
u=u.*(mag > 0.5);
v=v.*(mag > 0.5);

fishArrow = cell(1,numFish);
avgvel=zeros(2,numFish);
cent=zeros(2,numFish);
for fishidx=1:numFish
    
    
    truth=C(:,1)>=fish(fishidx,2,m)& C(:,1)<=fish(fishidx,4,m) & C(:,2)>=fish(fishidx,1,m)& C(:,2)<=fish(fishidx,3,m);
    

    fishArrow{fishidx}=[u(truth & mag > 0.5), v(truth & mag > 0.5)];
    if ~isempty(fishArrow{fishidx})
       fr2=crossHairFish(fr2, fish(fishidx,:,m),[255, 255, 255]);
       avgvel(:,fishidx) = [mean(u(truth & mag > 0.5)), mean(v(truth & mag > 0.5))];
       cent(:,fishidx)=[(fish(fishidx,3,m)+fish(fishidx,1,m))/2, (fish(fishidx,4,m)+fish(fishidx,2,m))/2];

    end
end
% imshow(fr2);
% hold on;
       imshow(fr2);
       hold on;
       quiver(cent(2,:), cent(1,:), avgvel(1,:),avgvel(2,:), 1,'g');
 quiver(C(:,1), C(:,2), u,v, 1,'r');
pause(0.1)
end