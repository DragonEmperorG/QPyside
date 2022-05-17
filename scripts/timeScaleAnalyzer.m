clear;
cProjectFolderPath = 'D:\GithubRepositories\QPyside\datasets\20220315_WHUSPARK';

cPhoneExperimentDataClippedFilePath = [cProjectFolderPath '\' 'SAMSUNG_GalaxyS8\20220315_102823_Q2' '\' 'vdrExperimentPhoneTimeTableClipped'];
load(cPhoneExperimentDataClippedFilePath);

vdrExperimentPhoneTimeTableClippedDiff = diff(vdrExperimentPhoneTimeTableClipped.Time);
figure;


plot(vdrExperimentPhoneTimeTableClippedDiff);
ytickformat('hh:mm:ss.SSSSSS');

vdrExperimentPhoneTableClipped = timetable2table(vdrExperimentPhoneTimeTableClipped,'ConvertRowTimes',false);
vdrExperimentPhoneTimeTableClippedAlkaid = table2timetable(vdrExperimentPhoneTableClipped,'RowTimes',vdrExperimentPhoneTableClipped.AlkaidDateTime);
uniqueTimes = unique(vdrExperimentPhoneTimeTableClippedAlkaid.AlkaidDateTime);



countTT = retime(vdrExperimentPhoneTimeTableClippedAlkaid,uniqueTimes,'count');

figure;
stackedplot(countTT,"AlkaidDateTime");
