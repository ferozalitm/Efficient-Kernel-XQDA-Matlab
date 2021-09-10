%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%set_database.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

featuredirname_root = [directry '/Features/'];
addpath([directry '/Features/']);
addpath([directry '/DB/']);


databasename = 'CUHK01'; % CUHK01(M=1) singleshot 
featuredirname = featuredirname_root;
DBfile = 'CUHK01M1.mat';
numperson_train = 486;
numperson_probe = 485;
numperson_garalley = 485;
    
load(DBfile,  'allimagenames', 'traininds_set', 'testinds_set', ...
    'trainimagenames_set', 'testimagenames_set', 'trainlabels_set', ...
    'testlabels_set', 'traincamIDs_set', 'testcamIDs_set' );

allimagenums = size(allimagenames, 1);






