%用于计算WLD
function value=WLD(subImage)
%用于计算H的矩阵
    f1=[1,1,1;1,-8,1;1,1,1];
    f2=[0,0,0;0,1,0;0,0,0];
    f3=[1,2,1;0,0,0;-1,-2,-1];
    f4=[1,0,-1,2,0,-2,1,0,-1];

    v1=filter2(f1,subImage);
    v2=filter2(f2,subImage);
    [row col]=size(v1);
    Epcl=zeros(1,8);%用于存放Epcl
    for i=1:row
        for j=1:col
            a(i,j)=atan(v1(i,j)/v2(i,j));%计算a
            k=classifyEpcl(a(i,j));
            Epcl(k)=Epcl(k)+1;
        end
    end
    
    %下面计算梯度
    v3=filter2(f3,subImage);
    v4=filter2(f4,subImage);
    Fai=zeros(1,12);
    for i=1:row
        for j=1:col
            Theta(i,j)=atan(v3(i,j)/v4(i,j));%计算a
            if v3(i,j)>0 && v4(i,j)>0
                ;
            elseif v3(i,j)>0 && v4(i,j)<0
                Theta(i,j)=Theta(i,j)+2*pi;
            else
                Theta(i,j)=Theta(i,j)+pi;
            end
            k=classifyFai(Theta(i,j));
            Fai(k)=Fai(k)+1;
        end
    end
    wld_2D=Epcl'*Fai;
    value=wld_2D(:)';
end

