%Nhập thông số đầu vào
fprintf(‘Thiet ke bo loc chan dai\n’);
fprintf(‘Thong so bo loc:\n’);
d1=input(‘Do gon song: ’);
d2=d1;
pf1=input(‘passband frequency 1: ’);
sf1=input(‘stopband frequency 1: ’);
pf2=input(‘passband frequency 2: ’);
sf2=input(‘stopband frequency 2: ’);
wc1=(pf1+sf1)/2;
wc2=(pf2+sf2)/2;
d=sf1-pf1;
end
fs=3000;
As=20*log(d1);

%Chọn loại cửa sổ và tính bậc của bộ lọc
if(As>-30)
  fprintf(‘Chon cua so chu nhat’);
 window=1;
 n=ceil(4*pi/D);
end
if((As>-49)&&(As<-30))
  fprintf(‘Chon cua so Hanning’);
  window=2;
  n=ceil(8*pi/D);
end
if((As>-63)&&(As<-49))
  fprintf(‘Chon cua so Hamming’);
  window=3;
  n=ceil(8*pi/D);
end
if(As<-63)
  fprintf(‘Chon cua so Blackman’);
  window=4;
  n=ceil(12*pi/D);
end
if(rem(n,2)==0)
 m=n+1;
else
 m=n;
end
fprintf(‘\nBac cu abo loc %0.0f\n’,m);


%Tính đáp ứng xung của cửa sổ

w=zeros(m,1);
if window==1
 for i=1:1:m
    w(i)=1;
end
elseif window==2
 for i=0:1:(m-1)
 w(i+1)=0.5*(1-cos(2*pi*i/(m-1)));
end
elseif window==3
 for i=0:1:(m-1)
 w(i+1)=0.54-0.46*cos(2*pi*i/(m-1));
end
elseif window==4
 for i=0:1:(m-1)
 w(i+1)=0.42659-0.49656*cos(2*pi*i/(m-1))+0.076849*cos(4*pi*i/(m-1));
end
end

%Tính đáp ứng xung lý tưởng
a=(m-1)/2;
hd=zeros(m-1,1);
 for i=0:1:m-1
hd(i+1)=-sin(wc2*(i-a))/(pi*(i-a))+sin(wc1*(i-a))/(pi*(i-a));
end
hd(a+1)=1-wc2/pi+wc1/pi;
end
%Tính W(n)*h_d(n)
b1=hd.*w
h=b1’;
%Hiển thị 
[db,w1]=freqz_m(h,[1]);
delta_w=2*pi/1000;
n=[0:1:m-1];
figure; stem(n,hd);
axis([0,m-1,-0.1,0.8]);
title(‘Day dap ung xung cua bo loc ly tuong’);
xlabel(‘n’); ylabel(‘w(n)’);
figure; stem(n,w);
axis([0,m-1,0,1.1]);
title(‘Day ham cua so’);
xlabel(‘n’); ylabel(‘w(n)’);

figure; stem(n,h);
axis([0,m-1,-0.1,0.8]);
title(‘Ham do lon tuyet doi cua dap ung tan so);
xlabel(‘n’); ylabel(‘h(n)’);

figure; 
plot(w1/pi,db); grid; hold on;
plot(-w1,pi,db); grid;
axis([-1,1,-100,10]);
title(‘Ham do lon tuong doi (dB) cua dap ung tan so’);
xlabel(‘frequency in pi units’); ylabel(‘Decibels’);
