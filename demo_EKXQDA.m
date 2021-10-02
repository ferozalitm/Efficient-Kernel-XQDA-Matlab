%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% T M FEROZ ALI
%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

config;

load_features_all; % load all features.

CMCs = zeros( sys.setnum, numperson_garalley );

for set = 1:sys.setnum
    fprintf('----------------------------------------------------------------------------------------------------\n');
    fprintf('set = %d \n', set);
    fprintf('----------------------------------------------------------------------------------------------------\n');
    
    %% Load training data
    tot = 1;
    extract_feature_cell_from_all;  % load training data
    apply_normalization; % feature normalization
    conc_feature_cell; % feature concatenation    

    camIDs = traincamIDs_set{set};
    probX = feature(camIDs == 1, :);    %probe images
    galX = feature(camIDs == 2, :);     %gallery images
    labels = trainlabels_set{set};
    probXLabels = labels(camIDs == 1);
    galXLabels = labels(camIDs == 2);
    
    %% Load test data
    tot = 2;
    extract_feature_cell_from_all; % load test data
    apply_normalization; % feature normalization
    conc_feature_cell; % feature concatenation
    
    camIDs = testcamIDs_set{set};
    probY = feature(camIDs == 1, :);    %probe images
    galY = feature(camIDs == 2, :);     %gallery images
    labels = testlabels_set{set};
    probYLabels = labels(camIDs == 1);
    galYLabels = labels(camIDs == 2);

    %% Using only one image of each person while testing (single-shot-setting)
    %(Comment this section if you have only single image per class per camera
    probY = probY(1:2:end,:);
    probYLabels = probYLabels(1:2:end);  

    %% Train KXQDA metric learning
    [K, K_a, mu] = RBF_kernel([galX;probX], probY);
    [K_b] = RBF_kernel2([galX;probX], galY, mu);  
    K = (K+K')/2;
    
    [theta, Gamma] = EKXQDA(K, probXLabels, galXLabels);    
    Gamma_psd = projectPSD((Gamma+Gamma')/2); 
   
    %% single shot matching
    scores = MahDist(Gamma_psd, K_b'*theta, K_a'*theta)';       %From theorem (3) in paper

    CMC = zeros( numel(galYLabels), 1);
    for p=1:numel(probYLabels)
        score = scores(p, :);
        [sortscore, ind] = sort(score, 'ascend');

        correctind = find( galYLabels(ind) == probYLabels(p));
        CMC(correctind:end) = CMC(correctind:end) + 1;
    end
    CMC = 100.*CMC/numel(probYLabels);
    CMCs(set, :) = CMC;
        
   
    fprintf(' Rank1,  Rank5, Rank10, Rank15, Rank20\n');
    fprintf('%5.2f%%, %5.2f%%, %5.2f%%, %5.2f%%, %5.2f%%\n\n', CMC([1,5,10,15,20]));    
    
end    


fprintf('----------------------------------------------------------------------------------------------------\n');
fprintf('  Mean Result');
fprintf('----------------------------------------------------------------------------------------------------\n');

CMCmean = single(mean( squeeze(CMCs(1:sys.setnum , :)), 1));
fprintf(' Rank1,  Rank5, Rank10, Rank15, Rank20\n');
fprintf('%5.2f%%, %5.2f%%, %5.2f%%, %5.2f%%, %5.2f%% \n', CMCmean([1,5,10,15,20]) );


