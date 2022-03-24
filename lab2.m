close all; clear; clc;


% KOREKCJA GAMMA
a=imread('cameraman.tif');

a = double(a)/255;

gam=[0.2 0.5 0.75 1 2 5];
for k=1:6
    b=a.^gam(k);
    subplot(2,3,k), imshow(b);
end
% dla gammy < 1:
%   zyskujemy kontrast w ciemnej czesci (wiecej widac) ale
%   tracimy w jasnej, oddalamy słupki na histogramie 
% dla gammy > 1 odwrotnie (zyskujemy kontrast w jasnej)
% porównać z wykresem funkcji gamma
% tym wazniejsze jest zeby zostac w przedziale 0-1

%%
close all; clear; clc;

% NORMALIZACJA

a=imread('pout.tif');
subplot(221), imshow(a);
subplot(222), imhist(a); % histogram jest bardzo waski

% obcinamy 2-5% z lewej i prawej strony i rozciagamy (aby uniknac odchylen)

b=imadjust(a);
subplot(223), imshow(b);
subplot(224), imhist(b);

% jakosc obrazu sie polepszyla a proprocje w histogramie zostaly zachowane
%%
close all; clear; clc;

% WYRÓWNANIE HISTOGRAMU

%a=imread('pout.tif');
a=rgb2gray(imread('saturn.png')); % problem z wyrownywaniem histogramu,
%jesli wartosci sa skoncetrowane wokół jakiegoś jednego punktu, a nie
%rozłożone równomiernie, to tradycyjne wyrównanie powoduje duże zmiany w
% poziomach szarości: w takich sytuacjach stosujemy adaptacyjne wyrownanie
% histogramu (CLAHE), ktore tak jakby przelicza histogram dla kazdego
% piksela
subplot(221), imshow(a);
subplot(222), imhist(a);

%b=histeq(a, 16); % tylko dla malej liczby klas mozemy dostac rownomiernosc
b=adapthisteq(a);
subplot(223), imshow(b);
subplot(224), imhist(b);

% odbywa sie to przy pomocy dystrybuanty ktora jest liczona na podstawie
% historamu; na dystrybuancie na dzielimy os y na liczbe klas i odczytujemy
% odpowiadajace wartosci na osi x

%%
close all; clear; clc;

% CLAHE - adaptacyjne wyrownanie histogramu
a=rgb2gray(imread('saturn.png'));
b=adapthisteq(a, 'Distribution','exponential', 'Alpha', 0.9);
subplot(221), imshow(a);
subplot(222), imhist(a);
subplot(223), imshow(b);
subplot(224), imhist(b);

%% 
close all; clear; clc;

% BINARYZACJA
a=imread('coins.png');

% dokładność binaryzacji powinna sie w miare zgadzac, nie da rady dopasowac
% idealnie; lepiej zrobić binaryzację żeby było w miarę ok, a poprawić
% filtracją
bin=a>80;
% aby poprawić efekt trzeba wykonać filtrację
bin=medfilt2(bin, [3 3]);
subplot(121), imshow(a);
subplot(121), imshow(bin);

%%
close all; clear; clc;

a=imread('wykres.png');
imshow(a);

purple = a(:,:,1)==126 & a(:,:,2)==47 & a(:,:,3)==142;

%subplot(121), imshow(a);
%subplot(122), imshow(purple);

% zakres wykresu: wspołrzedne x i y
% x = 342 - 2376 (0-350h)
% y = 112 - 1313 (35kPa-O)

bb=purple(112:1313,342:2376,:);
%imshow(bb);

% aby uzyskac dane numeryczne, musimy uzyskac dla kazdego czasu tylko jedna
% wartosc cisnienia: najprosciej to zrobic usredniajac wartość współrzędnej
% y dla każdego x

[N,M]=size(bb);

czas = zeros(M,1);
cisn = zeros(M,1);

for k=1:M
    ile=sum(bb(:,k)); % ile pikseli o wartosci true w kolumnie
    if ile > 0
        for w=1:N
            if bb(w,k)==true
                cisn(k,1)=cisn(k,1)+w;
            end
        end
        cisn(k,1)=cisn(k,1)/ile;
    else
        cisn(k,1)=NaN;
    end
    czas(k,1)=k;
end
plot(czas,cisn);

% czas = a * kol + b (analogicznie dla cisnienia)


% na podstawie zakresow, przeliczanie indeksow na wartosci:
czas = (350 * (czas-1)) / (M-1); % k-1 i M-1 bo w matlabie indeksujemy od 1
cisn = 35000*(N-cisn)/(N-1);

%plot(czas,cisn);
czas_4h=0:4:350;
cisn_4h=interp1(czas,cisn,czas_4h);
plot(czas,cisn,'r',czas_4h,cisn_4h,'*b');

%%
close all; clear; clc;
% PRZEKSZTAŁCENIA GEOMETRYCZNE

a=imread('cameraman.tif');


b=circshift(a, [50, -10]); % przesuniecie cykliczne

b = padarray(a, [20,50], 'symmetric', 'both'); % zwiekszanie rozmiaru obrazu
% parametry: sposob uzupelniania pikseli i kierunek

b=flipud(a); % odbicie lustrzane pionowo
b=fliplr(a); % odbicie lustzane poziomo

b=imrotate(a,30, 'crop', 'bicubic'); % bez crop domyslnie powieksza

% matematycznie:
% x          cos(a)  -sin(a)          x
%    =   ( [                 ]    *           )
% y          sin(a)   cos(a)          y


subplot(121), imshow(a);
subplot(122), imshow(b);
%%
close all; clear; clc;
a=imread('cameraman.tif');

% przekształcenie afiniczne i projekcja
% afiniczne - przekształcenie różnowartościowe, które proste na jednym
% obrazie przekształca w proste na innym obrazie: dwa warunki: 3 kolumna
% musi byc rowna 0 oraz macierz 3x3 musi być nieosobliwa

% przeksztalcenia afiniczne: translacja, przesuniecie, odbicie, rotacja itd
% wartosci a d (na głownej przekątnej) odpowiadają za skalowanie
% wartosci b c (na przeciwprzekątnej) odpowiadają za przesuniecie

% a b 0
% c d 0
% e f 1

%mask = affine2d([1 1 0; 0 1 0; 0 0 1]);
mask = affine2d([2 0 0; 0 1 0; 0 0 1]);
b = imwarp(a, mask);


subplot(121), imshow(a); axis on
subplot(122), imshow(b); axis on

%%
% w projekcji 3 kolumna może byc dowolna (macierz nadal musi być
% nieosobliwa)

close all; clear; clc;
a=imread('cameraman.tif');

mask = projective2d([1 0 0.0005; 0 1 0.0001; 0 0 1]);
b = imwarp(a, mask);


subplot(121), imshow(a); axis on
subplot(122), imshow(b); axis on

% rotacja jest szczegolnym przypadkiem przeksztalcenia afinicznego,
% przeksztalcenie afiniczne jest szczegolnym przypadkiem projekcji

%%
%close all; clear; clc; % trzeba zakomentowac zeby nie wyczyscilo punktow z
%cpselect

a=imread('cameraman.tif');
b=imrotate(a,30,'crop','bicubic');
%cpselect(a,b);

% chcemy odgadnac rotacje, tzn. z obrazu przekrzywionego uzyskac prosty
mac=fitgeotrans(movingPoints, fixedPoints, 'affine');
mac.T

c = imwarp(b, mac);
imshow(c);
