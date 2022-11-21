clear;
cProjectFolderPath = 'D:\GithubRepositories\QPyside\datasets\20220315_WHUSPARK';

cPhoneExperimentDataClippedFilePath = [cProjectFolderPath '\' 'SAMSUNG_GalaxyS8\20220315_102823_Q2' '\' 'vdrExperimentPhoneTimeTableClipped'];
load(cPhoneExperimentDataClippedFilePath);

vdrExperimentPhoneTableClipped = timetable2table(vdrExperimentPhoneFirstUniqueTimeTableClipped,'ConvertRowTimes',false);
vdrExperimentPhoneTimeTableClippedAlkaid = table2timetable(vdrExperimentPhoneTableClipped,'RowTimes',vdrExperimentPhoneTableClipped.AlkaidDateTime);
alkaidDateTimeUniqueTimes = unique(vdrExperimentPhoneTimeTableClippedAlkaid.Time);
firstUniqueRowsTT = retime(vdrExperimentPhoneTimeTableClippedAlkaid,alkaidDateTimeUniqueTimes,'firstvalue');
lastUniqueRowsTT = retime(vdrExperimentPhoneTimeTableClippedAlkaid,alkaidDateTimeUniqueTimes,'lastvalue');

% firstUniqueRowsTTTime = firstUniqueRowsTT.Time;
% firstUniqueRowsTTTimeDiff = diff(firstUniqueRowsTTTime);
% firstUniqueRowsTTPlotTime = firstUniqueRowsTTTime(1:(end-1),:); 
% figure;
% plot(firstUniqueRowsTTPlotTime, firstUniqueRowsTTTimeDiff);
% xlabel('Timestamp');
% ytickformat('hh:mm:ss.SSSSSS');
% ylabel('Duration');

firstLastRowsConcatenatedTT = [firstUniqueRowsTT;lastUniqueRowsTT];
firstLastRowsConcatenatedT = timetable2table(firstLastRowsConcatenatedTT,'ConvertRowTimes',false);
firstLastRowsConcatenatedTTLocal = table2timetable(firstLastRowsConcatenatedT,'RowTimes',firstLastRowsConcatenatedT.LocalPhoneDateTime);
vdrExperimentPhoneMapAlkaidUniqueTimeTable = unique(firstLastRowsConcatenatedTTLocal);

vdrExperimentPhoneMapAlkaidUniqueTable = timetable2table(vdrExperimentPhoneMapAlkaidUniqueTimeTable,'ConvertRowTimes',false);

vdrExperimentPhoneMapAlkaidUniqueTimeTableMA = table2timetable(vdrExperimentPhoneMapAlkaidUniqueTable,'RowTimes',vdrExperimentPhoneMapAlkaidUniqueTable.LocalPhoneMapAlkaidDateTime);
vdrExperimentPhoneMapAlkaidUniqueTimeTableAlkaidDateTime = vdrExperimentPhoneMapAlkaidUniqueTimeTableMA.AlkaidDateTime;
vdrExperimentPhoneFirstUniqueTimeTableClippedTimeDiff = diff(vdrExperimentPhoneMapAlkaidUniqueTimeTableAlkaidDateTime);
duration2s = duration(0,0,2);
synchronizeBaseIndex = find(vdrExperimentPhoneFirstUniqueTimeTableClippedTimeDiff == duration2s);
synchronizeBasePlusOneIndex = synchronizeBaseIndex + 1;

synchronizeBaseIndexCounts = size(synchronizeBaseIndex, 1);
synchronizePhoneDateTimeInterval = duration(zeros(synchronizeBaseIndexCounts,1), 0, 0);
synchronizePhoneDateTime = datetime(zeros(synchronizeBaseIndexCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
synchronizeAlkaidDateTime = datetime(zeros(synchronizeBaseIndexCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
for i = 1:synchronizeBaseIndexCounts
    anchorStartLocalPhoneMapAlkaidDateTime = vdrExperimentPhoneMapAlkaidUniqueTimeTableMA.LocalPhoneMapAlkaidDateTime(synchronizeBaseIndex(i,1));
    anchorStopLocalPhoneMapAlkaidDateTime = vdrExperimentPhoneMapAlkaidUniqueTimeTableMA.LocalPhoneMapAlkaidDateTime(synchronizeBasePlusOneIndex(i,1));
    synchronizePhoneDateTimeInterval(i,1) = anchorStopLocalPhoneMapAlkaidDateTime - anchorStartLocalPhoneMapAlkaidDateTime;
    synchronizePhoneDateTimeIntervalHalf = synchronizePhoneDateTimeInterval(i,1) * 0.5;
    synchronizePhoneDateTime(i,1) = anchorStartLocalPhoneMapAlkaidDateTime + synchronizePhoneDateTimeIntervalHalf;
    
    synchronizeAlkaidDateTime(i,1) = vdrExperimentPhoneMapAlkaidUniqueTimeTableMA.AlkaidDateTime(synchronizeBasePlusOneIndex(i,1)) - duration(0,0,0.5);
end

referenceDateTime = min(synchronizePhoneDateTime(1,1), synchronizeAlkaidDateTime(1,1));
referenceZeroDateTime = datetime(referenceDateTime.Year,referenceDateTime.Month,referenceDateTime.Day,referenceDateTime.Hour,referenceDateTime.Minute,floor(referenceDateTime.Second),'TimeZone',referenceDateTime.TimeZone);
synchronizeZeroPhoneDateTime = synchronizePhoneDateTime - referenceZeroDateTime;
synchronizeZeroAlkaidDateTime = synchronizeAlkaidDateTime - referenceZeroDateTime;
synchronizeZeroPhoneMilliseconds = milliseconds(synchronizeZeroPhoneDateTime);
synchronizeZeroAlkaidMilliseconds = milliseconds(synchronizeZeroAlkaidDateTime);

phoneMapAlkaidPolyfitModel = polyfit(synchronizeZeroPhoneMilliseconds,synchronizeZeroAlkaidMilliseconds,1);
fprintf("Polyfit model: %f %f\n",phoneMapAlkaidPolyfitModel(1,1),phoneMapAlkaidPolyfitModel(1,2));
synchronizeZeroAlkaidPolyfitMilliseconds = polyval(phoneMapAlkaidPolyfitModel,synchronizeZeroPhoneMilliseconds);
synchronizeZeroAlkaidPolyfitDateTime = duration(0,0,0,synchronizeZeroAlkaidPolyfitMilliseconds);
synchronizeAlkaidPolyfitDateTime = referenceZeroDateTime + synchronizeZeroAlkaidPolyfitDateTime;

figure;
plot(synchronizePhoneDateTime, synchronizeAlkaidDateTime,'o');
hold on;
plot(synchronizePhoneDateTime,synchronizeAlkaidPolyfitDateTime)
xlabel('Timestamp');
ytickformat('hh:mm:ss.SSSSSS');
ylabel('Timestamp');

% vdrExperimentPhoneRegularTimeTableClipped = vdrExperimentPhoneRegularTimeTableClipped(1:3,:);
vdrExperimentPhoneRegularTimeTableClippedCounts = height(vdrExperimentPhoneRegularTimeTableClipped);
synchronizeRegularAlkaidPolyfitDateTime = datetime(zeros(vdrExperimentPhoneRegularTimeTableClippedCounts,1), 0, 0,'TimeZone','Asia/Shanghai');
progressIndicator = 0;
for i = 1:vdrExperimentPhoneRegularTimeTableClippedCounts
    localRegularPhoneDateTime = vdrExperimentPhoneRegularTimeTableClipped.Time(i);
    localRegularPhoneZeroDateTime = localRegularPhoneDateTime - referenceZeroDateTime;
    localRegularPhoneZeroMilliseconds = milliseconds(localRegularPhoneZeroDateTime);
    alkaidPolyfitZeroMilliseconds = polyval(phoneMapAlkaidPolyfitModel,localRegularPhoneZeroMilliseconds);
    alkaidPolyfitZeroDuration = duration(0,0,0,alkaidPolyfitZeroMilliseconds);
    alkaidPolyfitDateTime = referenceZeroDateTime + alkaidPolyfitZeroDuration;
    synchronizeRegularAlkaidPolyfitDateTime(i,1) = alkaidPolyfitDateTime;
    
    progressIndicator = progressIndicator + 1;
    if (progressIndicator == 100) || (i == vdrExperimentPhoneRegularTimeTableClippedCounts)
        fprintf("Polyfit progress: %d/%d\n", i, vdrExperimentPhoneRegularTimeTableClippedCounts);
        progressIndicator = 0;
    end
end
vdrExperimentPhoneRegularTimeTableClipped = addvars(vdrExperimentPhoneRegularTimeTableClipped,synchronizeRegularAlkaidPolyfitDateTime,'NewVariableNames','AlkaidSynchronizeDateTime','After','AlkaidDateTime');
vdrExperimentPhoneRegularTimeTable = timetable2table(vdrExperimentPhoneRegularTimeTableClipped,'ConvertRowTimes',false);
vdrExperimentPhoneRegularSynchronizeTimeTable = table2timetable(vdrExperimentPhoneRegularTimeTable,'RowTimes',vdrExperimentPhoneRegularTimeTable.AlkaidSynchronizeDateTime);
vdrExperimentPhoneClippedFilePath = [cProjectFolderPath '\' 'SAMSUNG_GalaxyS8\20220315_102823_Q2' '\' 'vdrExperimentPhoneTimeTableClipped'];
% save(vdrExperimentPhoneClippedFilePath,'-append','vdrExperimentPhoneRegularSynchronizeTimeTable');

% synchronizeIndex = sort([synchronizeBaseIndex; synchronizeBasePlusOneIndex]);
% vdrExperimentPhoneMapAlkaidSynchronizeTimeTable = vdrExperimentPhoneMapAlkaidUniqueTimeTableMA(synchronizeIndex,:);
% vdrExperimentPhoneMapAlkaidSynchronizeTimeTableTime = vdrExperimentPhoneMapAlkaidSynchronizeTimeTable.Time;
% vdrExperimentPhoneMapAlkaidSynchronizeTimeTableDiff = diff(vdrExperimentPhoneMapAlkaidSynchronizeTimeTableTime);
% vdrExperimentPhoneMapAlkaidSynchronizeTimeTablePlotTime = vdrExperimentPhoneMapAlkaidSynchronizeTimeTableTime(1:(end-1),:);

% figure;
% plot(vdrExperimentPhoneMapAlkaidSynchronizeTimeTablePlotTime, vdrExperimentPhoneMapAlkaidSynchronizeTimeTableDiff);
% xlabel('Timestamp');
% ytickformat('hh:mm:ss.SSSSSS');
% ylabel('Duration');

% figure;
% stackedplot(vdrExperimentPhoneMapAlkaidSynchronizeTimeTable,"LocalPhoneMapAlkaidDateTime");


% vdrExperimentPhoneTableClipped = timetable2table(vdrExperimentPhoneTimeTableClipped,'ConvertRowTimes',false);
% vdrExperimentPhoneTimeTableClippedAlkaid = table2timetable(vdrExperimentPhoneTableClipped,'RowTimes',vdrExperimentPhoneTableClipped.AlkaidDateTime);
% uniqueTimes = unique(vdrExperimentPhoneTimeTableClippedAlkaid.AlkaidDateTime);
% 
% countTT = retime(vdrExperimentPhoneTimeTableClippedAlkaid,uniqueTimes,'count');
% 

% figure;
% stackedplot(vdrExperimentPhoneFirstUniqueTimeTableClipped,{["Var2","Var3","Var4"]});
% figure;
% stackedplot(vdrExperimentPhoneRegularTimeTableClipped,{["Var2","Var3","Var4"]});
