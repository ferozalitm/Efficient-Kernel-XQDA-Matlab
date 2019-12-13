%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% config.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set the root path of directry (edit according to your code location)
directry = '/home/feroz/Documents/PhD_Research/Codes/My_Workspace/Interns/KXQDA/';

addpath([directry '/Lib/']);
addpath([directry '/DataManage/']);

sys.setnum = 10;    %No. of sets
set_database;

%%???@configuration of features. 
parFea.featurenum = 4; 
parFea.usefeature = zeros( parFea.featurenum, 1);
parFea.usefeature(1) = 1; % GOG_RGB
parFea.usefeature(2) = 1; % GOG_Lab
parFea.usefeature(3) = 1; % GOG_HSV
parFea.usefeature(4) = 1; % GOG_nRnG

for f = 1:parFea.featurenum
    parFea.featureConf(f) = {set_feature_names(f)};
end








