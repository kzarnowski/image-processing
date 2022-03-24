% ----- FILTRACJE LINIOWE -----

close all; clear; clc;
% filtracja uśredniająca jednorodna

a = imread('cameraman.tif');
N = 5;
mask = ones(N)/(N*N); %maska kwadratowa
% suma elementów maski musi być równa 1 i każdy element musi być > 0

b = imfilter(a, mask, 'symmetric');

subplot(121), imshow(a);
subplot(122), imshow(b);

% centrum obrazu sie rozmazalo, na krawedziach obraz zostal przyciemniony
% bo jako brakujace elementy matlab dobiera 0; dlatego musimy dolozyc
% pikseli na krawedziach ('symmetric')

%%
close all; clear; clc;

% filtracja gaussa - piksel centralny maski ma największą wartość, im dalej
% od centrum tym mniejszy wplyw

a = imread('cameraman.tif');
N = 5;
mask = fspecial('gaussian', [N N], N/4); % typ, rozmiar, std

b = imfilter(a, mask, 'symmetric');

subplot(121), imshow(a);
subplot(122), imshow(b);

%%
close all; clear; clc;
%filtracja górnoprzepustowa

% filtry górnoprzepustowe sumują się do 0, filtry uśredniające do 1

% wykrywanie krawedzi: (maski Prewitta)
m1 = [-1 -1 -1; 0 0 0; 1 1 1]; % poziomych
m2 = [-1 0 1; -1 0 1; -1 0 1]; % pionowych

% 1. przejsc na double
% 2. wartosc bezwgledna
% robimy tak, poniewaz zastosowanie filtra moze spowodowac wyjscie poza
% zakres, i wartosci zostana uciete do 0 lub 255

a = imread('cameraman.tif');
a = double(a)/255;
b = imfilter(a, m1, 'symmetric'); 
c = imfilter(a, m2, 'symmetric');

subplot(131), imshow(a);
subplot(132), imshow(abs(b));
subplot(133), imshow(abs(c));

%%
% wykrywanie wszystkich krawedzi - norma L2
close all; clear; clc;

m1 = [-1 -1 -1; 0 0 0; 1 1 1];
m2 = [-1 0 1; -1 0 1; -1 0 1];

a = imread('cameraman.tif');
a = double(a)/255;
b = imfilter(a, m1, 'symmetric'); 
c = imfilter(a, m2, 'symmetric');
d = sqrt(b.^2+c.^2);

subplot(121), imshow(a);
subplot(122), imshow(d);

