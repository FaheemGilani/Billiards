function []=plotpath(n,point)
xhex=[0 1 1 0 -1 -1 0];
s=sqrt(3)/3;
yhex=[0 s 3*s 4*s 3*s s 0];
kk=n;
mapshow(xhex,yhex)
for i=1:kk-1
mapshow([point(1,i) point(1,i+1)],[point(2,i) point(2,i+1)]);
hold on
end
% i=kk;
% mapshow([point(1,i) point(1,i+1)],[point(2,i) point(2,i+1)],'LineWidth',5);
% i=kk+1;
% mapshow([point(1,i) point(1,i+1)],[point(2,i) point(2,i+1)],'LineWidth',5);
xlim([-1.2,1.2]);
mapshow(point(1,2),point(2,2),'DisplayType','point','Marker','o')
mapshow(point(1,end-3),point(2,end-3),'DisplayType','point','Marker','o')
end
%'DisplayType','point','Marker','o')