function [outputArg1,outputArg2] = analyzeGyroscopeSensorData(rawDataGyroscope,rawDataGyroscopeUncalibrated)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
cPlotConfig = 2;

NANO2SEC = 1 / 1e09;

rawTimestampNanosecondAxis = rawDataGyroscope(:,1);
rawTimestampSecondAxis = rawDataGyroscope(:,1) .* NANO2SEC;
rawTimestampSecondHead = rawTimestampSecondAxis(1,1);
referenceTimestampSecond = ceil(rawTimestampSecondHead);
referenceTimestampSecondAxis = rawTimestampSecondAxis - referenceTimestampSecond;
referenceTimestampSecondHeadIndex = find(referenceTimestampSecondAxis == 0);

rawTimestampNanosecondAxislength = length(rawTimestampNanosecondAxis);
plotTimestampSecondDurationIndex = referenceTimestampSecondHeadIndex:rawTimestampNanosecondAxislength;
plotTimestampSecondAxis = referenceTimestampSecondAxis(plotTimestampSecondDurationIndex,1);
plotDataGyroscope = rawDataGyroscope(plotTimestampSecondDurationIndex,:);
plotDataGyroscopeUncalibrated = rawDataGyroscopeUncalibrated(plotTimestampSecondDurationIndex,:);

if cPlotConfig == 1
    figure();
    subplot(2,3,1);
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,2), 'Color', 'red');
    hold on;
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,3), 'Color', 'green');
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,4), 'Color', 'blue');
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,2), 'Color', 'red', 'LineStyle', '--');
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,3), 'Color', 'green', 'LineStyle', '--');
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,4), 'Color', 'blue', 'LineStyle', '--');
    title('Sensor ALL')
    hold off;
    
    subplot(2,3,2);
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,2), 'Color', 'red');
    hold on;
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,3), 'Color', 'green');
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,4), 'Color', 'blue');
    title('TYPE\_GYROSCOPE')
    hold off;
    
    subplot(2,3,3);
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,2), 'Color', 'red');
    hold on;
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,3), 'Color', 'green');
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,4), 'Color', 'blue');
    title('TYPE\_GYROSCOPE\_UNCALIBRATED')
    hold off;
    
    subplot(2,3,4);
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,2), 'Color', 'red');
    hold on;
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,2), 'Color', 'red', 'LineStyle', '--');
    title('X')
    hold off;
    
    subplot(2,3,5);
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,3), 'Color', 'green');
    hold on;
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,3), 'Color', 'green', 'LineStyle', '--');
    title('Y')
    hold off;
    
    subplot(2,3,6);
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,4), 'Color', 'blue');
    hold on;
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,4), 'Color', 'blue', 'LineStyle', '--');
    title('Z')
    hold off;
elseif (cPlotConfig == 9)
    figure('name', 'Sensor TYPE_GYROSCOPE');
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,2), 'Color', 'red');
    hold on;
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,3), 'Color', 'green');
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,4), 'Color', 'blue');
    hold off;
    
    figure('name', 'Sensor TYPE_GYROSCOPE_UNCALIBRATED');
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,2), 'Color', 'red');
    hold on;
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,3), 'Color', 'green');
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,4), 'Color', 'blue');
    hold off;
    
    figure('name', 'Sensor TYPE_GYROSCOPE and TYPE_GYROSCOPE_UNCALIBRATED');
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,2), 'Color', 'red');
    hold on;
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,3), 'Color', 'green');
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,4), 'Color', 'blue');
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,2), 'Color', 'red', 'LineStyle', '--');
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,3), 'Color', 'green', 'LineStyle', '--');
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,4), 'Color', 'blue', 'LineStyle', '--');
    hold off;
    
    figure('name', 'Sensor TYPE_GYROSCOPE and TYPE_GYROSCOPE_UNCALIBRATED x');
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,2), 'Color', 'red');
    hold on;
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,2), 'Color', 'red', 'LineStyle', '--');
    hold off;
    
    figure('name', 'Sensor TYPE_GYROSCOPE and TYPE_GYROSCOPE_UNCALIBRATED y');
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,3), 'Color', 'green');
    hold on;
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,3), 'Color', 'green', 'LineStyle', '--');
    hold off;
    
    figure('name', 'Sensor TYPE_GYROSCOPE and TYPE_GYROSCOPE_UNCALIBRATED z');
    plot(plotTimestampSecondAxis, plotDataGyroscope(:,4), 'Color', 'blue');
    hold on;
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,4), 'Color', 'blue', 'LineStyle', '--');
    hold off;
    
    figure('name', 'Sensor TYPE_GYROSCOPE_UNCALIBRATED - TYPE_GYROSCOPE x');
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,2)-plotDataGyroscope(:,2), 'Color', 'red');
    
    figure('name', 'Sensor TYPE_GYROSCOPE_UNCALIBRATED - TYPE_GYROSCOPE y');
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,3)-plotDataGyroscope(:,3), 'Color', 'green');
    
    figure('name', 'Sensor TYPE_GYROSCOPE_UNCALIBRATED - TYPE_GYROSCOPE z');
    plot(plotTimestampSecondAxis, plotDataGyroscopeUncalibrated(:,4)-plotDataGyroscope(:,4), 'Color', 'blue');
end

iniGyroscopeUncalibratedBiasHeadTimestampSecond = 0;
iniGyroscopeUncalibratedBiasTailTimestampSecond = 3.5;
iniGyroscopeUncalibratedBiasClippedLowerBound = plotTimestampSecondAxis >= iniGyroscopeUncalibratedBiasHeadTimestampSecond;
iniGyroscopeUncalibratedBiasClippedUpperBound = plotTimestampSecondAxis <= iniGyroscopeUncalibratedBiasTailTimestampSecond;
iniGyroscopeUncalibratedBiasClipped = plotDataGyroscopeUncalibrated(iniGyroscopeUncalibratedBiasClippedLowerBound & iniGyroscopeUncalibratedBiasClippedUpperBound, :);
iniGyroscopeUncalibratedBias = mean(iniGyroscopeUncalibratedBiasClipped(:,2:4), 1);

endGyroscopeUncalibratedBiasHeadTimestampSecond = 170.5;
endGyroscopeUncalibratedBiasTailTimestampSecond = 171.5;
endGyroscopeUncalibratedBiasClippedLowerBound = plotTimestampSecondAxis >= endGyroscopeUncalibratedBiasHeadTimestampSecond;
endGyroscopeUncalibratedBiasClippedUpperBound = plotTimestampSecondAxis <= endGyroscopeUncalibratedBiasTailTimestampSecond;
endGyroscopeUncalibratedBiasClipped = plotDataGyroscopeUncalibrated(endGyroscopeUncalibratedBiasClippedLowerBound & endGyroscopeUncalibratedBiasClippedUpperBound, :);
endGyroscopeUncalibratedBias = mean(endGyroscopeUncalibratedBiasClipped(:,2:4), 1);


outputArg1 = iniGyroscopeUncalibratedBias;
outputArg2 = endGyroscopeUncalibratedBias;

end

