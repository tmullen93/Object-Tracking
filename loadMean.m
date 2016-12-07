vidObj=VideoReader('MajisAquarium_lowres.mov');
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
k = 1;
numFrame=10000;
% movie = zeros(vidHeight,vidWidth,3,numFrame,'uint8');
newbackground = zeros(vidHeight,vidWidth,3,'double');
while k<numFrame+1
    frame = im2double(readFrame(vidObj));
    newbackground = newbackground + frame;
    k = k+1;
end
newbackground = newbackground./numFrame;