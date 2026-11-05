% 载入EMG数据
filePath = 'LOCAL_INPUT_FILE';
y = readmatrix(filePath);

% 定义传感矩阵A的大小
M = length(y); % 测量值数量
N = 43000;     % 假设的原信号长度
A = randn(M, N); % 随机生成传感矩阵A

% 定义稀疏度t
t = 100; % 假设的稀疏度

% 调用CS_OMP函数
theta = modified_CS_OMP(y, A, t);

% 显示或保存结果
disp('恢复信号theta计算完成。');
% 可以选择将结果保存到.mat文件中
save('recovered_signal.mat', 'theta');