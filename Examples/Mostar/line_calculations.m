U1 = 0.9704;
U2 = 0.962975;
P1 = 0.1673; 
Q1 = 0.0737;
Q2 =0.573;%= 0.4902; 

phi1 = 1.025765/180*pi; 

phi2 = asin(1/1.05*sin(phi1));

Xe = 1/Q2*((1.05*U1)^2-1.05*U1*U2*cos(phi2))

Q11 = (U1^2 - U1*U2*cos(phi1))/Xe;
Q22 = ((1.05*U1)^2 - 1.05*U1*U2*cos(phi1))/Xe;

Q11_2 =  ((U2)^2 - U1*U2*cos(phi1))/Xe

P11 = U1*U2/Xe*sin(phi1);
P22 = 1.05*U1*U2/Xe*sin(phi2);
%%
U1 = 0.9704;
%U2 = 0.962975;
P1 = 0.1673; 
Q1 = 0.0737;
Q2 =0.573;%= 0.4902; 
phi1 = 1.3/180*pi; 


U2 = (Q1/Q2*1.05*U1-U1)/(Q1/Q2*sqrt(1.05^2-cos(phi1))-cos(phi1)); 

Xe = U1*U2/P1*sin(phi1); 

%%
Q1 = 0.0737;
Q2 =0.5;
U1 = 0.9704;
U2 = 0.962975;

syms x; 

syms a b c; 

eqn = U1*(Q1/Q2*1.05^2-1)==Q1/Q2*1.05*U2*sqrt(0.1025-x^2)-U2*x; 


eqn = a/b==sqrt(0.1025-x^2)-c*x;

sol = solve(eqn,x)

sol = subs(sol, a, U1*(Q1/Q2*1.05^2-1));
sol = subs(sol,b,Q1/Q2*1.05*U2); 
sol = subs(sol,c,U2)

%%
% Q1 = 0.0737;
% Q2 =0.5;
% U1 = 0.9704;
% U2 = 0.962975;

syms Xe phi1 phi2 Q1 Q2 U1 U2; 

eqn1 = sin(phi1) == 1.05*sin(phi2); 
eqn2 = Q1 == 1/Xe*(U1^2-U1*U2*cos(phi1)); 
eqn3 = Q2 == 1/Xe*((1.05*U1)^2-1.05*U1*U2*cos(phi2)); 

solve([eqn1 eqn2 eqn3], Xe,phi1,phi2)

%%
U1 = 0.97042; 
Q1 = 0.07788; 
Q2 = 0.573;
Qline1=Q1/2;
Qline2= 16.0411/30; 

Xl = U1^2*(1-1.05^2)/(Q1/2-Q2+Qline2);

Qconst = Q1/2-U1^2/abs(Xl); 

Qconst_MVAR = Qconst*30 
Qshut_MVAR = U1^2/abs(Xl)*30

%%

U1 = 0.97042;
U2 = 0.965;
Q1 = 0.07788; 
Q2 = 0.50;

Xl = (U1^2*(1-1.05^2)-U1*U2*(1-1.05))/(Q1-Q2);

Xl = U1^2*((1.05^2-1.05)/(Q2-1.05*Q1))

U2 = (U1^2-Q1*Xl)/U1

Q22 = ((1.05*U1)^2-1.05*U1*U2)/Xl

Q11 = (U1^2-U1*U2)/Xl

%%
for (U2=0.91:0.0001:0.97)
for (Xl=0.0001:0.0001:10)

Q22 = ((1.05*U1)^2-1.05*U1*U2)/Xl;

Q11 = (U1^2-U1*U2)/Xl;

if  (Q11 < 0.078) && (Q11>0.076) && (Q22<0.58) && (Q22>0.57)
    Q11
    Q22
    Xl
    break;
end
end
end
