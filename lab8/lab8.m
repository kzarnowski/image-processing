close all; clear; clc;

%a=imread('blobs.png');

a=imread('cameraman.tif');
SE1=strel('disk',7);
SE2=strel('line',10,60);
SE3=ones(3);

%a1=imopen(a, SE1);
%a2=imopen(a, SE2);
%a3=imopen(a, SE3);

a1=imclose(a, SE1);
a2=imclose(a, SE2);
a3=imclose(a, SE3);

subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);

%%
close all; clear; clc;

a=imread('circles.png');
SE=ones(3);

D=imdilate(a, SE);
E=imerode(a, SE);

a1=D-a; % krawędz zewnętrzna
a2=a-E; % krawędz wewnętrzna
a3=D-E; % suma wewnetrznych i zewnetrznych krawedzi

subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);

%%
close all; clear; clc;

a=imread('dziury.bmp');
imshow(a);
% wyznaczamy odleglosc geodeyzyjna miedzy dwoma punktami [wiersz, kolumna]
% A = [20, 234] 
% B = [88, 257]

marker = false(size(a));
marker(20, 234)=1;

SE = ones(3); 
% takie podejście zakłada, że odległośc między pikselami po przekątnej jest 
% taka sama jak w pionie/poziomie, dlatego dla takiego SE obliczona
% odległość to dolne ograniczenie faktycznej odległości (bo w
% rzeczywistości jest dalej, właśnie z uwagi na odległości po skosie); aby
% uzyskać górne ograniczenie potrzebujemy innego SE który będzie mierzył
% odległości tylko ortogonalnie
% SE = [0 1 0; 1 1 1; 0 1 0];

it = 0;
while marker(88, 257) == 0
    marker = imdilate(marker, SE) & a;
    it = it + 1;
end
it
imshow(marker);

%%
% Usuwanie elementów mających stycznośc z brzegiem - tworzymy marker który
% składa sie z samych zer, za wyjątkiem pikseli na brzegach, które
% kopiujemy z obrazy wejściowego. Poprzez rekonstrukcję w ten sposób
% otrzymamy elementy które sa na brzegach, możemy je odjąć od obrazu
% wejściowego.
close all; clear; clc;

a=imread('blobs.png');

marker = a;
marker(2:271,2:328)=0;

outliers = imreconstruct(marker, a);
a1 = a & ~outliers; % odejmowanie logiczne, zamiast zwykłego -

subplot(121), imshow(a);
subplot(122), imshow(a1);
% jest do tego też gotowa funkcja: imclearborder

%%
% wypełnianie dziur
% 1. negacja obrazu
% 2. imclearborder
% 3. dodajemy wynik do wejściowego obiektu
% do tego jest gotowe polecenie: imfill(obraz, 'holes');

%%
% uwypuklanie obiektów
close all; clear; clc;
% bwmorph(a, 'clean'); - trzeba użyć na koniec bo matlab ma buga
% rot90(SE) - obraca element, majac dwie maski wejsciowe (wzgledem siebie 
% obrocone o 45stopni) kazda z nich obracamy o 90, w ten sposob dostajemy
% wszystkie 8

a = false(100, 150);
a(21:50, 21:130) = true;
a(51:80, 51:80) = true;
imshow(a);

SE1 = [1 1 0; 1 -1 0; 1 0 -1];
SE2 = [1 1 1; 1 -1 0; 0 -1 0];

b = false(size(a));
while ~isequal(a,b)
    b = a;
    for k=1:4
        a = a | bwhitmiss(a, SE1);
        a = bwmorph(a, 'clean');
        a = a | bwhitmiss(a, SE2);
        SE1 = rot90(SE1);
        SE2 = rot90(SE2);
    end
end

imshow(a);

%%
close all; clear; clc;

% parametr Inf: wykonuje operacje dopóki nie będzie różnic między
% iteracjami
a=imread('circles.png');
a1=bwmorph(a, 'thin', Inf);
a2=bwmorph(a, 'thicken', Inf);
a3=bwmorph(a, 'erode', Inf);

subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);
%%
close all; clear; clc;
% szkielet morfologiczny: zbiór kół wewnątrz figury (o dowolnych promieniach) 
% które spełniają dwa warunki:
% - koło musi być w całości wewnątrz figury
% - koło musi mieć co najmniej dwa punkty styczne z brzegiem

a=imread('circles.png');
% a=imrotate(a, 35); % funkcja szkieletyzacji jest bardzo podatna na
% rotacje - szkielet wyjdzie trochę inny

a1=bwmorph(a, 'thin', Inf);
a2=bwmorph(a, 'skel', Inf);
a3=bwmorph(a2, 'spur', Inf); % ucinanie gałęzi szkieletu

subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);

