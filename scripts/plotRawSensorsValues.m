% clear;
kCGCS20003DegreeGKCM114EProjcrs = projcrs(4547);
cProjectFolderPath = 'C:\GithubRepositories\QPyside\datasets\20220315_WHUSPARK';

cTrainFilePath = [cProjectFolderPath '\' 'SAMSUNG_GalaxyS8\20220315_102823_Q2' '\' 'VdrExperimentDataClipped.csv'];
rawSensorTable = readtable(cTrainFilePath,'Delimiter', ',');
rawSensorTableHeight = height(rawSensorTable);
rawSensorData = zeros(rawSensorTableHeight, 3);
for i = 1:rawSensorTableHeight
    rawSensorIteratorDateTime = parseDateTime(rawSensorTable.Var1(i));
    rawSensorData(i, 1) = rawSensorIteratorDateTime.Hour * 3600 + rawSensorIteratorDateTime.Minute * 60 + rawSensorIteratorDateTime.Second;
    [rawSensorData(i, 2),rawSensorData(i, 3)] = projfwd(kCGCS20003DegreeGKCM114EProjcrs,rawSensorTable.Var34(i),rawSensorTable.Var33(i));
    if mod(i,200) == 0
        logSpec = '%s Itetator: %d\n';
        fprintf(logSpec,logTimestamp(),i)
    end
end

plotTs = rawSensorData(:,1) - rawSensorData(1,1);
xLimMin = floor(plotTs(1));
xLimMax = ceil(plotTs(end));
xLim = [xLimMin xLimMax]; 
rawSensorAccelerometer = rawSensorTable{:, 2:4};
rawSensorGyroscope = rawSensorTable{:, 5:7};

rawSensorCoordinate = rawSensorData(:,2:3);
plotSensorCoordinate = rawSensorCoordinate - rawSensorCoordinate(1,:);
figure;
plot(plotSensorCoordinate(:,1), plotSensorCoordinate(:,2));

figure();
subplotRow = 2;
subplotColumn = 1;

subplot(subplotRow,subplotColumn,1);
plot(plotTs, rawSensorGyroscope(:,1), 'Color', 'red');
hold on;
plot(plotTs, rawSensorGyroscope(:,2), 'Color', 'green');
plot(plotTs, rawSensorGyroscope(:,3), 'Color', 'blue');
xlim(xLim)
title('Gyroscope')
hold off;

subplot(subplotRow,subplotColumn,2);
plot(plotTs, rawSensorAccelerometer(:,1), 'Color', 'red');
hold on;
plot(plotTs, rawSensorAccelerometer(:,2), 'Color', 'green');
plot(plotTs, rawSensorAccelerometer(:,3), 'Color', 'blue');
xlim(xLim)
title('Accelerometer')
hold off;





