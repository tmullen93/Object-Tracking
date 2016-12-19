lengthMovie=1000;
% pointsred = squeeze(movie(:,:,1,1:lengthMovie));
% pointsgreen = squeeze(movie(:,:,2,1:lengthMovie));
% pointsblue = squeeze(movie(:,:,3,1:lengthMovie));
% 
% final(:,1,:) = reshape(pointsred, size(pointsred,1)*size(pointsred,2),size(pointsred,3))';
% final(:,2,:) = reshape(pointsgreen, size(pointsgreen,1)*size(pointsgreen,2),size(pointsgreen,3))';
% final(:,3,:) = reshape(pointsblue, size(pointsblue,1)*size(pointsblue,2),size(pointsblue,3))';

% final(:,1,:)=pointsredline;
% final(:,2,:)=pointsgreenline;
% final(:,3,:)=pointsblueline;
numPix=size(final,3);
%numPix=1000;
numClusters=5;
idx3=zeros(lengthMovie,numPix);
C=zeros(numClusters,3,numPix);
counts=zeros(numClusters,numPix);

tic
for j=1:numPix
    X=double(final(:,:,j));
    [idx3(:,j),C(:,:,j)] = kmeans(X,5);
    counts(:,j)=histcounts(idx3(:,j));
end
toc
% 
% figure
% [silh3,h] = silhouette(X,idx3(:,j),'cityblock');
% h = gca;
% h.Children.EdgeColor = [.8 .8 1];
% xlabel 'Silhouette Value'
% ylabel 'Cluster'


% colors(:,:,1)=C(:,1);
% colors(:,:,2)=C(:,2);
% colors(:,:,3)= C(:,3);
% figure
% imshow(imresize(uint8(colors),50))