clear;
cProjectFolderPath = 'C:\GithubRepositories\QPyside\datasets\20220315_WHUSPARK';
cDatasetFolderPath = fullfile(cProjectFolderPath, 'SAMSUNG_GalaxyS8', '20220315_102823_Q2');
cPhoneGyroscopeFilePath = fullfile(cDatasetFolderPath, 'gyro.txt');
cPhoneGyroscopeUncalibratedFilePath = fullfile(cDatasetFolderPath, 'gyro_uncalib.txt');

kGyroBiasFileName = 'gyro_bias.txt';

dataGyroscope = readmatrix(cPhoneGyroscopeFilePath);
dataGyroscopeUncalibrated = readmatrix(cPhoneGyroscopeUncalibratedFilePath);

cScriptRunningCode = 0;
if cScriptRunningCode == 0
    [iniGyroscopeUncalibratedBias, endGyroscopeUncalibratedBias] = analyzeGyroscopeSensorData(dataGyroscope, dataGyroscopeUncalibrated);
    cPhoneImuFolderPath = fullfile(cDatasetFolderPath, 'imu');
    if exist(cPhoneImuFolderPath, 'dir') == 0
        mkdir(cPhoneImuFolderPath);
    end
    kGyroBiasFilePath = fullfile(cPhoneImuFolderPath, kGyroBiasFileName);
    writematrix(endGyroscopeUncalibratedBias,kGyroBiasFilePath,'Delimiter',' ');
end
