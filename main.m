r0=[0.1 0.05];
A=[]; %Ax<=B,沒有線性不等式拘束條件
B=[]; %同上
Aeq=[]; %Ax=B,沒有線性等式拘束條件
Beq=[]; %同上
ub=[0.5 0.5]; %半徑r1、r2的最大值為0.5m
lb=[0.001 0.001]; %半徑r1、r2的最小值為0.001m
options=optimset("display","off","Algorithm","sqp"); %設定參數及指定sqp演算法
[x,fval,exitflag]=fmincon(@(r)obj(r),r0,A,B,Aeq,Beq,lb,ub,...
    @(r)nonlcon(r),options); %呼叫兩個副程式，並執行fmincon