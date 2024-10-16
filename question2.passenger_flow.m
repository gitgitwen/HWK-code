% 清空环境
clear;
clc;

% 读取OD矩阵（18x18）从 '1.xlsx' 文件
OD = readmatrix('question2_OD.matrix.xlsx');

% 获取矩阵的大小
[m, n] = size(OD);
if m ~= n
    error('OD矩阵必须是方阵');
end
if m ~= 18
    warning('OD矩阵的大小不是18x18，请确认数据是否正确。');
end

% 定义站点名称（假设为小写字母a, b, c,..., r）
stationNames = cell(1, m);
for i = 1:m
    stationNames{i} = char('a' + i - 1);
end

% 初始化断面客流向量
sectionFlow = zeros(1, m-1);

% 计算每一断面客流
for k = 1:(m-1)
    % 直接流量：从第k站到第k+1站及其后续站点的OD流量之和
    directFlow = sum(OD(k, (k+1):m));
    
    % 上游流量：
    % 如果k不是第一个站点，则需要加上所有前面站点到第k+1站及其后续站点的OD流量之和
    if k == 1
        upstreamFlow = 0; % 当k=1时，没有前面的站点
    else
        upstreamFlow = sum(sum(OD(1:(k-1), (k+1):m)));
    end
    
    % 总断面客流
    totalFlow = directFlow + upstreamFlow;
    
    % 四舍五入
    sectionFlow(k) = round(totalFlow);
end

% 设置输出格式为不使用科学计数法
format long g;

% 显示断面客流结果
fprintf('断面客流结果：\n');
for k = 1:(m-1)
    fromStation = stationNames{k};
    toStation = stationNames{k+1};
    fprintf('%s~%s：%d\n', fromStation, toStation, sectionFlow(k));
end

%% 绘制断面客流量分布图

% 定义断面名称（例如 'a~b', 'b~c', ..., 'q~r'）
sectionNames = cell(1, m-1);
for k = 1:(m-1)
    sectionNames{k} = sprintf('%s~%s', stationNames{k}, stationNames{k+1});
end

% 创建图形窗口
figure('Color', 'w'); % 设置背景为白色

% 定义指定的RGB颜色 (233, 205, 223) 并归一化
specifiedColor = [233, 205, 223] / 255;

% 定义x轴数据
x = 1:(m-1);
y = sectionFlow;

% 使用 stairs 函数绘制横平竖直的折线图（阶梯图）
hold on;
for k = 1:(m-2)
    % 画水平线段
    plot([x(k), x(k+1)], [y(k), y(k)], 'LineWidth', 2, 'Color', specifiedColor); % 水平线
    % 画竖直线段
    plot([x(k+1), x(k+1)], [y(k), y(k+1)], 'LineWidth', 2, 'Color', specifiedColor); % 竖直线
end

% 绘制最后一个点的水平线
plot([x(end-1), x(end)], [y(end-1), y(end-1)], 'LineWidth', 2, 'Color', specifiedColor);

% 设置x轴
xticks(x);
xticklabels(sectionNames);
xtickangle(45); % 旋转x轴标签以便更好的显示

% 设置y轴
ylabel('Cross-sectional passenger flow', 'FontSize', 12, 'FontWeight', 'bold');

% 设置x轴
xlabel('Station', 'FontSize', 12, 'FontWeight', 'bold');

% 添加网格
grid on;
grid minor;

% 调整图形的字体和大小
set(gca, 'FontSize', 10, 'FontWeight', 'bold');

% 优化图形布局
set(gcf, 'Position', [100, 100, 1200, 600]); % 设置图形窗口大小

% 显示数据标签
for k = 1:(m-1)
    text(x(k), y(k) + max(y) * 0.01, num2str(y(k)), ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
        'FontSize', 10, 'FontWeight', 'bold');
end

% 保持图形
hold off;
