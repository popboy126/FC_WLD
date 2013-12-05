function f=classifyFai(x)
    if x>=0 & x<0.15*pi
        f=1;
    elseif x>=0.15*pi & x<0.35*pi
        f=2;
    elseif x>=0.35*pi & x<0.5*pi
        f=3;
    elseif x>=0.5*pi & x<0.65*pi
        f=4;
    elseif x>=0.65*pi & x<0.85*pi
        f=5;
    elseif x>=0.85*pi & x<pi
        f=6;
    elseif x>=pi & x<1.15*pi
        f=7;
    elseif x>=1.15*pi & x<1.35*pi
        f=8;
    elseif x>=1.35*pi & x<1.5*pi
        f=9;
    elseif x>=1.5*pi & x<1.65*pi
        f=10;
    elseif x>=1.65*pi & x<1.85*pi
        f=11;
    else
        f=12;
    end
end
