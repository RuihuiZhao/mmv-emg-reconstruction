clear all;
close all;
clc;

% 从Excel文件中读取观测矩阵Y
filePath = 'LOCAL_INPUT_FILE';
D = xlsread(filePath);
Y = D(:, 1:2); % 假设观测矩阵Y位于文件的前四列

[m,n] = size(Y);

% 假设的信号长度、迭代次数和p范数
N = 3072; % 信号长度
M = 1536; % 观测值个数，可以是Y的一个子集或其他适当值
J = 1000; % 迭代次数
p = 2; % p范数

% 构建测量矩阵A
Phi = randn(M,N);
Psi = dctmtx(N)/sqrt(N); % 使用离散余弦变换矩阵作为稀疏基
A = Phi * Psi;

% 执行OMP_MMV函数，这里需要您提供OMP_MMV的实现
[hat_y, hat_y_norm] = OMP_MMV1(Y(1:M, :), A, J, p);

% 重构信号
D_r = Psi * hat_y;

% 为原始信号和重构信号创建时间向量
original_time = linspace(1, m, m);
reconstructed_time = linspace(1, m, N);

% 对重构信号D_r进行插值，以匹配原始信号Y的长度
D_r_interp = zeros(m, n); % 初始化插值后的信号矩阵   %在这个代码中，使用了 interp1 函数来对 D_r 的每一列进行线性插值，以匹配 Y 的长度。
for i = 1:n
    D_r_interp(:, i) = interp1(reconstructed_time, D_r(:, i), original_time, 'linear', 'extrap');%'linear' 表示使用线性插值方法，而 'extrap' 允许在 reconstructed_time 范围之外进行外推。
end

% 计算插值后的重构信号的信噪比(SNR)
SNR = 20*log10(norm(Y, 'fro') / norm(Y - D_r_interp, 'fro'));
fprintf('插值后的重构信号的信噪比(SNR)：%f dB\n', SNR);

