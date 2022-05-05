clear;
cProjectFolderPath = 'D:\GithubRepositories\QPyside\datasets\20220315_WHUSPARK';

cAlkaidSensorsFilePath = [cProjectFolderPath '\' 'Alkaid' '\' 'VdrExperimentAlkaidDataClipped'];
load(cAlkaidSensorsFilePath);

stackedplot(vdrExperimentAlkaidIMUTimeTableClipped,{["Var4","Var5","Var6"]});
