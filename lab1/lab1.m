close all; clear; clc;

a = imread('cameraman.tif');
%imshow(a)

% zeby moc wykonywac operacje charakterystyczne dla liczb
% zmiennoprzecinkowych jak np podnoszenie do niecalkowitej potegi musimy
% najpierw przejsc na double

% uint8: 0-255
% double: 0-1

% przejscie na double
a = double(a)/255;

% powrot na inty
a = uint8(255*a)
imshow(a)

b = a + 50
c = b - 100
d = c + 50
subplot(121), imshow(a);
subplot(122), imshow(d);
%%
close all; clear; clc;

a = imread('peppers.png');
imshow(a);
size(a)

% dekompozycja RGB na poszczegolne kanaly
subplot(224), imshow(a)
for k=1:3
    subplot(2,2,k), imshow(a(:,:,k));
end
%%
% OBRAZ INDEKSOWANY:
% Obraz RGB dekomponujemy na dwie zmienne: 
%   - mapę 2D (dla kazdego piksela wpisujemy indeks do palety barw)
%   - 3 kolumnowy wektor (legende mapy, palete barw)
% wektor przechowuje zdefiniowane kolory, w ten sposob jesli na obrazie
% jest kilka pikseli o takim samym kolorze, to musimy tylko raz zapamietac
% informacje o tym kolorze

[map, leg]=rgb2ind(a, 450);
% jesli wektor jest za krotki tzn kolorow jest wiecej niz 10000 to kolory
% zostaja przyblizone np metoda k srednich

b=ind2rgb(map,leg);
subplot(1,2,1), imshow(a)
subplot(1,2,2), imshow(b)
%%
close all; clear; clc;

a = imread('cameraman.tif');
%w konsoli: imtool(a)
% colormap->lines: sluzy do pomiaru zmiennosci

% informacje o pliku: sa one zapisane w pliku, wiec przetworzenie obrazu w
% matlabie powoduje utracenie tych danych
b=imfinfo('cameraman.tif');

b=regionprops(a,'all');
% numer wiersza to numer koloru (poziomu szarosci)
% kolumny:
% area: ile mamy pikseli o danym kolorze
% centroid: moment bezwladnosci pierwszego rzedu, srodek masy; pomocny w
%   celu sprowadzenia opisu polozenia danego obiektu do jednego punktu, np.
%   gdy chcemy opisac jego ruch w czasie
% bounding-box: najmniejszy opinajacy pionowy lub poziomy prostokat, tzn.
%   taki ze wszystkie piksele obiektu sa wewnatrz tego prostokata
%   matlab definiuje jako wspolrzedne lewego gornego rogu + szerokosc i wys
% majoraxislegnth, minoraxislength,eccenticity, orientation:
%   analogicznie do bounding-box, tylko ze przyblizamy elipsa, przy czym
%   w odroznieniu od bounding-box, czesc pikseli moze znalezc sie poza
%   elipsa, chodzi o pewne przyblizenie
% convexHull:
%   - pomaga uniknac zakleszczen dwoch obiektow 
%   - czesto zamieniamy obiekty na wypukle, aby przyspieszyc obliczenia
% convexImage: wyglad figury po uwypukleniu
% convexArea:
% circularity: (bezwymiarowy wspolczynnik ksztaltu) 4pi*pole / obwod^2
%   pozwala opisywac ksztalt figury bez wzgledu na rozmiar
% eulerNumber: ilosc obiektow na obrazie pomniejszona o ilosc dziur w tych
%   obiektach, np. dla litery B wynosi -1 (jeden obiekt, dwie dziury);
%   sluzy do okreslania liczby dziur w obiektach
% equivDiameter: (srednica zastepcza), kiedy mamy obiekty tej samej klasy o
%   roznym ksztalcie. Liczymy powierzchnie jaka zajmuje, przyrownujemy to
%   do kola (tzn. jakie kolo ma takie pole) i obliczamy jego srednice. Tak
%   obliczone srednice mozemy porownywac
% perimeter: (obwod), bardzo ciezko go policzyc, nie jest to jednoznaczne,
%   traktujemy go bardziej jako estymator, przyblizenie; poniewaz to jaki
%   wyjdzie obwod zalezy czy policzymy np. piksele wewnatrz obiektu (na
%   jego granicy) czy piksele juz nie nalezace do tego obiektu
% FeretDiameter: wystepuje pewna niejednoznacznosc; najczesciej spotykana
%   definicja to dlugosc najkrotszego i najdluzszego rzutu, rozne rzuty 
%   powstaja poprzez rotacje obiektu, nie musza byc prostopadle (moga
%   pochodzic z roznych rotacji)

