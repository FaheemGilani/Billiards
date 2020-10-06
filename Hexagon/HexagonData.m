function period=HexagonData(nmat,k)
% flag=precision;

%%Initial X and Y. Recall y>x
tic
x=zeros(length(nmat),k);
y=zeros(length(nmat),k);

for i=1:length(nmat)
    x(i,:)=nmat(i)*ones(1,k);
end

x=x';
x=x(:)';
for i=1:length(nmat)
ytemp=[];

m=1;
%m=u;
while (length(ytemp)<k)
    m=m+1;
    if gcd(m,nmat(i))==1
        ytemp=[ytemp,m];
    end
end
y(i,:)=ytemp;
end

y=y';
y=y(:)';


init=[x;y];









period=zeros(length(init),2);

% delete(gcp('nocreate'))
% parpool(5)
for i=1:length(init)
    eps=1-(init(1,i)/(3*init(2,i)));
    epss=10^(-4);
    temp1=Hexagon(init(:,i),eps+epss);
    temp2=Hexagon(init(:,i),eps-epss);
%     period(i,:)=(1/2)*[temp1+temp2+abs(temp1-temp2),temp1+temp2-abs(temp1-temp2)];
    period(i,:)=[temp1,temp2];

end

% i=1;
% while i<=length(init)
% while (mod(init(1,i),3)==0)&&(i<=length(init)) 
%     eps=rand;
%     temp=Hexagon(init(:,i),eps);
%     if temp>1
%         period(i,:)=[temp 0];
%         i=i+1;
%     end
% end
% 
% 
% 
% while (mod(init(1,i),3)>0)&&(i<=length(init))
%     eps1=rand;
%     eps2=rand;
%     temp1=Hexagon(init(:,i),eps1);
%     temp2=Hexagon(init(:,i),eps2);
%     A=nonzeros(unique([temp1,temp2]));
% 
%     if (length(A)==2)
%         period(i,1)=max(A);
%         period(i,2)=min(A);
%         i=i+1;
%     end
% end
% end
% 
% 
% % epsilon=-.9:.01:.9;
% % temp=zeros(length(init),length(epsilon));
% % 
% % for i=1:length(init)
% %     for j=1:length(epsilon)
% %         temp(i,j)=Hexagon(init(:,i),epsilon(j));
% %     end
% % end
% % 
% % for i=1:length(init)
% %     A=nonzeros(unique(temp(i,:)));
% %     if length(A)==1
% %         period(i,1)=A;
% %     elseif length(A)==2
% %         period(i,1)=min(A);
% %         period(i,2)=max(A);
% %     end
% % end
% 
% 
 period=[init',period];

toc
