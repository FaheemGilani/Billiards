function A=mods(group,a,b,k)

for i=[6 10]
    mod(a*b*group(i).data(1:10,2).*group(i).data(1:10,1),k)
end
A=0;
end
