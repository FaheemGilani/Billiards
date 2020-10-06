function vnew=bounce(v,i)

pivpa=pi;
beta=[pivpa/6 pivpa/2 5*pivpa/6 7*pivpa/6 3*pivpa/2 11*pivpa/6];

beta=beta(i);
Rinv=[cos(-beta) -sin(-beta); sin(-beta) cos(-beta)];
R=[cos(beta) -sin(beta); sin(beta) cos(beta)];
Ref=[-1 0; 0 1];

vnew=R*Ref*Rinv*v;


