r0=[0.1 0.05];
A=[];
B=[];
Aeq=[];
Beq=[];
ub=[0.5 0.5];
lb=[0.001 0.001];
options=optimset("display","off","Algorithm","sqp");
[x,fval,exitflag]=fmincon(@(r)obj(r),r0,A,B,Aeq,Beq,lb,ub,...
    @(r)nonlcon(r),options);