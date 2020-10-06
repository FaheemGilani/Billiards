nmat=1:1:20;
k=10;

period=HexagonData(nmat,k);






degrees=[30 60];
theta1=deg2rad(degrees(1));
theta2=deg2rad(degrees(2));


PERIOD=period(period(:,2)>= period(:,1)*tan(theta1)/sqrt(3),:);
PERIOD=PERIOD(PERIOD(:,2)<= PERIOD(:,1)*tan(theta2)/sqrt(3),:);
rad2deg(atan((PERIOD(:,2)./PERIOD(:,1))*sqrt(3)))