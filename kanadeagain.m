% load traffic_frames
% load('smallmoviegray.mat')
% load('movie.mat')
% fish: xmin ymin xmax ymax xcenter ycenter xvel yvel colorlabel(#)
clear trueFishFrame
background=imread('newbackground.png');
sc=1.5;
back = imresize(im2double(rgb2gray(background)),1/sc);
speedLight=12;

backGroundLarge=zeros(size(back,1),size(back,2),speedLight);
for j=1:speedLight
    %         fr2 = movie(:, :, :, j);
    %         im2 = im2double(rgb2gray(fr2));
    %         im2c(:,:,j) = imresize(im2, 1/sc);
    backGroundLarge(:,:,j)=back;
end
m=328;
n=640;
Epsilon=0.025;
numFish=20;
% movie = ((movie-background)>Epsilon);
m=17;
lengthmovie=300;
trueFish=cell(1,lengthmovie);
bigFish=5;

for m =speedLight+1:4:lengthmovie
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
    %smallmovie = im2c(:,:,m-speedLight+1:m);
    mask = (smallmovie(:,:,m+5-speedLight+1:m+5)-backGroundLarge)>Epsilon;
    subtracted=sum(mask,3)==speedLight;
    % subtracted= sum(sumMask,3)>=1;
    %subtracted = ((im2c-back)>Epsilon);
    
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
        fish(fishidx,5,m) = (min(xIdx)+max(xIdx))/2;
        fish(fishidx,6,m) = (min(yIdx)+max(yIdx))/2;
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
    truth=zeros(size(C,1),numFish);
    count=1;
    
    
    
    for fishidx=1:numFish
        
        
        truth(:,fishidx)=C(:,1)>=fish(fishidx,2,m)& C(:,1)<=fish(fishidx,4,m) & C(:,2)>=fish(fishidx,1,m)& C(:,2)<=fish(fishidx,3,m);
        
        
        fishArrow{fishidx}=[u(truth(:,fishidx) & mag > 0.5), v(truth(:,fishidx) & mag > 0.5)];
        if ~isempty(fishArrow{fishidx})
            
            %fr2=crossHairFish(fr2, fish(fishidx,:,m),[255, 255, 255]);
            avgvel(:,fishidx) = [mean(u(truth(:,fishidx) & mag > 0.5)), mean(v(truth(:,fishidx) & mag > 0.5))];
            cent(:,fishidx)=[(fish(fishidx,3,m)+fish(fishidx,1,m))/2, (fish(fishidx,4,m)+fish(fishidx,2,m))/2];
            trueFishFrame(count,1:8)=[fish(fishidx,:,m),avgvel(:,fishidx)'];
            count=count+1;
        elseif fishidx<=bigFish
            %fr2=crossHairFish(fr2, fish(fishidx,:,m),[255, 255, 255]);
            trueFishFrame(count,1:8)=[fish(fishidx,:,m),0,0];
            count=count+1;
        end
        
        
        
    end
    
    boxlessfish= floor(C(sum(truth,2)==0 & mag>0.5,:));
    boxlessfishvel=[u(sum(truth,2)==0 & mag>0.5,:), v(sum(truth,2)==0 & mag>0.5,:)];
    for noboxidx=1:size(boxlessfish,1)
        %fr2=crossHairFish(fr2, [boxlessfish(noboxidx,2)-10,boxlessfish(noboxidx,1)-10,...
           % boxlessfish(noboxidx,2)+10,boxlessfish(noboxidx,1)+10],[255, 255, 255]);
        trueFishFrame(count,1:8)=[boxlessfish(noboxidx,2)-10,boxlessfish(noboxidx,1)-10,boxlessfish(noboxidx,2)+10,boxlessfish(noboxidx,1)+10,boxlessfish(noboxidx,2),boxlessfish(noboxidx,1),boxlessfishvel(noboxidx,:)];
        count=count+1;
    end
    centerList=findComp(trueFishFrame(:,5:6));
    centi=1;
    for centi=1:size(centerList,1)
        if~isempty(centerList{centi})
        groupCenter = centerList{centi};

        trueCenter = floor([mean(groupCenter(:,1)), mean(groupCenter(:,2))]);
        fr2=crossHairFish(fr2,[trueCenter(1)-5,trueCenter(2)-5,trueCenter(1)+5,trueCenter(2)+5],[255, 255, 255]);
        %centi=centi+1;
        end
    end
    %[ kmeanidx, kmeanCent] = kmeans(trueFishFrame(:,5:6), 5);
    
   
    if m>speedLight+4
    
    oldFish=trueFish{m-4};
    
    guess=[oldFish(:,5)+oldFish(:,7), oldFish(:,6)+oldFish(:,8)];
    
    frameDiffs = pdist2(guess,trueFishFrame(:,5:6));%[numframes*numfish numFrames]
        [short, best_match_vec] = min(frameDiffs);
    
   %best_match_vec(short>50)=-99;
 	vec = oldFish(best_match_vec,9);
    vec(short>10)=-99;
     %a=vec;
    goodColors=vec(find(vec>-99));
    
    missingColors=setdiff(1:numFish,goodColors);
    numColors=length(trueFishFrame)-length(goodColors);
    if m==225
        pause(.1)
    end
    vec(vec==-99)=missingColors(1:numColors);
    trueFishFrame(:,9) = vec;
    else 
        trueFishFrame=[trueFishFrame,[1:size(trueFishFrame,1)]'];
    end
     trueFish{:,m}=trueFishFrame;
     
     
    %centers{:,m}=trueFishFrame(:,5:6);
    
    % imshow(fr2);
    % hold on;
    %figure()
    imshow(fr2);
    
    
    hold on
    %plot(kmeanCent(:,1), kmeanCent(:,2),'go')
    %quiver(cent(2,:), cent(1,:), avgvel(1,:),avgvel(2,:), 1,'g');
    %quiver(C(:,1), C(:,2), u,v, 1,'r');
    for colori=1:size(trueFishFrame,1)
        text(trueFishFrame(colori,6),trueFishFrame(colori,5),num2str(trueFishFrame(colori,9)),'Color','red')
    end
    hold off
    pause(0.1)
    clear trueFishFrame vec missingColors numColors best_match_vec short I oldFish boxlessFish noboxidx
end