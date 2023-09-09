function [features] = feature_extraction(img)

%%%%%%%%GLCM features
    img1 = double((img));
    glcm=graycomatrix(img1,'offset',[2 0;0 2]);
    glcm_stat=graycoprops(glcm);
    glcm_feature=[glcm_stat.Contrast,glcm_stat.Correlation,glcm_stat.Energy,glcm_stat.Homogeneity];
    
%%%%%%%%%%%% BELBP
[row column]=size(img1);
MP_source=reshape(img1',[],1);
Orignal_source=MP_source;           
blocksize=8;                        
L=length(MP_source);                
number_blocks=L/(blocksize^2);    

for i=0:(row/blocksize-1)
    for j=0:(column/blocksize-1)
        Img_block=Img((i*blocksize+1):(i+1)*blocksize,(j*blocksize+1):(j+1)*blocksize);
        
        lbpi = nlfilter(Img_block,[3,3],@lbp_core);

% hist = imhist(uint8(lbpi));
    end
end

function x = lbp_core(blk)

bin = double(blk >= blk(5));

idx = [1:4, 5:9];

x = 0;
for i = 1:8
    x = x + bin(idx(i)) * 2^(i-1);
end

features=[lbpi   glcm_feature];