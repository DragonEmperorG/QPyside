clear;
cProjectFolderPath = 'D:\GithubRepositories\QPyside\datasets\20220315_WHUSPARK';

cAlkaidSensorsFilePath = [cProjectFolderPath '\' 'Alkaid' '\' 'VdrExperimentAlkaidDataClipped'];
load(cAlkaidSensorsFilePath);

cPhoneExperimentDataClippedFilePath = [cProjectFolderPath '\' 'SAMSUNG_GalaxyS8\20220315_102823_Q2' '\' 'vdrExperimentPhoneTimeTableClipped'];
load(cPhoneExperimentDataClippedFilePath);

cTrainFilePath = [cProjectFolderPath '\' 'SAMSUNG_GalaxyS8\20220315_102823_Q2' '\' 'trainVdrExperimentTimeTable'];
load(cTrainFilePath);

slerp

% figure;
% stackedplot(vdrExperimentAlkaidIMUTimeTableClipped,{["Var4","Var5","Var6"] ["Var7","Var8","Var9"] ["Var10","Var11","Var12"]});
% stackedplot(vdrExperimentAlkaidIMUTimeTableClipped,{["Var7","Var8","Var9"]});

% figure;
% stackedplot(vdrExperimentAlkaidFusionTimeTableClipped,["Var2","Var3"]);
% stackedplot(vdrExperimentPhoneRegularSynchronizeTimeTable,{["Var2","Var3","Var4"]});
% stackedplot(vdrExperimentPhoneRegularSynchronizeTimeTable,"AlkaidDateTime");

% figure;
% stackedplot(vdrExperimentAlkaidFusionTimeTableClipped,{["ProjCoordinateDeltaX","ProjCoordinateDeltaY"]});




figure;
stackedplot(trainVdrExperimentTimeTable,{
["AccelerometerX",...
"AccelerometerY",...
"AccelerometerZ"] ...
["ProjCoordinateX"] ...
["ProjCoordinateY"]});

% figure;
% stackedplot(trainVdrExperimentTimeTable,{
% ["MagneticFieldX",...
% "MagneticFieldY",...
% "MagneticFieldZ"] ...
% ["ProjCoordinateX"] ...
% ["ProjCoordinateY"]});

