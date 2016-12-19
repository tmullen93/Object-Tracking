%  load('movie.mat')
%  load('importantKMeansBackgroundVars.mat')
lengthmovierun=200;
h=size(movie,1);
w=size(movie,2);
epsilon=3000;
mask=zeros(h,w,lengthmovierun);
speedlight=20;
for framenum=1:lengthmovierun
framenum=270;
frame=movie(:,:,:,framenum);


for i=1:h*w
    [pixX,pixY] = ind2sub([h, w], i);
    pixel = double(squeeze(movie(pixX,pixY,:,framenum:framenum+speedlight)));
    [~,likelyIdx]=sort(counts(:,i));
    color1=repmat(C(likelyIdx(end),:,i)',[1, speedlight+1]);
    color2=repmat(C(likelyIdx(end-1),:,i)',[1,speedlight+1]);
    color3=repmat(C(likelyIdx(end-2),:,i)',[1,speedlight+1]);
    color4=repmat(C(likelyIdx(end-3),:,i)',[1,speedlight+1]);
    if sum(sum((pixel-color4).^2)>repmat(epsilon,[1,speedlight+1]))>0 && sum(sum((pixel-color3).^2)>repmat(epsilon,[1,speedlight+1]))>0 && sum(sum((pixel-color1).^2)>repmat(epsilon,[1,speedlight+1]))>0 && sum(sum((pixel-color2).^2)>repmat(epsilon,[1,speedlight+1]))>0
        mask(pixX,pixY,framenum)=1;
    end
end
figure()
imshow(mask(:,:,framenum))
pause(.1)

end