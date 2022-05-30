function parsedDateTime = parseDateTime(dateTimeString)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
if iscell(dateTimeString)
    dateTimeString = dateTimeString{1,1};
end
dateTimeStringLength = length(dateTimeString);
if dateTimeStringLength == 25
    % https://ww2.mathworks.cn/help/matlab/ref/datetime.html?lang=en
    % Date and Time from Text with Literal Characters
    parsedDateTime = datetime(dateTimeString,'InputFormat','yyyy-MM-dd HH:mm:ss+08:00','TimeZone','Asia/Shanghai');
elseif dateTimeStringLength == 32
    parsedDateTime = datetime(dateTimeString,'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS+08:00','TimeZone','Asia/Shanghai');
elseif dateTimeStringLength == 35
    parsedDateTime = datetime(dateTimeString,'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSSSSS+08:00','TimeZone','Asia/Shanghai');
end
end