%%

% x - intensywnosc - ile pikseli o danym kolorze
% y - area: ile pikseli o danej intensywnosci + skladowa x centroidu

close all; clear; clc;
a = imread('cameraman.tif');
a=regionprops(a,'all');

N=length(a);
intensity=1:N;
area=zeros(N,1);
xc=area;
for k=1:N
    area(k,1)=a(k).Area;
    xc(k,1)=a(k).Centroid(1);
end

x=1:253;
y1=a.Area;
%y2=a.Centroid[1];
%plot(x, y1, '.r', x, y2, '.b')

pole = [a(:).Area];
xx=[a(:).Centroid];
xc=xx(1:2:end);
plot(intensity, pole, 'r', intensity, xc, 'b')

% dla niebieskiego wykresu, piksele generalnie sa rownomiernie rozlozone
% ale wystepuje pewny wzrost w okolicy 150, co oznacza ze piksele o tych
% wartosciach sa bardziej wychylone na prawo (jest ich wiecej po prawej
% stronie obrazu)

%%
close all; clear; clc;

% PROFILOWANIE

% analogia do biegu czy kolarstwa: zmiana wysokosci terenu wzdluz jakiejs
% trasy; dla obrazow bedzie to zmiana intensywnosci kolorow wzdlu pewnej
% linii

a = imread('peppers.png');


% wazne zeby dobrze pobierac rozmiar zaleznie od wymiaru obrazu
[N, M, K] = size(a);

% improfile: zawsze sa dwa nawiasy: najpierw skladowe x potem y
subplot(121), imshow(a);
subplot(122), improfile(a, [1 M], [1 N]);

%%
close all; clear; clc;

a = imread('peppers.png');
[N, M, K] = size(a);
b = improfile(a, [1 M 1 M], [N 1 1 N]);

improfile(a, [1 M 1 M], [N 1 1 N]) %printuje w 3D: malo czytelne
% zamieniamy na wykres 2D:

NN=size(b,1); % size(A,dim) - b: obiekt, dim: po ktorej osi
px=1:NN;
%plot(px,b(:,1,1),'r', px,b(:,1,2), 'g')

%%
% ROZDZIELCZOSC:
% - wysokosc x szerokosc
% - gestosc upakowania pikseli (dpi)
% - fizyczny rozmiar piksela (np. 1px odpowiada 1mm)

a=checkerboard(8,4,4);
imshow(a)

% interpolacja musi w wezlach przyjmowac wartosci wezlow, aproksymacja
% niekoniecznie (przyblizamy caly zbior)

% 3 metody interpolacji w matlabie:
%   - najbliższego sąsiada
%   - biliniowa; interpolacja na podstawie 4 sasiednich pikseli, kolejno po
%       kazdej z osi wspolrzednych
%   - bikubiczna: analogicznie do biliniowej tylko bierzemy 16 pikseli

skala=0.7;
a1=imresize(a, skala,'nearest');
a2=imresize(a, skala,'bilinear');
a3=imresize(a, skala,'bicubic');

subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);

% Wazne aby odpowiednio dobrac metode interpolacji do danych:
% nearest nie zmieni liczby odcieni szarosci, ma to znaczenie przede
% wszystkim kiedy nasz obraz jest obrazem indeksowanym -> dla takich
% obrazow tylko metoda najblizszego sasiada
% jesli rozklad kolorow jest ciagly (np. temperatura) lepiej stosowac
% bilioniowa lub bikubiczna

% zwiekszanie rozdzielczosci jest przydatne kiedy chcemy porownywac dwa
% obrazy o roznej rozdzielczosci, chcemy wtedy ten mniejszy dorownac do
% tego wiekszego
