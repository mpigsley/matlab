function [] = WhiteToTransparent(image_in, image_out)
%
%   WhiteToTransparent(im, image_out)
%
%   Arguments:
%       image_in is the name of the image to be loaded
%       image_out is the name of the image to be saved in the current
%           directory
%
%   Notes:
%       The image needs to be added to the path before loading
%       The image ideally should be black and white before loading into
%           script
%   

im = imread(image_in);
bw = ~imdilate(im2bw(im,graythresh(im)),[0 1]);
bw = [bw zeros(size(bw,1),1)];
bw(:,1) = [];
imwrite(im,image_out,'Alpha',+bw);

end