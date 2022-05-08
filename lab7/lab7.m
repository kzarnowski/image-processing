close all; clear; clc;
% Transformacja Radona
% prosta - mówi co zarejestrujemy
% odwrotna - z zarejestrowanych wyników odtwarza obraz (rentgen)


a = zeros(128);
a(35:94,35:94) = 1;
% imshow(a);

% najpierw musimy podać orientację układów pomiarowych, czyli pod jakim
% kątem będziemy prześwietlać

katy=0:179;
[R,X] = radon(a, katy);

imagesc(katy, X, R);
colorbar('vertical');
xlabel('katy [deg]');
ylabel('odleglosc [px]');

% maksimum jest na 45 i 135 stopni bo przeswietlamy kwadrat po przekatnej a
% transformacja radona to suma wartosci pikseli razy długość piksela ( a po
% przekątnej długość jest większa niż np pionowo)

% Transformata Radona nie jest odwracalna (powrót może nam dać inny wynik)
an = iradon(R, katy);
imshow(an);

% azymut kątów musi być jak najszerszy (0-179)

%%
close all; clear; clc;

a = phantom(256);
imshow(a);

katy=0:2:179;
[R,X] = radon(a, katy);

imagesc(katy, X, R);
colorbar('vertical');
xlabel('katy [deg]');
ylabel('odleglosc [px]');

an = iradon(R, katy);
imshow(an);
%%
close all; clear; clc;
% Transformata Hougha - znajdowanie prostych elementów na obrazie
% (linia prosta, koło, kwadrat, elipsa itd - czyli takich które jesteśmy 
% w stanie zdefiniować matematycznie) 
% Transformata Hougha jest szczególnym przypadkiem transformaty Radona

% dokonujemy transformacji z układu kartezjańskiego na biegunowy,
% wykorzystując parametryczne równanie prostej

a=imread('blobs.png');
subplot(121), imshow(a);

% H - wynik transformaty
% T - kąty theta
% R - wartości ro
[H, T, R] = hough(a);
subplot(122), imagesc(T,R,H);
xlabel('\theta');
ylabel('\rho');
colorbar('vertical');

% aby odczytać linie musimy wydobyc lokalne maksima
piki = houghpeaks(H,10);

% mając te piki próbujemy znaleźć początek i koniec naszej linii
linie = houghlines(a, T, R, piki, 'FillGap', 2);
% linie - struktura: współrzędne początka i końca linii, ro i theta
% punkt przeciecia moze byc poza obrazem


len_max = 0;
k_max = 0;
figure;
imshow(a); hold on;
for k=1:10
    len = sqrt((linie(k).point2(2) - linie(k).point1(2))^2 + ...
        (linie(k).point2(1) - linie(k).point1(1))^2);
    if len > len_max
        len_max = len;
        k_max = k;
    end

    line([linie(k).point1(1) linie(k).point2(1)], ...
        [linie(k).point1(2) linie(k).point2(2)], 'color', 'b');
end
line([linie(k_max).point1(1) linie(k_max).point2(1)], ...
        [linie(k_max).point1(2) linie(k_max).point2(2)], 'color', 'r');
hold off


% domyślnie znajduje linie ale dopuszcza duży błąd na nieciągłości, można
% to dostosować ustawiając parametr FillGap w houghlines

%%
% Transformata Gabora - transformata czasowo częstotliwościowa
% Określa tzw. bank filtrów - nie mamy jednego filtra tylko cały ich zbiór

close all; clear; clc;

a=imread('cameraman.tif');
dlug=2.^(1:5);
katy=0:45:135;

% g - baza filtrow
g = gabor(dlug,katy); % kombinacja każdej dlugosci fali z kazda orientacja
% a1 = real(g(1).SpatialKernel);
% a2 = real(g(20).SpatialKernel);

magn = imgaborfilt(a,g);
a1 = magn(:,:,1);
a2 = magn(:,:,20);
subplot(121), imagesc(a1);
subplot(122), imagesc(a2);

% Transformata Gabora służy do detekcji tekstur na obrazie
%%
close all; clear; clc;

a = imread('gabor.png');
imshow(a);
% nie szukamy tesktu, tylko szukamy tekstury siatki, okresowości; nie
% interesują nas kolory

% zmniejszamy obraz tylko po to żeby sie szybciej liczylo na zajeciach
a=imresize(a,0.5);

