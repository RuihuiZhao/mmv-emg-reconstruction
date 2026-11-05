%% OMP_MMV funtion
% input   :  Y          ：观测向量；
%            J          ：迭代次数 ；
%            p          : p范数（p>=1）,用来对矩阵某一行进行P norm 约束；
% output  : hat_y       : 重构MMV矢量；
%           hat_y_norm  :对 hat_y 进行 p norm 约束的一维矢量；
% 参考文献 ：J. Chen and X. Huo. Theoretical results on sparse representations of multiple-measurement vectors. IEEE Trans. Signal Process.,2006, 54(12): 4634–4643.
%%
function [hat_y,hat_y_norm] = OMP_MMV(Y,A,J,p)
     [m,n]  = size(A);                                      %  测量矩阵的大小，需要用到变量n,即A的列数  
     [m,n1] = size(Y);                                      %  需要用到变量n,即Y的列数
      Aug_t = [];                                           % 扩充矩阵     
      R     = Y;                                            % 初始余量
      hat_y = zeros(n,n1);
     for times = 1:J;                                          %  迭代次数
         for    col = 1:n;                                     %  恢复矩阵的所有列向量
            product(col) = norm(R'*A(:,col),p);                     %  恢复矩阵的列向量和残差的投影系数(内积值) 
          end
         [val,pos]        = max(product);                           %  最大投影系数对应的位置
         Aug_t            = [Aug_t,A(:,pos)];                       %  矩阵扩充
         aug_y            = (Aug_t'*Aug_t)^(-1)*Aug_t'*Y;           %  最小二乘,使残差最小
         R                = Y-Aug_t*aug_y;                          %  残差，余量
         pos_array(times) = pos;                                    %  记录最大投影系数的位置
     end
     for k=1:J
         hat_y(pos_array(k),:) = aug_y(k,:);                             %  重构的向量
     end
      for m=1:n
         x(m) = norm(hat_y(m,:),p);                      % 对 hat_y 进行 p norm 约束的一维矢量；
      end
      hat_y_norm = x;
