close all; clear; clc;

a = zeros([256,256]);

for k=1:3
    x=ceil(256*rand(1));
    z=ceil(256*rand(1));
    a(z, x)=1;
end

imshow(a);

a1 = bwdist(a, 'euclidean');
a2 = bwdist(a, 'quasi-euclidean');
a3 = bwdist(a, 'cityblock');
a4 = bwdist(a, 'chessboard');

subplot(221), imagesc(a1); axis image, colorbar('vertical');
subplot(222), imagesc(a2); axis image, colorbar('vertical');
subplot(223), imagesc(a3); axis image, colorbar('vertical');
subplot(224), imagesc(a4); axis image, colorbar('vertical');

%%
close all; clear; clc;

a = imread('new_map.bmp');
imshow(a);

% Szukamy miejsca na mapie które spełnia wszystkie kryteria:
% 1) w lesie
% 2) L2(autostrada) > 30px (żółta linia)
% 3) L1(droga) < 10px (biała linia)
% 4) L2(woda) > 20px (jezioro + rzeka)

% 1. Tworzymy 4 mapy logiczne (jest las, nie ma lasu itd)


las = a(:,:,1)==185 & a(:,:,2)==215 & a(:,:,3)==170;
%imshow(las);
autostrada = a(:,:,1)==255 & a(:,:,2)==245 & a(:,:,3)==120;
%imshow(autostrada);
droga = a(:,:,1)==255 & a(:,:,2)==255 & a(:,:,3)==255;
droga = imopen(droga, ones(3)); % usuniecie zlych pikseli
droga = imclose(droga, ones(3, 1)); % poprawa ciaglosci
imshow(droga);
woda = a(:,:,1)>=64 & a(:,:,1)<=180 & a(:,:,2)>= 159 & a(:,:,2) <=230 & ...
    a(:,:,3)>=185 & a(:,:,3)<254;
woda=bwmorph(woda,'clean');
imshow(woda);

miejsce = las & bwdist(autostrada)>30 & bwdist(droga,'cityblock')<10 & ...
    bwdist(woda)>20;
%imshow(miejsce);
a = imoverlay(a, miejsce, 'r');
imshow(a);
%%
close all; clear; clc;
% POLE I OBWÓD KOŁA


a = zeros(300);
a(150, 150) = 1;
a = bwdist(a);

r=5:5:120;
pole_mat = pi*r.^2;
pole_px = pole_mat;
pole_est = pole_mat;

obwod_mat = 2*pi*r;
obwod_gradient = obwod_mat;
obwod_filtracja = obwod_mat;
obwod_perim = obwod_mat;

for k=1:24
    kolo = a < r(k);
    pole_px(k) = sum(kolo(:));
    pole_est(k) = bwarea(kolo);
    
    obwod_gradient(k) = (bwarea(imdilate(kolo, ones(3))-imerode(kolo,ones(3))))/2;
    obwod_perim(k) = bwarea(bwperim(kolo));
    obwod_filtracja(k) = bwarea(edge(kolo, 'canny'));
end

%plot(r, pole_px, 'r', r, pole_est, 'g', r, pole_mat', '.k');
plot(r, obwod_gradient, 'r', r, obwod_filtracja, '-.g', r, obwod_perim', '.b', r, obwod_mat, '.k');

% dla obwodu wyniki są zawyżone w stosunku do matematycznych

%%
% ROZDZIELENIE DWÓCH KÓŁ NACHODZĄCYCH NA SIEBIE
close all; clear; clc;
a = zeros(200,300);
a(100,94) = 1;
a(100,206) = 1;
a = bwdist(a);
a = a < 60;
%imshow(a);

D = -bwdist(~a); % kroki 1-3
L = watershed(D);
imagesc(L);
a = a & (L > 0);
imshow(a);

%%
close all; clear; clc;
% Rozdzielenie - druga metoda

a = zeros(200,300);
a(100,94) = 1;
a(100,206) = 1;
a = bwdist(a);
a = a < 60;
%imshow(a);

% zamiast D = -bwdist... z pierwszej metody:
temp = imerode(a, ones(50, 5));
imshow(temp);
D = bwdist(temp);
% koniec podmiany

L = watershed(D);
imagesc(L);
a = a & (L > 0);
imshow(a);

% metodę przez erozję stosujemy kiedy nie działa metoda automatyczna, ale
% przy założeniu że obiekty które rozdzielamy są podobnych rozmiarów, lub
% rozdzielamy najmniejsze obiekty na obrazie 

%%
close all; clear; clc;

a=imread('coins.png');
subplot(121), imshow(a);

bin = a > 90;
bin = medfilt2(bin, [3 3]);

subplot(122), imshow(bin);

[aseg, N] = bwlabel(bin);
imagesc(aseg); axis image; colorbar('vertical');

pole=zeros(1,N);
for k=1:N
    temp=(aseg==k); % pojedyncza moneta
    pole(1,k)=bwarea(temp);
end
pole


[values, indices] = mink(pole, 5);
indices
monety = aseg == 4 | aseg == 2 | aseg == 10 | aseg == 9 | aseg == 6;
imshow(monety);
a = imoverlay(a, monety, 'k');
imshow(a);
