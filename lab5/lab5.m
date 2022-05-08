close all; clear; clc; 

Fs = 100;
t = 0:(1/Fs):10;
x = sin(2*pi*(2+t/2).*t);

plot(t, x);
figure

%transformata prosta- dekompozycja
%odwrotna- rekonstrucja 
[C, L] = wavedec(x, 3, 'db3');
L
%wektor L mowi nam jaka jest dlugosc wektorow a3, d3 a na pozycji ostatniej
%jest dlugosc sygnalu. Jest nam on potrzebny zeby wyciagac wartosci z
%wektora C
A3 = C(1:L(1));
D3 =  C(1+L(1):L(1)+L(2));   
D2 = C(1+L(1)+L(2):L(1)+L(2)+L(3));
%D1 z niskich do wyskoich czestotliwosic
D1 = C(1+L(1)+L(2)+L(3):L(1)+L(2)+L(3)+L(4));

subplot(411), plot(A3);
subplot(412), plot(D3);
subplot(413), plot(D2);
subplot(414), plot(D1);
figure
%czesc A3 najbardziej niskoczestotliwosciowa
%przechodzimy z nisko w wysoko czestotliwosciowe

%bedziemy zerowac elementy- skopiujemy wektor C i wyzerujemy wektor
%odpowiedzialnmy za jakas czesc i zrobimy rekonstrukcje sygnaly
%zeby sprawdzic jk to wplynie na sygnal wyjsciowy

C1 = C; 
C1(1:L(1)) = 0;
A3 = waverec(C1, L, "db3");

C1 = C; 
C1(1+L(1):L(1)+L(2)) = 0;
D3 = waverec(C1, L, "db3");

C1 = C; 
C1(1+L(1)+L(2):L(1)+L(2)+L(3)) = 0;
D2 = waverec(C1, L, "db3");

C1 = C; 
C1(1+L(1)+L(2)+L(3):L(1)+L(2)+L(3)+L(4)) = 0;
D1 = waverec(C1, L, "db3");

subplot(411), plot(A3);
subplot(412), plot(D3);
subplot(413), plot(D2);
subplot(414), plot(D1);

%%
close all; clear; clc; 

Fs = 100;
t = 0:(1/Fs):10;
x = sin(2*pi*4*t);
x(357) = [];
t(357) = [];
plot(t, x);

%%
close all; clear; clc; 
a = imread('cameraman.tif');
[C, L] = wavedec2(a, 2, 'sym4');
L
%zeby wiedziec ile pikseli 
L2 = L(:,1).*L(:,2);
L2

A2 = C(1:L2(1));
AA2 = reshape(A2, [L(1, 1) L(1, 2)]);
imagesc(AA2); axis image
C1 = C; 
C1(1+L2(1):end) = 0;
anew = waverec2(C1, L, 'sym4');
imshow(uint8(anew));


C1 = C; 

C1(1+L2(1)+3*L2(2)+L2(3):L2(1)+3*L2(2)+2*L2(3)) = 0; %V1
C1(1+L2(1)+L2(2):L2(1)+2*L2(2)) = 0;%V2
anew = waverec2(C1, L, 'sym4');
imshow(uint8(anew));
%% treansformata cosinusowa
close all; clear; clc; 
a = imread('cameraman.tif');
a = double(a)/255;
A = dct2(a);
imagesc(log(abs(A)+0.01)); axis image

r = [5, 10, 25, 50, 100].^2;
subplot(321), imshow(a);

[N, M] = size(a);
odleglosci = zeros(256);
for k = 1:N
    for j = 1:M
        odleglosci(k, j) = k^2+j^2;
    end
end

for k = 1:5
    LP = (odleglosci<=r(k));
    anew = idct2(LP.*A);
    subplot(3,2,k+1), imshow(anew);
end

%maly promien- generalizacja
%duzy gradient => ringowanie

%filtrowqanie po wqartoscaich a nie po odleglosci 

th = [0.01, 0.05, 0.1, 0.5, 1];
%bedziemy zerowac wszytskie indeksy gdzie Ajk < th
%zerujemy wartości bliskie zeru

for z = 1:5
    HP = abs(A)>=th(z);
    ile_zer = 100*sum(HP(:) == 0)/(N*M);
    anew = idct2(A.*HP);
    subplot(3,2,z+1), imshow(anew);
    title(num2str2(ile_zer));
end

%% treansformata cosinusowa
close all; clear; clc; 

Qy = [16 11 10 16 24 40 51 61
12 12 14 19 26 58 60 55
14 13 16 24 40 57 69 56
14 17 22 29 51 87 80 62
18 22 37 56 68 109 103 77
24 35 55 64 81 104 113 92
49 64 78 87 103 121 120 101
72 92 95 98 112 100 103 99];

Qx = [17 18 24 47 99 99 99 99
18 21 26 66 99 99 99 99
24 26 56 99 99 99 99 99
47 69 99 99 99 99 99 99
99 99 99 99 99 99 99 99
99 99 99 99 99 99 99 99
99 99 99 99 99 99 99 99
99 99 99 99 99 99 99 99];

%jak zeiwkeszymy wartosc blokow to bedzeie wieksza kompresja, bardziej
%bedzie widac blokowanie
a = imread('peppers.png');

%1 
A = rgb2ycbcr(a);

%2, przed tym krokirm przejsc na double, ale bez dzielenia (zmieniamy tylko typ a nie wartosci)
A = double(A) - 128;

%3 my nie robimy

[x, y, z] = size(A);
%4 potrojna petla 
for i=1:8:x
    for j=1:8:y
        for k=1:3
        slice = A(i:i+7, j:j+7, k);
        %a
        T = dct2(slice);
        if k==1
            T=T./Qy;
        else
            T=T./Qx;
        end
        T = round(T);
        %dekompresja
        if k==1
            T=T.*Qy;
        else
            T=T.*Qx;
        end
        temp = idct2(T);
        A(i:i+7, j:j+7, k) = temp;
        end
    end
end

A = A + 128;
A = uint8(A);
subplot(121), imshow(a);
subplot(122), imshow(ycbcr2rgb(A));
%wnioski-widac granice bolkow
