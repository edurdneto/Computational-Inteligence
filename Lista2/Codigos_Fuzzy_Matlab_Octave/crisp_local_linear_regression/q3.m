data=load('data.dat');
x = data(:,2);
y = data(:,1);

pol=polyfit(x,y,8);
ypp = polyval(pol,x);
plot(x,y,'o',x,ypp);