[Nz, Nx] = size(a);
dlug=2.^(1:7);
katy=0:22.5:160; % 22.5 żeby dokładnie znaleźc 45 stopni

g = gabor(dlug, katy);
magn = imgaborfilt(a,g);
% długo się liczy dlatego robimy z tego osobna sekcje
%%
for k=1:length(g)
    odch=3*0.5*g(k).Wavelength;
    magn(:,:,k)=imgaussfilt(magn(:,:,k), odch);
end
%%
% przechodzimy z tablicy 3D na 2D

xx=1:Nx;
zz=1:Nz;
[XX, ZZ] = meshgrid(xx, zz);
% doklejamy x i y w 3 wymiarze
zbior=cat(3,magn,XX);
zbior=cat(3,zbior,ZZ);

% [] - matlab sam wylicza 2 wymiar
D = reshape(zbior, Nx*Nz,[]);

% przeprowadzamy normalizację dla każdej kolumny osobno
% dla każdej kolumny obliczamy średnią i normalizujemy do śrendniej = 0 i
% odchylenia standardowego 1
D = D-mean(D);
D = D./std(D);
%%
wspol=pca(D); % pca - w toolboxie statistics and machine learning
obraz = reshape(D*wspol(:,1), Nz, Nx);
imagesc(obraz);

%%
% chcemy 2 klasy - albo tekstura albo tekst; uruchamiamy 5 razy
L=kmeans(D,2,'Replicates', 5);
wynik = reshape(L, [Nz,Nx]);
%%
maska=(wynik==1); % 1 lub 2, trzeba spróbować
an = imoverlay(a, maska, 'k');
imshow(an);
% dostajemy informacje gdzie tekst sie znajduje i na tym obrazie mozemy
% uruchomic juz bardziej tradycyne metody znajdowania tekstu

%%
% Transformaty: Fouriera, Cosinusowa, Radona, Hougha, 
% Transformaty czasowo-częstotliwościowe: falkowa, Gabora

%%
close all; clear; clc;
% MORFOLOGIE - bardzo dużo będzie na egzaminie

% Idea przypomina trochę przekształcenia przestrzenne

SE1=strel('disk', 7);
SE2=strel('line', 11, 60);
SE3=strel('arbitrary', [0 1 0; 1 1 1; 0 1 0]);
% w konsoli: SE1.Neighborhood

% a=imread('circles.png');
a = imread('cameraman.tif');
subplot(221), imshow(a);

% erozja - możemy usuwać w prosty sposób linie/elementy o określonej
% orientacji - przypisuje pikselowi centralnemu minimum z sąsiednich ( w
% obrębie zdefiniowanego elementu przez strel) pikseli
a1=imerode(a, SE1);
a2=imerode(a, SE2);
a3=imerode(a, SE3);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);

%%
% operacją przeciwną do erozji jest dylacja (dylatacja)
close all; clear; clc;
SE1=strel('disk', 7);
SE2=strel('line', 11, 60);
SE3=strel('arbitrary', [0 1 0; 1 1 1; 0 1 0]);
a=imread('circles.png');
subplot(221), imshow(a);

a1=imdilate(a, SE1);
a2=imdilate(a, SE2);
a3=imdilate(a, SE3);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);

% działa nalaogicznie do filtru maksimum - bierze piksele które mają choć
% jeden punkt wspólny ze zdefiniowaną figurą (?)

% ważną cechą erozji i dylacji jest ADDYTYWNOŚĆ - erozję i dylację dużym
% elementem możemy zastąpić serią erozji i dylacji mniejszymi elementami
% (przy czym w praktyce działa to tylko dla siatki prostokątnej i elementów
% jak kwadraty, prostokąty itd)


%%
close all; clear; clc;

a = zeros(128);
a(35:94,35:94) = 1;

SE1=ones(13);
SE2=ones(3);

% wykonujemy erozje dużym elementem, zapisujemy wynik, a nastepnie
% wykonujemy serie erozji małym elementem aż otrzymamy ten sam wynik

b=imerode(a, SE1);
iter=0;

% isequal służy do porównywania macierzy, nie wolno użyć zwykłego ==
while ~isequal(a,b)
    a=imerode(a,SE2);
    iter=iter+1;
end
iter

% zeby cos takiego mozna bylo robic, podzial musi byc calkowitoliczbowy,
% czyli SE2 musi być zawsze rozmiaru 3
