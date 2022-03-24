close all; clear; clc;

% w przypadku transformaty fouriera,zawsze najpierw konwersja do double

% ifft2 / ifft2
% fftshift / ifftshift

a=imread('cameraman.tif');
a = double(a)/255;

A=fftshift(fft2(a));
WA = abs(A); % widmo amplitudowe - moduł liczby zespolonej

% widma się logarytmuje, ale tylko na potrzeby stricte graficzne, żeby było
% lepiej widać
% imagesc(log(WA+0.01)); axis image

% te linie a obrazie mówią że istnieją na obrazie krawędzie nachyone pod
% takim kątem


[Nz,Nx]=size(a);
fx=linspace(-0.5,0.5,Nx);
fz=linspace(-0.5,0.5,Nz);

[FX, FZ]=meshgrid(fx,fz);

% meshgrid pozwala na bardzo szybkie obliczanie częstotliwości wypadkowej
f = sqrt(FX.^2+FZ.^2);

% subplot(131), imagesc(FX);
% subplot(132), imagesc(FZ);
% subplot(133), imagesc(f);

% fx, fz - służą do opisu osi
% FX, FZ - służą do wyliczania częstotliwości wypadkowej


% czestotliwosc wypadkowa utozsamiamy jako odleglosc od srodka
imagesc(fx, fz, log(WA+0.01)); axis image

% najprostszy filtr: (idealny dolnoprzepstowy)
LP = f>0.05;
imshow(LP); % koło, dla obrazów prostokątnych elipsa

% filtracja polega na przemnozeniu filtra przez obraz uzyskany z
% transformaty

a_new = real(ifft2(ifftshift(A.*LP)));
imshow(a_new); 
% wzdluz krawedzi mamy oscylacje (tak jak na sygnalach) zwiazane z funkcja sink
% poziom rozmycia zależy od LP 

% filtr gornoprzepustowy HP = 1 - LP, wystarczy zmienic na f > 0.1

% porownanie tych filtrow do prewitta i laplasjanow:
% na prewittcie i sobelu byly tylko krawedzie, 0 albo 1; tutaj tez sa
% widoczne krawedzie ale przepuszczamy tez inne rzeczy; dlatego nie powinno
% sie stosowac filtracji czestotliwosciowej do wykrywania krawedzi

%%
% filtr butterwortha i filtr gaussa

% filtr butterwortha
% N (6) wpływa na poziom zbocza
LP = 1./(1 + (f/0.05).^6);
b_new = real(ifft2(ifftshift(A.*LP)));
imshow(b_new)

% filtr gaussa exp(-f^2/2*f0^2)

LP = exp(-f.^2/(2*0.05^2));
c_new = real(ifft2(ifftshift(A.*LP)));
imshow(c_new)


%%
a = imread('F_dzieciol.png');
imshow(a);

a = double(a)/255;

[Nz,Nx, S]=size(a);

fx=linspace(-0.5,0.5,Nx);
fz=linspace(-0.5,0.5,Nz);

[FX, FZ]=meshgrid(fx,fz);

BS = abs(FX)>0.17 & abs(FX)<0.24 & abs(FZ)>0.14 & abs(FZ)<0.23;
BS = ~BS;

a_new=a;
for k=1:3
    A=fftshift(fft2(a(:,:,k)));
    WA = abs(A);
    subplot(2,2,k), imagesc(fx, fz, log(WA+0.01).*BS); axis image
    a_new(:,:,k)=real(ifft2(ifftshift(A.*BS)));
end 

subplot(2,2,4), imshow(BS);
figure;

subplot(121), imshow(a);
subplot(122), imshow(a_new);

%%
close all; clear; clc;
% KORELACJA 
% splot - mnozymy transformaty normalnie
% korelacja - obracamy o 180 stopni i mnozymy

bw=imread('text.png');
a=bw(32:45,88:98);

C = real(ifft2(fft2(bw) .* fft2(rot90(a,2),256,256)));

subplot(121), imshow(bw);
% subplot(122), imagesc(C); colorbar('vertical')

max(C(:))

bin=C>66;
% imshow(bin);

% aby odwzorowac literke, w miejscach kropek tworzymy prostokaty i bierzemy
% iloczyn logiczny z wzorcowa literka a

bin=imdilate(bin,ones(size(a))); % zamienia kropke na prostokat
bin=circshift(bin,[-7,-5]); % przesuniecie w lewy gorny rog literki
wynik = bw & bin;
subplot(122), imshow(wynik);

%%
close all; clear; clc;
% szukanie literki r
bw=imread('text.png');

% literka R (pozycja):
% X 63 71
% Y 23 11

r = bw(11:23, 63:71);
imshow(r);

C1 = real(ifft2(fft2(bw) .* fft2(rot90(r,2),256,256)));
C2 = real(ifft2(fft2(~bw) .* fft2(rot90(~r,2),256,256)));
C = C1 + C2;
subplot(121), imshow(bw);
max(C(:))
bin=C>115;

bin=imdilate(bin,ones(size(r))); % zamienia kropke na prostokat
bin=circshift(bin,[-7,-5]); % przesuniecie w lewy gorny rog literki
wynik = bw & bin;
subplot(122), imshow(wynik);

% będzie dokładnie taka sama wartość korelacji pomiędzy h a r ponieważ r
% zawiera się w h, dlatego dodatkowo liczymy korelacje pomiedzy negacja
% obrazu i negacja wzorca

%%
% transformata falkowa
% falka w 1D: pole musialo byc rowne 1 a srednia 0, sygnal rozklada sie na dwie
% czesci: aproksymacji i detali, na nastepnych poziomach rozklada sie czesc
% aproksymacji

% w 2D: rozkladamy obraz na 4 czesci: A, H - horyzontalne, W - wertykalne, D 
close all; clear; clc;

a=imread('cameraman.tif');

% wavemenu - w konsoli; potem wavelet packet 2D i file->import from
% workspace



