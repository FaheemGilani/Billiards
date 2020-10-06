%%Doesnt work for period 2. IDK what happens when it hits boundary

function [period,sequence]=Hexagon(initial,epsilon)

flag=0;
%%Hexagon Definition
xhex=[0 1 1 0 -1 -1 0];
s=sqrt(3)/3;
yhex=[0 s 3*s 4*s 3*s s 0];

%%Initial Angle and Position
theta=atan((initial(2)/initial(1))*sqrt(3));
% 
% if (theta<pi/3)||(theta>pi/2)
%     disp('Ensure Initial Angle is in the Valid Range')
%     period=0;
%     return
% end

init=[0 2*s]';
init=init+[epsilon; 0];
point=[init,[cos(theta)+init(1); sin(theta)+init(2)]];

%%Number of Bounces to Consider and error tolerance
% kk=500;
tol=10^(-4);
sequence=[];

% for n=1:kk

n=0;
while 1==1
     n=n+1;
     i=1;
     nv=(point(:,n+1)-point(:,n))/norm(point(:,n+1)-point(:,n));
     P=[[point(1,n) point(1,n)+10*nv(1)];[point(2,n) point(2,n)+10*nv(2)]];

  
    while (length(segline(P,[xhex([i i+1]); yhex([i i+1])]))==1)
        i=i+1;
        if i==7
%             period=n-1;
              period=0; 
            if flag==1
            plotpath(n-1,point);
            end
        return
        end

    end
    


 a = segline(P,[xhex([i i+1]);yhex([i i+1])]);
%     if a==666
%         period=n;
%         if flag==1
%         plotpath(n,point);
%         end
%         return
%     end
%         
   
    point(1,n+1)=a(1);
    point(2,n+1)=a(2);


    point(:,n+2)=point(:,n+1)-bounce(nv,i);
    if (n>4)&&(double(norm(point(:,n-1)-point(:,2)))<tol)&&(double(norm(point(:,n)-point(:,3)))<tol)&&(double(norm(point(:,n+1)-point(:,4)))<tol)
        period=n-3;
        if flag==1
        plotpath(n,point);
        end
        
        return
    end
% 
% disp(double(norm(point(:,n)-point(:,2)))); 
% disp(double(norm(point(:,n+1)-point(:,3))));
if i<4
    sequence=[sequence;i];
else
    sequence=[sequence;i-3];
end
end

if flag==1
    plotpath(n,point);
    period=n-2;
end










