clear;
cProjectFolderPath = 'D:\GithubRepositories\QPyside\datasets\20220315_WHUSPARK';

cAlkaidSensorsFilePath = [cProjectFolderPath '\' 'Alkaid' '\' 'VdrExperimentAlkaidIMUDataClipped.csv'];
vdrExperimentAlkaidIMUDataClipped = readtable(cAlkaidSensorsFilePath,'Delimiter',',');
vdrExperimentAlkaidIMUDataClipped = vdrExperimentAlkaidIMUDataClipped(1:3,:);
vdrExperimentAlkaidIMUDataClippedCounts = height(vdrExperimentAlkaidIMUDataClipped);
vdrExperimentAlkaidIMUDateTimeClipped = datetime(zeros(vdrExperimentAlkaidIMUDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai'); 
for i = 1:vdrExperimentAlkaidIMUDataClippedCounts
    alkaidSensorsDataTimestampCell = vdrExperimentAlkaidIMUDataClipped.Var1(i);
    alkaidSensorsDataDateTime = datetime(alkaidSensorsDataTimestampCell{1, 1},'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSSSSS+08:00','TimeZone','Asia/Shanghai');
    vdrExperimentAlkaidIMUDataClipped.Var1(i) = {alkaidSensorsDataDateTime};
    alkaidSensorsDataTimestampCell = vdrExperimentAlkaidIMUDataClipped.Var2(i);
    alkaidSensorsDataDateTime = datetime(alkaidSensorsDataTimestampCell{1, 1},'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSSSSS+08:00','TimeZone','Asia/Shanghai');
    vdrExperimentAlkaidIMUDataClipped.Var2(i) = {alkaidSensorsDataDateTime};
    vdrExperimentAlkaidIMUDateTimeClipped(i,1) = alkaidSensorsDataDateTime;
end
vdrExperimentAlkaidIMUTimeTableClipped = table2timetable(vdrExperimentAlkaidIMUDataClipped,'RowTimes',vdrExperimentAlkaidIMUDateTimeClipped);


cAlkaidFusionFilePath = [cProjectFolderPath '\' 'Alkaid' '\' 'VdrExperimentAlkaidFusionDataClipped.csv'];
vdrExperimentAlkaidFusionDataClipped = readtable(cAlkaidFusionFilePath,'Delimiter',',');
vdrExperimentAlkaidFusionDataClipped = vdrExperimentAlkaidFusionDataClipped(1:3,:);
vdrExperimentAlkaidFusionDataClippedCounts = height(vdrExperimentAlkaidFusionDataClipped);
vdrExperimentAlkaidFusionDateTimeClipped = datetime(zeros(vdrExperimentAlkaidFusionDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
for i = 1:vdrExperimentAlkaidFusionDataClippedCounts
    alkaidSensorsDataTimestampCell = vdrExperimentAlkaidFusionDataClipped.Var1(i);
    alkaidSensorsDataDateTime = datetime(alkaidSensorsDataTimestampCell{1, 1},'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSSSSS+08:00','TimeZone','Asia/Shanghai');
    vdrExperimentAlkaidFusionDataClipped.Var1(i) = {alkaidSensorsDataDateTime};
    vdrExperimentAlkaidFusionDateTimeClipped(i,1) = alkaidSensorsDataDateTime;
end
vdrExperimentAlkaidFusionTimeTableClipped = table2timetable(vdrExperimentAlkaidFusionDataClipped,'RowTimes',vdrExperimentAlkaidFusionDateTimeClipped);

VdrExperimentAlkaidDataClippedFilePath = [cProjectFolderPath '\' 'Alkaid' '\' 'VdrExperimentAlkaidDataClipped'];
save(VdrExperimentAlkaidDataClippedFilePath,'vdrExperimentAlkaidIMUTimeTableClipped','vdrExperimentAlkaidFusionTimeTableClipped');


cPhoneExperimentDataClippedFilePath = [cProjectFolderPath '\' 'SAMSUNG_GalaxyS8\20220315_102823_Q2' '\' 'VdrExperimentDataClipped.csv'];
vdrExperimentPhoneDataClipped = readtable(cPhoneExperimentDataClippedFilePath,'Delimiter',',');
vdrExperimentPhoneDataClipped = vdrExperimentPhoneDataClipped(1:3,:);
vdrExperimentPhoneDataClippedCounts = height(vdrExperimentPhoneDataClipped);
vdrExperimentPhoneDateTimeClipped = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
for i = 1:vdrExperimentPhoneDataClippedCounts
    alkaidSensorsDataTimestampCell = vdrExperimentPhoneDataClipped.Var1(i);
    alkaidSensorsDataDateTime = datetime(alkaidSensorsDataTimestampCell{1, 1},'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSSSSS+08:00','TimeZone','Asia/Shanghai');
    vdrExperimentAlkaidFusionDataClipped.Var1(i) = {alkaidSensorsDataDateTime};
    vdrExperimentPhoneDateTimeClipped(i,1) = alkaidSensorsDataDateTime;
end
vdrExperimentAlkaidFusionTimeTableClipped = table2timetable(vdrExperimentAlkaidFusionDataClipped,'RowTimes',vdrExperimentAlkaidFusionDateTimeClipped);

VdrExperimentAlkaidDataClippedFilePath = [cProjectFolderPath '\' 'Alkaid' '\' 'VdrExperimentAlkaidDataClipped'];
save(VdrExperimentAlkaidDataClippedFilePath,'vdrExperimentAlkaidIMUTimeTableClipped','vdrExperimentAlkaidFusionTimeTableClipped');

