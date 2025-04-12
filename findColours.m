function colordetect = findColours(filename, varargin)

if ~isempty(varargin) % check optional args
    mat_filename = varargin{1}; % get filename
    fprintf('Loading %s\n', mat_filename); % load message
    load(mat_filename, 'res'); % load file
else
    res = rand(4, 4, 3); % default random colors
end

disp(filename); % display filename
image = loadImage(filename); % load image

fprintf('Processing image: %s\n', filename); % process message

pfigure; % new figure
imshow(image); % show image
title(filename, 'Interpreter', 'none'); % set title

circleCoordinates = findCircles(image); % find circles

if contains(filename, 'noise_') || contains(filename, 'org_') % check noise/org
    result = getColours(image); % get colors
elseif contains(filename, 'proj_') || contains(filename,'rot_') % check proj/rot
    correctedImage = correctImage(circleCoordinates, image); % correct image
    result = getColours(correctedImage); % get colors
else
    disp('Wrong format or distorted image'); % error message
    result = []; % empty result
end

disp(result) % display result
colordetect = result; % return colors
end

function image=loadImage(filename)
image= imread(filename); % read image
image=im2double(image); % convert to double
end

function circleCoordinates=findCircles(image)
grayimg=rgb2gray(image); % to grayscale
threshold=graythresh(grayimg); % compute threshold
bin_img= imbinarize(grayimg,threshold); % binarize image
inv_bin_img=imcomplement(bin_img); % invert binary
connected_components=bwconncomp(inv_bin_img); % find components
areas=cellfun(@numel,connected_components.PixelIdxList); % get areas
[area_sort,indices_sort]=sort(areas,'descend'); % sort areas
num_blobs = 5; % number of blobs
blob_coords = zeros(num_blobs, 2); % initialize coords
for i = 2:num_blobs % loop blobs
    blob_indices = connected_components.PixelIdxList{indices_sort(i)}; % get blob indices
    [rows, cols] = ind2sub(size(inv_bin_img), blob_indices); % get subscripts
    blob_coords(i, :) = [ mean(cols),mean(rows)]; % mean coordinates
end
blob_coords(1, :) = []; % remove first blob

sortedCoordinates = sortrows(blob_coords); % sort coordinates

if sortedCoordinates(2,2) < sortedCoordinates(1,2) % swap if needed
    sortedCoordinates([1 2],:) = sortedCoordinates([2 1],:); % swap rows
end

if sortedCoordinates(4,2) > sortedCoordinates(3,2) % swap if needed
    sortedCoordinates([3 4],:) = sortedCoordinates([4 3],:); % swap rows
end

circleCoordinates=sortedCoordinates; % return coordinates

end

function outputImage = correctImage(Coordinates, image)
boxf = [[0 ,0]; [0 ,480];[480 ,480]; [480 ,0]]; % box coordinates
TF = fitgeotrans(Coordinates,boxf,'projective'); % transformation
outview = imref2d(size(image)); % image ref
B = imwarp(image,TF,'fillvalues',255,outputview=outview); % apply transform
B = imcrop(B,[0 0 480 480]); % crop image
B = imflatfield(B,40); % flat-field correction
B = imadjust(B,[0.4 0.65]); % adjust contrast
outputImage = B; % return corrected image
end

function colours=getColours(image)
W=im2uint8(image); % convert to uint8
W = medfilt3(W,[7 7 1]); % median filter
W = imadjust(W,stretchlim(W,0.025)); % adjust contrast
Conimage = rgb2gray(W)>20; % threshold gray
Conimage = bwareaopen(Conimage,100); % remove small specks
Conimage = ~bwareaopen(~Conimage,100); % remove negative specks
Conimage = imclearborder(Conimage); % clear border
Conimage = imerode(Conimage,ones(10)); % erode image
[K O] = bwlabel(Conimage); % label regions
Concolors = zeros(O,3); % initialize colors
for p = 1:O % loop regions
    each_pch = K==p; % get patch
    all_pch_areas = W(each_pch(:,:,[1 1 1])); % get colors
    Concolors(p,:) = mean(reshape(all_pch_areas,[],3),1); % average color
end
Concolors = Concolors./255; % normalize colors
Y = regionprops(Conimage,'centroid'); % get centroids
X = vertcat(Y.Centroid); % stack centroids
lim_X = [min(X,[],1); max(X,[],1)]; % limits
X = round((X-lim_X(1,:))./range(lim_X,1)*3 + 1); % snap to grid
idx = sub2ind([4 4],X(:,2),X(:,1)); % get indices
Concolors(idx,:) = Concolors; % reorder colors
clrnames = {'white','red','green','blue','yellow'}; % color names
clrrefs = [1 1 1; 1 0 0; 0 1 0; 0 0 1; 1 1 0]; % ref colors
I = Concolors - permute(clrrefs,[3 2 1]); % color diff
I = squeeze(sum(I.^2,2)); % sum squares
[~,idx] = min(I,[],2); % nearest match
Colornames = reshape(clrnames(idx),4,4); % reshape names
colours= Colornames; % return colors

end
