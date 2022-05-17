function parsedDateTime = parseDateTime(dateTimeString)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
if iscell(dateTimeString)
    dateTimeString = dateTimeString{1,1};
end
dateTimeStringLength = length(dateTimeString);
if dateTimeStringLength == 25
    parsedDateTime = datetime(dateTimeString,'InputFormat','yyyy-MM-dd HH:mm:ss+08:00','TimeZone','Asia/Shanghai');
else
    parsedDateTime = datetime(dateTimeString,'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS+08:00','TimeZone','Asia/Shanghai');
end
end

