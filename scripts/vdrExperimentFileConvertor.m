clear;
cProjectFolderPath = 'D:\GithubRepositories\QPyside\datasets\20220315_WHUSPARK';

% cAlkaidSensorsFilePath = [cProjectFolderPath '\' 'Alkaid' '\' 'VdrExperimentAlkaidIMUDataClipped.csv'];
% vdrExperimentAlkaidIMUDataClipped = readtable(cAlkaidSensorsFilePath,'Delimiter',',');
% % vdrExperimentAlkaidIMUDataClipped = vdrExperimentAlkaidIMUDataClipped(1:3,:);
% vdrExperimentAlkaidIMUDataClippedCounts = height(vdrExperimentAlkaidIMUDataClipped);
% vdrExperimentAlkaidIMUDateTimeClipped = datetime(zeros(vdrExperimentAlkaidIMUDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai'); 
% for i = 1:vdrExperimentAlkaidIMUDataClippedCounts
%     alkaidSensorsDataTimestampCell = vdrExperimentAlkaidIMUDataClipped.Var1(i);
%     alkaidSensorsDataDateTime = datetime(alkaidSensorsDataTimestampCell{1, 1},'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSSSSS+08:00','TimeZone','Asia/Shanghai');
%     vdrExperimentAlkaidIMUDataClipped.Var1(i) = {alkaidSensorsDataDateTime};
%     alkaidSensorsDataTimestampCell = vdrExperimentAlkaidIMUDataClipped.Var2(i);
%     alkaidSensorsDataDateTime = datetime(alkaidSensorsDataTimestampCell{1, 1},'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSSSSS+08:00','TimeZone','Asia/Shanghai');
%     vdrExperimentAlkaidIMUDataClipped.Var2(i) = {alkaidSensorsDataDateTime};
%     vdrExperimentAlkaidIMUDateTimeClipped(i,1) = alkaidSensorsDataDateTime;
% end
% vdrExperimentAlkaidIMUTimeTableClipped = table2timetable(vdrExperimentAlkaidIMUDataClipped,'RowTimes',vdrExperimentAlkaidIMUDateTimeClipped);


% cAlkaidFusionFilePath = [cProjectFolderPath '\' 'Alkaid' '\' 'VdrExperimentAlkaidFusionDataClipped.csv'];
% vdrExperimentAlkaidFusionDataClipped = readtable(cAlkaidFusionFilePath,'Delimiter',',');
% % vdrExperimentAlkaidFusionDataClipped = vdrExperimentAlkaidFusionDataClipped(1:3,:);
% vdrExperimentAlkaidFusionDataClippedCounts = height(vdrExperimentAlkaidFusionDataClipped);
% vdrExperimentAlkaidFusionDateTimeClipped = datetime(zeros(vdrExperimentAlkaidFusionDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
% 
% % http://epsg.io/4547
% kCGCS20003DegreeGKCM114EProjcrs = projcrs(4547);
% projCoordinateX = zeros(vdrExperimentAlkaidFusionDataClippedCounts, 1);
% projCoordinateY = zeros(vdrExperimentAlkaidFusionDataClippedCounts, 1);
% 
% for i = 1:vdrExperimentAlkaidFusionDataClippedCounts
%     alkaidSensorsDataTimestampCell = vdrExperimentAlkaidFusionDataClipped.Var1(i);
%     alkaidSensorsDataDateTime = datetime(alkaidSensorsDataTimestampCell{1,1},'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSSSSS+08:00','TimeZone','Asia/Shanghai');
%     vdrExperimentAlkaidFusionDataClipped.Var1(i) = {alkaidSensorsDataDateTime};
%     vdrExperimentAlkaidFusionDateTimeClipped(i,1) = alkaidSensorsDataDateTime;
%     
%     geoCoordinateLon = vdrExperimentAlkaidFusionDataClipped.Var2(i);
%     geoCoordinateLat = vdrExperimentAlkaidFusionDataClipped.Var3(i);
%     [x,y] = projfwd(kCGCS20003DegreeGKCM114EProjcrs,geoCoordinateLat,geoCoordinateLon);
%     projCoordinateX(i,1) = x;
%     projCoordinateY(i,1) = y;
% end
% vdrExperimentAlkaidFusionDataClipped = addvars(vdrExperimentAlkaidFusionDataClipped,projCoordinateX,projCoordinateY,'NewVariableNames',{'ProjCoordinateX','ProjCoordinateY'},'After','Var3');
% vdrExperimentAlkaidFusionTimeTableClipped = table2timetable(vdrExperimentAlkaidFusionDataClipped,'RowTimes',vdrExperimentAlkaidFusionDateTimeClipped);
% 
% VdrExperimentAlkaidDataClippedFilePath = [cProjectFolderPath '\' 'Alkaid' '\' 'VdrExperimentAlkaidDataClipped'];
% save(VdrExperimentAlkaidDataClippedFilePath,'vdrExperimentAlkaidIMUTimeTableClipped','vdrExperimentAlkaidFusionTimeTableClipped');


cPhoneExperimentDataClippedFilePath = [cProjectFolderPath '\' 'SAMSUNG_GalaxyS8\20220315_102823_Q2' '\' 'VdrExperimentDataClipped.csv'];
vdrExperimentPhoneDataClipped = readtable(cPhoneExperimentDataClippedFilePath,'Delimiter',',');
% vdrExperimentPhoneDataClipped = vdrExperimentPhoneDataClipped(1:3,:);
vdrExperimentPhoneDataClippedCounts = height(vdrExperimentPhoneDataClipped);
vdrExperimentPhoneDateTimeClipped = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
localPhoneRequestAlkaidDateTime = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
localPhoneResponseAlkaidDateTime = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
localPhoneMapAlkaidDateTime = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
alkaidDateTime = datetime(zeros(vdrExperimentPhoneDataClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
progressIndicator = 0;
for i = 1:vdrExperimentPhoneDataClippedCounts
    vdrExperimentPhoneDateTimeClipped(i,1) = parseDateTime(vdrExperimentPhoneDataClipped.Var1(i));
    localPhoneRequestAlkaidDateTime(i,1) = parseDateTime(vdrExperimentPhoneDataClipped.Var36(i));
    localPhoneResponseAlkaidDateTime(i,1) = parseDateTime(vdrExperimentPhoneDataClipped.Var37(i));
    dt = localPhoneResponseAlkaidDateTime(i,1) - localPhoneRequestAlkaidDateTime(i,1);
    dtHalf = dt * 0.5;
    localPhoneMapAlkaidDateTime(i,1) = localPhoneRequestAlkaidDateTime(i,1) + dtHalf;
    alkaidDateTime(i,1) = parseDateTime(vdrExperimentPhoneDataClipped.Var39(i));
    
    progressIndicator = progressIndicator + 1;
    if (progressIndicator == 100) || (i == vdrExperimentPhoneDataClippedCounts)
        fprintf("Parser progress: %d/%d\n", i, vdrExperimentPhoneDataClippedCounts);
        progressIndicator = 0;
    end
    
end
vdrExperimentPhoneDataClipped = addvars(vdrExperimentPhoneDataClipped,vdrExperimentPhoneDateTimeClipped,'NewVariableNames','LocalPhoneDateTime','After','Var1');
vdrExperimentPhoneDataClipped = addvars(vdrExperimentPhoneDataClipped,localPhoneRequestAlkaidDateTime,'NewVariableNames','LocalPhoneRequestAlkaidDateTime','After','Var36');
vdrExperimentPhoneDataClipped = addvars(vdrExperimentPhoneDataClipped,localPhoneResponseAlkaidDateTime,'NewVariableNames','LocalPhoneResponseAlkaidDateTime','After','Var37');
vdrExperimentPhoneDataClipped = addvars(vdrExperimentPhoneDataClipped,localPhoneMapAlkaidDateTime,'NewVariableNames','LocalPhoneMapAlkaidDateTime','After','LocalPhoneResponseAlkaidDateTime');
vdrExperimentPhoneDataClipped = addvars(vdrExperimentPhoneDataClipped,alkaidDateTime,'NewVariableNames','AlkaidDateTime','After','Var39');
vdrExperimentPhoneTimeTableClipped = table2timetable(vdrExperimentPhoneDataClipped,'RowTimes',vdrExperimentPhoneDateTimeClipped);

vdrExperimentPhoneTimeTableClippedSortedIndicator = issorted(vdrExperimentPhoneTimeTableClipped);
fprintf("Sorted: %d\n", vdrExperimentPhoneTimeTableClippedSortedIndicator);

vdrExperimentPhoneUniqueTimeTableClipped = unique(vdrExperimentPhoneTimeTableClipped.Time);
vdrExperimentPhoneFirstUniqueTimeTableClipped = retime(vdrExperimentPhoneTimeTableClipped,vdrExperimentPhoneUniqueTimeTableClipped,'firstvalue');
vdrExperimentPhoneUniqueTimeTableClippedCounts = height(vdrExperimentPhoneUniqueTimeTableClipped);
duplicateCounts = vdrExperimentPhoneDataClippedCounts - vdrExperimentPhoneUniqueTimeTableClippedCounts;
fprintf("Duplicated: %d\n", duplicateCounts);

VdrExperimentPhoneClippedFilePath = [cProjectFolderPath '\' 'SAMSUNG_GalaxyS8\20220315_102823_Q2' '\' 'vdrExperimentPhoneTimeTableClipped'];
save(VdrExperimentPhoneClippedFilePath,'vdrExperimentPhoneFirstUniqueTimeTableClipped');


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


