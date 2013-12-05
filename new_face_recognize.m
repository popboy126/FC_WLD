%此识别方法为借鉴湖南大学李树涛教授的相关方法
%@2013.12.04

clear all;
clc;

%定义相关数据集合特征
group_num=3;%样本组数
group_member=10; %组内成员个数

max_train_num=1;%最大训练样本数

GaussianSize=[3 3];%高斯模板阵的大小
Sigma=1;%高斯滤波器方差

%f1和f2用于计算差分激励，即当前点与其邻居点的差异
%f3与f4用于计算梯度
f1=[1,1,1;1,-8,1;1,1,1];
f2=[0,0,0;0,1,0;0,0,0];
f3=[1,2,1;0,0,0;-1,-2,-1];
f4=[1,0,-1,2,0,-2,1,0,-1];

sub_image_size=[4 2];%不重叠子图片大小

folder='orl/orl';
tmpVec=imread('orl/orl001.bmp');
[row col]=size(tmpVec);%获取图片大小

%figure,imshow(tmpVec),title('original');
%g_template= fspecial('gaussian',GaussianSize,Sigma);
%k=filter2(g_template,tmpVec)/255;%归一化
%figure,imshow(k),title('after');


for i=1:group_num
    for k=1:group_member
        filename=[folder num2str((i-1)*group_member+k,'%03d')  '.bmp'];
        OriginalBase(i,k,:,:)=imread(filename);%原始图像矩阵
    end
end
OriginalBase=double(OriginalBase);%将矩阵变为double类型

g_template= fspecial('gaussian',GaussianSize,Sigma);%生成高斯模板
width=max(sub_image_size);    %求取方框不为正方形时的步长，最长宽最大值,用于求取后面的子图像
subw_n=ceil(row/sub_image_size(1));
subh_n=ceil(col/sub_image_size(2));
for train_num=1:max_train_num
    test_num=group_member-train_num;%测试集数目
    for i=1:group_num
        Hdtemp=zeros((subw_n*subh_n)+(subw_n-2)*(subh_n-2)*(width-1),96);
        for j=1:group_member
            hrows=1;
            %取出的数据先做高斯平滑
            tmpImg(1:row,1:col)=OriginalBase(i,j,:,:);
            %高斯模糊
            tmpImg=filter2(g_template,tmpImg)/255;%归一化
            %subw_n=ceil(row/sub_image_size(1));
            %subh_n=ceil(col/sub_image_size(2));
            fprintf('Dealing with %d group No.%d image...\r\n',i,j);
            for ni=1:subw_n
                for nj=1:subh_n
                    if (ni~=1 && nj~=1 && ni~=subw_n && nj~=subh_n)       %不是边缘块的情况
                        for nk=1:width
                            if nk>sub_image_size(1)  %高比宽小的情况
                                subr=sub_image_size(1);
                            else
                                subr=nk;
                            end

                            if nk>sub_image_size(2) %宽比高小的情况
                                subc=sub_image_size(2);
                            else
                                subc=nk;
                            end
                            %现在开始进行拆分
                            
                            sub_rows=sub_image_size(1)+2*subr;%子图片的行数
                            sub_cols=sub_image_size(2)+2*subc;%子图片的列数
                            left_row=(ni-1)*sub_image_size(1)-subr+1; %最左行位置
                            right_row=ni*sub_image_size(1)+subr;    %最右行位置
                            left_col=(nj-1)*sub_image_size(2)-subc+1;
                            right_col=nj*sub_image_size(2)+subc;
                            subImage=tmpImg(left_row:right_row,left_col:right_col);
                            %disp(subImage(:,:));
                            H(hrows,:)=WLD(subImage(:,:));
                            hrows=hrows+1;
                        end
                    else%为边缘的情况
                        left_row=(ni-1)*sub_image_size(1)+1;
                        right_row=ni*sub_image_size(1);
                        left_col=(nj-1)*sub_image_size(2)+1;
                        right_col=nj*sub_image_size(2);
                        subImage=tmpImg(left_row:right_row,left_col:right_col);
                        H(hrows,:)=WLD(subImage(:,:));
                        hrows=hrows+1;
                    end
                    
                end
            end
            
            if j<=train_num
                Hdtemp=Hdtemp+H;  
            else%为测试集
                H0(i,j-train_num,:,:)=H; %get the test feature vectors
            end 
        end
        Hd(i,:,:)= (Hdtemp/train_num);  %求平均
    end %end for group_num 

    totalInf=zeros(max_train_num,group_member); %record the global recognize information
    %this will classify the test simples
    for i=1:group_num
        info=zeros(1,test_num); %to store the information about the classify
        s=0;
        for j=1:test_num
            m=Inf;
            for k=1:group_num
                %tmpHd=Hd(k,:,:);
                %tmpH0=H0(i,j,:,:);
                sd=chi_square_dis(Hd(k,:,:),H0(i,j,:,:));
                %fprintf('sd:%d\r\n',sd);
                if sd<m %find the min distance and the index
                    m=sd;
                    MinIndex=k;
                end
            end
            if MinIndex==i %record the recognization information
                info(j)=1;
                s=s+1;
            end
        end %end test_num
        totalInf(train_num,i)=s/test_num;  %the error rate
        fprintf('Recongnizing %dth group,s=%d\r\n',i,totalInf(train_num,i));
    end %end for group_num
end
disp(totalInf(:,:));  %display the information

