function in=segline(x,y)
    p=x(:,1);
    r=x(:,2)-x(:,1);
    p=p+10^(-14)*r;
    q=y(:,1);
    s=y(:,2)-y(:,1);
    d=xoss(r,s);
    t=xoss(q-p,s);
    u=xoss(q-p,r);

%     if (u==0) || (t==d) || (u==d)
%         in=666;
%         return
%     end
%     
    if d==0
        in=100;
    elseif (0<t/d)&&(t/d<=1)&&(0<u/d)&&(u/d<=1)
            in=p+(t/d)*r;

    else
            in=100;
    end
end
    
    
 function c=xoss(a,b)
     c=a(1)*b(2)-a(2)*b(1);
 end