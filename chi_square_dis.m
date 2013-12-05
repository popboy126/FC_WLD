%用于计算chi-square distances
function f=chi_square_dis(Hn,H0)
    [row col]=size(H0);  %获得矩阵大小
    t=row*col;
    all=0;
    for i=1:t   %开始计算
        t1=(H0(i)-Hn(i))^2;
        t2=H0(i)+Hn(i)+1;
        all=all+t1/t2;
    end
    f=all;%返回距离
end
