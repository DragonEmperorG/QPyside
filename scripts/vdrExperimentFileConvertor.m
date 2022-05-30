clear;
cProjectFolderPath = 'D:\GithubRepositories\QPyside\datasets\20220315_WHUSPARK';

cAlkaidSensorsFilePath = [cProjectFolderPath '\' 'Alkaid' '\' 'VdrExperimentAlkaidIMUDataClipped.csv'];
vdrExperimentAlkaidIMUDataClipped = readtable(cAlkaidSensorsFilePath,'Delimiter',',');
% vdrExperimentAlkaidIMUDataClipped = vdrExperimentAlkaidIMUDataClipped(1:3,:);
vdrExperimentAlkaidIMUDataClippedCounts = height(vdrExperimentAlkaidIMUDataClipped);
vdrExperimentAlkaidIMULocalDateTimeClipped = datetime(zeros(vdrExperimentAlkaidIMUDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
vdrExperimentAlkaidIMUGnssDateTimeClipped = datetime(zeros(vdrExperimentAlkaidIMUDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');

progressIndicator = 0;
for i = 1:vdrExperimentAlkaidIMUDataClippedCounts
    vdrExperimentAlkaidIMULocalDateTimeClipped(i,1) = parseDateTime(vdrExperimentAlkaidIMUDataClipped.Var1(i));
    vdrExperimentAlkaidIMUGnssDateTimeClipped(i,1) = parseDateTime(vdrExperimentAlkaidIMUDataClipped.Var2(i));
    
    progressIndicator = progressIndicator + 1;
    if (progressIndicator == 100) || (i == vdrExperimentAlkaidIMUDataClippedCounts)
        fprintf("Alkaid IMU parser progress: %d/%d\n", i, vdrExperimentAlkaidIMUDataClippedCounts);
        progressIndicator = 0;
    end
end
vdrExperimentAlkaidIMUDataClipped = addvars(vdrExperimentAlkaidIMUDataClipped,vdrExperimentAlkaidIMULocalDateTimeClipped,'NewVariableNames','LocalAlkaidLinuxDateTime','After','Var1');
vdrExperimentAlkaidIMUDataClipped = addvars(vdrExperimentAlkaidIMUDataClipped,vdrExperimentAlkaidIMUGnssDateTimeClipped,'NewVariableNames','LocalAlkaidGnssDateTime','After','Var2');
vdrExperimentAlkaidIMUDataClipped = removevars(vdrExperimentAlkaidIMUDataClipped,{'Var1','Var2'});
vdrExperimentAlkaidIMUTimeTableClipped = table2timetable(vdrExperimentAlkaidIMUDataClipped,'RowTimes',vdrExperimentAlkaidIMUGnssDateTimeClipped);


cAlkaidFusionFilePath = [cProjectFolderPath '\' 'Alkaid' '\' 'VdrExperimentAlkaidFusionDataClipped.csv'];
vdrExperimentAlkaidFusionDataClipped = readtable(cAlkaidFusionFilePath,'Delimiter',',');
% vdrExperimentAlkaidFusionDataClipped = vdrExperimentAlkaidFusionDataClipped(1:3,:);
vdrExperimentAlkaidFusionDataClippedCounts = height(vdrExperimentAlkaidFusionDataClipped);
vdrExperimentAlkaidFusionDateTimeClipped = datetime(zeros(vdrExperimentAlkaidFusionDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');

% http://epsg.io/4547
kCGCS20003DegreeGKCM114EProjcrs = projcrs(4547);
projCoordinateX = zeros(vdrExperimentAlkaidFusionDataClippedCounts, 1);
projCoordinateY = zeros(vdrExperimentAlkaidFusionDataClippedCounts, 1);
projCoordinateDeltaX = zeros(vdrExperimentAlkaidFusionDataClippedCounts, 1);
projCoordinateDeltaY = zeros(vdrExperimentAlkaidFusionDataClippedCounts, 1);

progressIndicator = 0;
for i = 1:vdrExperimentAlkaidFusionDataClippedCounts
    vdrExperimentAlkaidFusionDateTimeClipped(i,1) = parseDateTime(vdrExperimentAlkaidFusionDataClipped.Var1(i));
    
    geoCoordinateLon = vdrExperimentAlkaidFusionDataClipped.Var2(i);
    geoCoordinateLat = vdrExperimentAlkaidFusionDataClipped.Var3(i);
    [x,y] = projfwd(kCGCS20003DegreeGKCM114EProjcrs,geoCoordinateLat,geoCoordinateLon);
    projCoordinateX(i,1) = x;
    projCoordinateY(i,1) = y;
    
    if i ~= 1
        projCoordinateDeltaX(i,1) = projCoordinateX(i,1) - projCoordinateX(i-1,1);
        projCoordinateDeltaY(i,1) = projCoordinateY(i,1) - projCoordinateY(i-1,1);
    end
    
    progressIndicator = progressIndicator + 1;
    if (progressIndicator == 100) || (i == vdrExperimentAlkaidFusionDataClippedCounts)
        fprintf("Alkaid fusion parser progress: %d/%d\n", i, vdrExperimentAlkaidFusionDataClippedCounts);
        progressIndicator = 0;
    end
end
vdrExperimentAlkaidFusionDataClipped = addvars(vdrExperimentAlkaidFusionDataClipped,vdrExperimentAlkaidFusionDateTimeClipped,'NewVariableNames','LocalAlkaidGnssDateTime','After','Var1');
vdrExperimentAlkaidFusionDataClipped = addvars(vdrExperimentAlkaidFusionDataClipped,projCoordinateX,projCoordinateY,projCoordinateDeltaX,projCoordinateDeltaY,'NewVariableNames',{'ProjCoordinateX','ProjCoordinateY','ProjCoordinateDeltaX','ProjCoordinateDeltaY'},'After','Var3');
vdrExperimentAlkaidFusionDataClipped = removevars(vdrExperimentAlkaidFusionDataClipped,{'Var1'});
vdrExperimentAlkaidFusionTimeTableClipped = table2timetable(vdrExperimentAlkaidFusionDataClipped,'RowTimes',vdrExperimentAlkaidFusionDateTimeClipped);

VdrExperimentAlkaidDataClippedFilePath = [cProjectFolderPath '\' 'Alkaid' '\' 'VdrExperimentAlkaidDataClipped'];
save(VdrExperimentAlkaidDataClippedFilePath,'vdrExperimentAlkaidIMUTimeTableClipped','vdrExperimentAlkaidFusionTimeTableClipped');


% cPhoneExperimentDataClippedFilePath = [cProjectFolderPath '\' 'SAMSUNG_GalaxyS8\20220315_102823_Q2' '\' 'VdrExperimentDataClipped.csv'];
% vdrExperimentPhoneDataClipped = readtable(cPhoneExperimentDataClippedFilePath,'Delimiter',',');
% % vdrExperimentPhoneDataClipped = vdrExperimentPhoneDataClipped(1:3,:);
% vdrExperimentPhoneDataClippedCounts = height(vdrExperimentPhoneDataClipped);
% vdrExperimentPhoneDateTimeClipped = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
% localPhoneGnssDateTime = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
% localPhoneRequestAlkaidDateTime = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
% localPhoneResponseAlkaidDateTime = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
% localPhoneMapAlkaidDateTime = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
% alkaidDateTime = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
% progressIndicator = 0;
% for i = 1:vdrExperimentPhoneDataClippedCounts
%     vdrExperimentPhoneDateTimeClipped(i,1) = parseDateTime(vdrExperimentPhoneDataClipped.Var1(i));
%     localPhoneGnssDateTime(i,1) = parseDateTime(vdrExperimentPhoneDataClipped.Var32(i));
%     localPhoneRequestAlkaidDateTime(i,1) = parseDateTime(vdrExperimentPhoneDataClipped.Var36(i));
%     localPhoneResponseAlkaidDateTime(i,1) = parseDateTime(vdrExperimentPhoneDataClipped.Var37(i));
%     dt = localPhoneResponseAlkaidDateTime(i,1) - localPhoneRequestAlkaidDateTime(i,1);
%     dtHalf = dt * 0.5;
%     localPhoneMapAlkaidDateTime(i,1) = localPhoneRequestAlkaidDateTime(i,1) + dtHalf;
%     alkaidDateTime(i,1) = parseDateTime(vdrExperimentPhoneDataClipped.Var39(i));
%     
%     progressIndicator = progressIndicator + 1;
%     if (progressIndicator == 100) || (i == vdrExperimentPhoneDataClippedCounts)
%         fprintf("Parser progress: %d/%d\n", i, vdrExperimentPhoneDataClippedCounts);
%         progressIndicator = 0;
%     end
%     
% end
% vdrExperimentPhoneDataClipped = addvars(vdrExperimentPhoneDataClipped,vdrExperimentPhoneDateTimeClipped,'NewVariableNames','LocalPhoneDateTime','After','Var1');
% vdrExperimentPhoneDataClipped = addvars(vdrExperimentPhoneDataClipped,localPhoneGnssDateTime,'NewVariableNames','LocalPhoneGnssDateTime','After','Var32');
% vdrExperimentPhoneDataClipped = addvars(vdrExperimentPhoneDataClipped,localPhoneRequestAlkaidDateTime,'NewVariableNames','LocalPhoneRequestAlkaidDateTime','After','Var36');
% vdrExperimentPhoneDataClipped = addvars(vdrExperimentPhoneDataClipped,localPhoneResponseAlkaidDateTime,'NewVariableNames','LocalPhoneResponseAlkaidDateTime','After','Var37');
% vdrExperimentPhoneDataClipped = addvars(vdrExperimentPhoneDataClipped,localPhoneMapAlkaidDateTime,'NewVariableNames','LocalPhoneMapAlkaidDateTime','After','LocalPhoneResponseAlkaidDateTime');
% vdrExperimentPhoneDataClipped = addvars(vdrExperimentPhoneDataClipped,alkaidDateTime,'NewVariableNames','AlkaidDateTime','After','Var39');
% 
% vdrExperimentPhoneDataClipped = removevars(vdrExperimentPhoneDataClipped,{'Var1','Var32','Var36','Var37','Var39'});
% 
% vdrExperimentPhoneTimeTableClipped = table2timetable(vdrExperimentPhoneDataClipped,'RowTimes',vdrExperimentPhoneDateTimeClipped);
% 
% vdrExperimentPhoneTimeTableClippedSortedIndicator = issorted(vdrExperimentPhoneTimeTableClipped);
% fprintf("Sorted: %d\n", vdrExperimentPhoneTimeTableClippedSortedIndicator);
% 
% vdrExperimentPhoneUniqueTimeTableClipped = unique(vdrExperimentPhoneTimeTableClipped.Time);
% vdrExperimentPhoneFirstUniqueTimeTableClipped = retime(vdrExperimentPhoneTimeTableClipped,vdrExperimentPhoneUniqueTimeTableClipped,'firstvalue');
% vdrExperimentPhoneUniqueTimeTableClippedCounts = height(vdrExperimentPhoneUniqueTimeTableClipped);
% duplicateCounts = vdrExperimentPhoneDataClippedCounts - vdrExperimentPhoneUniqueTimeTableClippedCounts;
% fprintf("Duplicated: %d\n", duplicateCounts);
% 
% vdrExperimentPhoneFirstUniqueTimeTableClippedTime = vdrExperimentPhoneFirstUniqueTimeTableClipped.Time;
% vdrExperimentPhoneFirstUniqueTimeTableClippedTimeDiff = diff(vdrExperimentPhoneFirstUniqueTimeTableClippedTime);
% vdrExperimentPhoneTimeTableClippedPlotTime = vdrExperimentPhoneFirstUniqueTimeTableClippedTime(1:(end-1),:);
% figure;
% plot(vdrExperimentPhoneTimeTableClippedPlotTime, vdrExperimentPhoneFirstUniqueTimeTableClippedTimeDiff);
% xlabel('Timestamp');
% ytickformat('hh:mm:ss.SSSSSS');
% ylabel('Duration');
% 
% vdrExperimentPhoneUniqueTimeTableClippedDiff = diff(vdrExperimentPhoneFirstUniqueTimeTableClipped.Time);
% meanSampleInterval = mean(vdrExperimentPhoneUniqueTimeTableClippedDiff);
% fprintf("Mean sample interval: %f\n",milliseconds(meanSampleInterval));
% 
% vdrExperimentPhoneRegularTimeTableClipped = retime(vdrExperimentPhoneFirstUniqueTimeTableClipped,'regular','linear','SampleRate',200);
% 
% vdrExperimentPhoneClippedFilePath = [cProjectFolderPath '\' 'SAMSUNG_GalaxyS8\20220315_102823_Q2' '\' 'vdrExperimentPhoneTimeTableClipped'];
% save(vdrExperimentPhoneClippedFilePath,'vdrExperimentPhoneFirstUniqueTimeTableClipped','vdrExperimentPhoneRegularTimeTableClipped');


% cPhoneExperimentDataClippedFolderPath = [cProjectFolderPath '\' 'GOOGLE_Pixel3\20220315_100846_ Q2'];
% cPhoneExperimentDataClippedFilePath = [cPhoneExperimentDataClippedFolderPath '\' 'VdrExperimentDataClipped.csv'];
% vdrExperimentPhoneDataClipped = readtable(cPhoneExperimentDataClippedFilePath,'Delimiter',',');
% % % vdrExperimentPhoneDataClipped = vdrExperimentPhoneDataClipped(1:3,:);
% vdrExperimentPhoneDataClippedCounts = height(vdrExperimentPhoneDataClipped);
% vdrExperimentPhoneDateTimeClipped = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
% for i = 1:vdrExperimentPhoneDataClippedCounts
%     alkaidSensorsDataTimestampCell = vdrExperimentPhoneDataClipped.Var1(i);
%     alkaidSensorsDataTimestampString = alkaidSensorsDataTimestampCell{1, 1};
%     alkaidSensorsDataTimestampStringLength = length(alkaidSensorsDataTimestampString);
%     if alkaidSensorsDataTimestampStringLength == 25
%         alkaidSensorsDataDateTime = datetime(alkaidSensorsDataTimestampString,'InputFormat','yyyy-MM-dd HH:mm:ss+08:00','TimeZone','Asia/Shanghai');
%     else
%         alkaidSensorsDataDateTime = datetime(alkaidSensorsDataTimestampString,'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS+08:00','TimeZone','Asia/Shanghai');
%     end
%     vdrExperimentPhoneDataClipped.Var1(i) = {alkaidSensorsDataDateTime};
%     vdrExperimentPhoneDateTimeClipped(i,1) = alkaidSensorsDataDateTime;
% end
% vdrExperimentPhoneTimeTableClipped = table2timetable(vdrExperimentPhoneDataClipped,'RowTimes',vdrExperimentPhoneDateTimeClipped);
% 
% VdrExperimentPhoneClippedFilePath = [cPhoneExperimentDataClippedFolderPath '\' 'vdrExperimentPhoneTimeTableClipped'];
% save(VdrExperimentPhoneClippedFilePath,'vdrExperimentPhoneTimeTableClipped');


% cPhoneExperimentDataClippedFolderPath = [cProjectFolderPath '\' 'HUAWEI_Mate30\20220315_102821_Q2'];
% cPhoneExperimentDataClippedFilePath = [cPhoneExperimentDataClippedFolderPath '\' 'VdrExperimentDataClipped.csv'];
% vdrExperimentPhoneDataClipped = readtable(cPhoneExperimentDataClippedFilePath,'Delimiter',',');
% % % vdrExperimentPhoneDataClipped = vdrExperimentPhoneDataClipped(1:3,:);
% vdrExperimentPhoneDataClippedCounts = height(vdrExperimentPhoneDataClipped);
% vdrExperimentPhoneDateTimeClipped = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
% for i = 1:vdrExperimentPhoneDataClippedCounts
%     alkaidSensorsDataTimestampCell = vdrExperimentPhoneDataClipped.Var1(i);
%     alkaidSensorsDataTimestampString = alkaidSensorsDataTimestampCell{1, 1};
%     alkaidSensorsDataTimestampStringLength = length(alkaidSensorsDataTimestampString);
%     if alkaidSensorsDataTimestampStringLength == 25
%         alkaidSensorsDataDateTime = datetime(alkaidSensorsDataTimestampString,'InputFormat','yyyy-MM-dd HH:mm:ss+08:00','TimeZone','Asia/Shanghai');
%     else
%         alkaidSensorsDataDateTime = datetime(alkaidSensorsDataTimestampString,'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS+08:00','TimeZone','Asia/Shanghai');
%     end
%     vdrExperimentPhoneDataClipped.Var1(i) = {alkaidSensorsDataDateTime};
%     vdrExperimentPhoneDateTimeClipped(i,1) = alkaidSensorsDataDateTime;
% end
% vdrExperimentPhoneTimeTableClipped = table2timetable(vdrExperimentPhoneDataClipped,'RowTimes',vdrExperimentPhoneDateTimeClipped);
% 
% VdrExperimentPhoneClippedFilePath = [cPhoneExperimentDataClippedFolderPath '\' 'vdrExperimentPhoneTimeTableClipped'];
% save(VdrExperimentPhoneClippedFilePath,'vdrExperimentPhoneTimeTableClipped');


