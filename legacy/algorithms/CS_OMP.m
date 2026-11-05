function [theta] = modified_CS_OMP(filePath, A, t)
% 导入EMG数据并使用压缩感知正交匹配追踪算法(CS_OMP)恢复信号
% 输入:
%   filePath - EMG.xlsx文件的路径
%   A - 传感矩阵
%   t - 稀疏度
% 输出:
%   theta - 恢复的信号

% 使用readmatrix直接读取Excel文件中的数值数据
y = readmatrix(filePath);

% 确保y是列向量
[y_rows, y_columns] = size(y);
if y_rows < y_columns
    y = y'; % 如果不是，转置它
end

% CS_OMP算法实现
[M,N] = size(A); % 传感矩阵A为M*N矩阵
theta = zeros(N,1); % 用来存储恢复的theta(列向量)
At = zeros(M,t); % 用来迭代过程中存储A被选择的列
Pos_theta = zeros(1,t); % 用来迭代过程中存储A被选择的列序号
r_n = y; % 初始化残差(residual)为y
for ii = 1:t % 迭代t次，t为输入参数
    product = A'*r_n; % 传感矩阵A各列与残差的内积
    [~, pos] = max(abs(product)); % 找到最大内积绝对值，即与残差最相关的列
    At(:,ii) = A(:,pos); % 存储这一列
    Pos_theta(ii) = pos; % 存储这一列的序号
    theta_ls = (At(:,1:ii)'*At(:,1:ii))^(-1)*At(:,1:ii)'*y; % 最小二乘解
    r_n = y - At(:,1:ii)*theta_ls; % 更新残差        
end
theta(Pos_theta) = theta_ls; % 恢复出的theta
end

% 现在调用函数的例子
% 定义A矩阵和稀疏度t
A =10 ...; % 您需要根据您的应用来定义A
t =1000 ...; % 定义稀疏度t，它是一个正整数

% 指定EMG.xlsx文件的完整路径
filePath = 'LOCAL_INPUT_FILE';

% 调用函数
theta = modified_CS_OMP(filePath, A, t);
