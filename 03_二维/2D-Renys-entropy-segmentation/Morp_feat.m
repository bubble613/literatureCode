
function feature_morp = Morp_feat(segmented_image)

 SE = strel('square',2);
 BW = im2bw(segmented_image);
 BW2 = imdilate(BW,SE);
 CC1 = bwconncomp(BW2,4);
    stats1 = regionprops(CC1,'Area','Perimeter','EulerNumber','Eccentricity','ConvexArea','Extent','Orientation','MajorAxisLength','MinorAxisLength');
    avgArea = sum([stats1.Area])/CC1.NumObjects;
    avgPeri = sum([stats1.Perimeter])/CC1.NumObjects;
    avgElno = sum([stats1.EulerNumber])/CC1.NumObjects;
    avgEcc = sum([stats1.Eccentricity])/CC1.NumObjects;
    avgEx = sum([stats1.Extent])/CC1.NumObjects;
    avgOr =sum([stats1.Orientation])/CC1.NumObjects;
    avgMal = sum([stats1.MajorAxisLength])/CC1.NumObjects;
    avgMinl = sum([stats1.MinorAxisLength])/CC1.NumObjects;
    mfeature = [avgArea avgPeri avgElno avgEcc avgCA avgEx avgOr avgMal avgMinl];
    

    feature_morp = mfeature;