%%
% maski sobela - ważona średnia z krawędzi (mozna 2 zastapic jeszcze
% wieksza liczbą (3,4 itd) ale bedziemy wtedy łapać też wiecej szumu
m1 = [-1 -2 -1; 0 0 0; 1 2 1];
m2 = [-1 0 1; -2 0 2; -1 0 1];

a = imread('cameraman.tif');
a = double(a)/255;
b = imfilter(a, m1, 'symmetric'); 
c = imfilter(a, m2, 'symmetric');
d = sqrt(b.^2+c.^2);

subplot(121), imshow(a);
subplot(122), imshow(d);


%%
close all; clear; clc;

N = 128;
a = zeros(N);
a(N/4:(3*N)/4, N/4:(3*N)/4) = 1;

m1 = [-1 -5 -1; 0 0 0; 1 5 1];
m2 = [-1 0 1; -5 0 5; -1 0 1]; 

b1 = imfilter(a, m1, 'symmetric');
b2 = imfilter(a, m2, 'symmetric');

d = b1 & b2;

subplot(121), imshow(a);
subplot(122), imshow(d);

%%
close all; clear; clc;

N = 128;
a = zeros(N);
a(N/4:(3*N)/4, N/4:(3*N)/4) = 1;

mask=[1 0 -1]; 
% uzywamy jednowierszowej i jednkolumnowej maski zeby nie 
% bylo efektu 2x2 przy wykrywaniu rogow
b=abs(imfilter(a, mask).*imfilter(a, mask'));
imshow(b);

% tworzymy obraz indeksowany
b = uint8(b+a); % w punktach gdzie sa rogi b + a = 2
pal = [0 0 0; 1 1 1; 1 0 0];
imshow(b, pal)

%%
close all; clear; clc;

a = imread('cameraman.tif');

m1 = [0 -1 0; -1 4 -1; 0 -1 0]; % suma = 0
m2 = [0 -1 0; -1 5 -1; 0 -1 0]; % suma = 1

b1 = imfilter(a, m1, 'symmetric'); % dla sumy 0 dostajemy wszystkie krawedzie
b2 = imfilter(a, m2, 'symmetric'); % zwieksza kontrast poniewaz dodaje biale krawedzie do obrazu

subplot(131), imshow(a);
subplot(132), imshow(b1);
subplot(133), imshow(b2);

% ----- KONIEC FILTRACJI LINIOWYCH

%%
% ----- FILTRACJE NIELINIOWE -----
close all; clear; clc;
% krawedz - nie filtrujemy lub słabo, brak krawedzi - filtrujemy mocno

N = 7;
a = imread('cameraman.tif');
b1 = medfilt2(a, [N N], 'symmetric');
b2 = wiener2(a, [N N]);

% medianowy - zniknely szczegoly, zmniejszyla się dynamika obrazu (mniej
% poziomow); mediana "zjada" narożniki - możemy użyć symmetric

% wiener - szczegoly zostaly w miare zachowane, krawędzie się nie zmieniają
% - zostają de facto przepisane z oryginalnego obrazu: trzeba recznie
% powiekszyc obraz o polowe maski paddarayem, przefiltrowac i przyciac
% obraz

subplot(131), imshow(a);
subplot(132), imshow(b1);
subplot(133), imshow(b2);


%%

% 4 rodzaje szumow:
% usredniajacy jednorodny
% usredniajacy gaussa
% mediana
% wiener

close all; clear; clc;

N = 9;
a = imread('cameraman.tif');

%aszum = imnoise(a, 'gaussian'); % najlepszy wiener dla N=5 lub 7

%aszum = imnoise(a, 'salt & pepper'); % najlepsza mediana, 
% rozmiar jak najmniejszy (dla 1 pikselowych zmian wystarczy 3x3)

%aszum = imnoise(a, 'poisson'); % dodajemy tylko do obrazu na uintach!, najlepszy wiener

% szum multiplikatywny: silnie zalezy od konkretnych wartosci piksela
% jest bardzo trudny do usuniecia, czesto wystepuje na obrazach; silnie
% zaszumia piksele o wysokich wartosciach
% satelitarnych

aszum = imnoise(a, 'speckle'); % najlepszy wiener

b1 = medfilt2(aszum, [N N], 'symmetric');
b2 = wiener2(aszum, [N N]);
b3 = imfilter(aszum, ones(N)/(N*N), 'symmetric');
b4 = imfilter(aszum, fspecial('gaussian', [N N], N/5));

subplot(121), imshow(a);
subplot(122), imshow(aszum);
figure;
subplot(221), imshow(b1);
subplot(222), imshow(b2);
subplot(223), imshow(b3);
subplot(224), imshow(b4);

%%
% VMF - vector median flow: zastepujemy centralny piksel kolorem ktory jest
% najblizej tego centralnego (w sensie przestrzeni 3D RGB) - im mniejsza
% maska tym wieksza degradacja obrazu, bo dla mniejszej liczby piskeli w
% masce jest mniejsza szansa ze znajdzie sie w niej piksel o kolorze
% podobnym (bliskim w sensie odleglosci) do tego centralnego
% Na zajeciach 7 kwietnia bedzie programowanie w C++ tego filtra

%%
close all; clear; clc;
% CANNY

% polecenie edge samo w sobie binaryzuje i wycina

a=imread('cameraman.tif');
b1 = edge(a, 'canny'); % jedna z najmocniejszych filtracji krawedziowych
b2 = edge(a, 'sobel');

subplot(121), imshow(b1);
subplot(122), imshow(b2);

%%
close all; clear; clc;
% FILTRACJE PORZADKOWE

a=imread('cameraman.tif');
b1 = ordfilt2(a,1,ones(5)); % filtracja minimum
b2 = ordfilt2(a,25,ones(5)); % filtracja maksimum

subplot(121), imshow(b1);
subplot(122), imshow(b2);

%%
close all; clear; clc;
% ENTROPIA - wartość entropii zależy od ilości poziomów intensywności, moze
% byc ostra krawedz 1 i 0 ale entropia bedzie mala bo tylko 2 stany

a=imread('cameraman.tif');
b1 = entropyfilt(a, ones(9)); % do entropii trzeba uzywac duzych masek, min. 9x9

% stdfilt w odroznieniu od entropii bada jak duze sa skoki miedzy
% wartosciami a nie jak duzo jest roznych stanow
b2 = stdfilt(a, ones(9)); % 


subplot(121), imagesc(b1); axis image
subplot(122), imagesc(b2); axis image

%%
close all; clear; clc;

% DEKONWOLUCJA - operacja odwrotna do splotu, konwolucji

a=imread('cameraman.tif');

% symulacja poruszenia: arg: o 11 pikseli i 60 stopni
mask = fspecial('motion', 11, 60);

b = imfilter(a, mask);

% deconvblind dziala dobrze gdzie jest duzy gradient - czyli gwaltowne
% przejscia od ciemnego do jasnego, gorzej dziala gdzie sa mniejsze roznice
%c = deconvblind(b, mask); 

%c = deconvlucy(b, mask);

% c = deconvwnr(b, mask); % wiener, bardzo zle dziala

c = deconvreg(b, mask);

subplot(121), imshow(b);
subplot(122), imshow(c);

% Wnioski: bardzo trudno poprawic poruszone zdjecie !

% fourier (filtracja, transformata) falki
