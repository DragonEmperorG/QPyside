clear;
cProjectFolderPath = 'D:\GithubRepositories\QPyside\datasets\20220315_WHUSPARK';

cPhoneExperimentDataClippedFilePath = [cProjectFolderPath '\' 'SAMSUNG_GalaxyS8\20220315_102823_Q2' '\' 'vdrExperimentPhoneTimeTableClipped'];
load(cPhoneExperimentDataClippedFilePath);

cAlkaidSensorsFilePath = [cProjectFolderPath '\' 'Alkaid' '\' 'VdrExperimentAlkaidDataClipped'];
load(cAlkaidSensorsFilePath);

trainClipStartDateTime = parseDateTime('2022-03-15 10:30:39.000000+08:00');
trainClipStopDateTime = min(vdrExperimentPhoneRegularSynchronizeTimeTable.Time(end), vdrExperimentAlkaidFusionTimeTableClipped.Time(end));

trainClipTimeRange = timerange(trainClipStartDateTime,trainClipStopDateTime,'closed');

vdrExperimentPhoneRegularSynchronizeTimeTableRange = vdrExperimentPhoneRegularSynchronizeTimeTable(trainClipTimeRange,:);
vdrExperimentAlkaidFusionTimeTableRange = vdrExperimentAlkaidFusionTimeTableClipped(trainClipTimeRange,:);
 
trainSynchronizedVdrExperimentTimeTable = synchronize(vdrExperimentPhoneRegularSynchronizeTimeTableRange,vdrExperimentAlkaidFusionTimeTableRange,'first','linear');
% trainSynchronizedVdrExperimentTimeTable = trainSynchronizedVdrExperimentTimeTable(1:3,:);
trainSynchronizedVdrExperimentTimeTableCounts = height(trainSynchronizedVdrExperimentTimeTable);
progressIndicator = 0;
for i = 1:trainSynchronizedVdrExperimentTimeTableCounts
    if i ~= 1
        trainSynchronizedVdrExperimentTimeTable.ProjCoordinateDeltaX(i) = trainSynchronizedVdrExperimentTimeTable.ProjCoordinateX(i) - trainSynchronizedVdrExperimentTimeTable.ProjCoordinateX(i-1);
        trainSynchronizedVdrExperimentTimeTable.ProjCoordinateDeltaY(i) = trainSynchronizedVdrExperimentTimeTable.ProjCoordinateY(i) - trainSynchronizedVdrExperimentTimeTable.ProjCoordinateY(i-1);
    end
    
    progressIndicator = progressIndicator + 1;
    if (progressIndicator == 1000) || (i == trainSynchronizedVdrExperimentTimeTableCounts)
        fprintf("Train converter progress: %d/%d\n", i, trainSynchronizedVdrExperimentTimeTableCounts);
        progressIndicator = 0;
    end
end

trainSynchronizedVdrExperimentTimeTable = renamevars(...
    trainSynchronizedVdrExperimentTimeTable,...
    ["Var2_vdrExperimentPhoneRegularSynchronizeTimeTableRange",...
    "Var3_vdrExperimentPhoneRegularSynchronizeTimeTableRange",...
    "Var4_vdrExperimentPhoneRegularSynchronizeTimeTableRange"], ...
    ["AccelerometerX","AccelerometerY","AccelerometerZ"]);
trainSynchronizedVdrExperimentTimeTable = renamevars(...
    trainSynchronizedVdrExperimentTimeTable,...
    ["Var5_vdrExperimentPhoneRegularSynchronizeTimeTableRange",...
    "Var6_vdrExperimentPhoneRegularSynchronizeTimeTableRange",...
    "Var7_vdrExperimentPhoneRegularSynchronizeTimeTableRange"], ...
    ["GyroscopeX","GyroscopeY","GyroscopeZ"]);
trainSynchronizedVdrExperimentTimeTable = renamevars(trainSynchronizedVdrExperimentTimeTable,...
    ["Var22","Var23","Var24"],["MagneticFieldX","MagneticFieldY","MagneticFieldZ"]);

trainSynchronizedVdrExperimentTable = timetable2table(trainSynchronizedVdrExperimentTimeTable,'ConvertRowTimes',false);
trainVdrExperimentTimeTable = table2timetable(trainSynchronizedVdrExperimentTable,'RowTimes',trainSynchronizedVdrExperimentTable.LocalPhoneDateTime);

trainVdrExperimentTimeTableRangeFilePath = [cProjectFolderPath '\' 'SAMSUNG_GalaxyS8\20220315_102823_Q2' '\' 'trainVdrExperimentTimeTable'];
save(trainVdrExperimentTimeTableRangeFilePath, 'trainVdrExperimentTimeTable');
