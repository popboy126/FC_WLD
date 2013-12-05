function f=classifyEpcl(x)
    if (x>=(-0.5*pi)) & (x<(-0.3*pi))
        f=1;
    elseif x>=-0.3*pi & x<-0.15*pi
        f=2;
    elseif x>=-0.15*pi & x<-0.05*pi
        f=3;
    elseif x>=-0.05*pi & x<0
        f=4;
    elseif x>=0 & x<0.05*pi
        f=5;
    elseif x>=0.05*pi & x<0.15*pi
        f=6;
    elseif x>=0.15*pi & x<0.25*pi
        f=7;
    else
        f=8;
    end    
end
