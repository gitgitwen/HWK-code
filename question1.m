clc;clear;
%% 准备

data = readtable('question1.xlsx');
time_in_hours = data.N_i * 24;  % 将十进制时间转换为小时
time_in_minutes = mod(time_in_hours, 1) * 60;  % 计算分钟
time_in_hours = floor(time_in_hours);  % 获取小时部分

% 处理进位情况
for i = 1:length(time_in_hours)
    if time_in_minutes(i) >= 60
        time_in_hours(i) = time_in_hours(i) + floor(time_in_minutes(i) / 60);
        time_in_minutes(i) = mod(time_in_minutes(i), 60);
    end
end
%% 开始
% 创建时间字符串
time_labels = strcat(string(time_in_hours), ':', sprintf('%02d', round(time_in_minutes))); % 确保分钟格式为两位数

% 创建一个新的时间序列，以30分钟为步长
time_series = datetime(0, 1, 1, 0, 0, 0):minutes(30):datetime(0, 1, 1, 23, 30, 0);
time_labels_series = strcat(datestr(time_series, 'HH:MM'));

% 计算每个时间点的客流量
volume_series = zeros(length(time_labels_series), 1);
for i = 1:length(time_labels_series)
    if i <= length(time_labels)
        volume_series(i) = data.volume(i);
    end
end

% 绘柱状图
figure;
bar(time_series, volume_series(1:length(time_series)), 'FaceColor', [233/255, 205/255, 223/255]);  
set(gca, 'XTick', time_series, 'XTickLabel', time_labels_series, 'XTickLabelRotation', 30);  
xlabel('Time', 'FontSize', 14); 
ylabel('Volume', 'FontSize', 14); 
set(gca, 'FontSize', 12);  
grid on; 
