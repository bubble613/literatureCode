
function feature_morp = Morp_feat(segmented_images)

% SE = strel('square',4);
% for clusid=1:3
%     %components=1;
%     level = graythresh(segmented_images{clusid});
%     BW = im2bw(segmented_images{clusid},level);
%     BW2 = imdilate(BW,SE);
%     CC = bwconncomp(BW2,4);
%     stats = regionprops(CC, 'Area','Perimeter','EulerNumber','Eccentricity','ConvexArea','Extent','Orientation','MajorAxisLength','MinorAxisLength'); 
%     idx = find([stats.Area] > 100); 
%     BW1 = ismember(labelmatrix(CC), idx);
%     CC1= bwconncomp(BW1,4);
CC1=segmented_images;
    stats1 = regionprops(CC1,'Area','Perimeter','EulerNumber','Eccentricity','ConvexArea','Extent','Orientation','MajorAxisLength','MinorAxisLength');
    avgArea = sum([stats1.Area])/CC1.NumObjects;
    avgPeri = sum([stats1.Perimeter])/CC1.NumObjects;
    avgElno = sum([stats1.EulerNumber])/CC1.NumObjects;
    avgEcc = sum([stats1.Eccentricity])/CC1.NumObjects;
    avgCA = sum([stats1.ConvexArea])/CC1.NumObjects;
    avgEx = sum([stats1.Extent])/CC1.NumObjects;
    avgOr =sum([stats1.Orientation])/CC1.NumObjects;
    avgMal = sum([stats1.MajorAxisLength])/CC1.NumObjects;
    avgMinl = sum([stats1.MinorAxisLength])/CC1.NumObjects;
    mfeature = [avgArea avgPeri avgElno avgEcc avgCA avgEx avgOr avgMal avgMinl];
    %nCC = CC.NumObjects;
%     s = regionprops(BW2,'Area','Perimeter','EulerNumber','Eccentricity','ConvexArea','Extent','Orientation','MajorAxisLength','MinorAxisLength');
%     if s.Area >100
%        components = components+1;
%        Q(components) = [s.Area s.Perimeter s.EulerNumber s.Eccentricity s.ConvexArea s.Extent s.Orientation s.MajorAxisLength s.MinorAxisLength ];
%        
%     end

    feature_morp = [mfeature(1,:) ];
