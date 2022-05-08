%warto zaczynać skrypty od tych 3 poleceń:
close all; %zamknij wszystkie okna graficze
clear; % usun wszystkie zmienne z workspace
clc; % czyszczenie konsoli

%%
%średnik na końcu polecenia powoduje, że nie jest wyświetlane w konsoli
a = 5;
b = 5;
c = a + b;
x = uint8(c); %rzutowanie 
y = round(c); 
%indeks tablicy może być typu double, ale całkowity

%%
d = pi;
e = 5 + 1i; % jednostka urojona
%nie używać i jako indeksu w pętli for, ani jako zmiennej!
g = NaN;
f = Inf;
k = true;
%%
%wektory
A = [1, 2 3 5]; %przecinki są opcjonalne
%wektor pionowy
B = [1; 2; 3; 5]; %średniki są konieczne
D = A';

C = 1:2:4; % od 1 do 4 z krokiem 2
t = 0:0.01:1;
%%
close all; clear; clc;
%tablice

T = [1 2; 3 4];
E = zeros(5,6); %macierz 5x6, same zera
F = ones(5); %macierz 5x5, same 1
G = ones(1,5); %wektor poziomy, ones(5,1) - pionowy
H = eye(6,3) %macierz jednostkowa, działa nie tylko dla kwadratowych
K = rand(4,5) %rozkład równomierny z przedziału <0,1> R(4,5)
M = randn(5,4) %rozkład normalny (Gaussa) N(średnia=5, std=4);
%kliknąć polecenie i F1 - help do danego polecenia
%%
close all; clear; clc;

x = (12:3:40) 
A = -2 + (3+2)*rand(5,6) % R(0,1) -> R(-2,3)
B = 1 + 2*randn(7) %N(0,1 -> N(1,2)
C = (1:10)' * (1:10)
%%
close all; clear; clc;


a = 1:5
b = [1 1 1 1 1]'


c = a.*b %analogiczne do dodawnia wektorów, mnożenie pierwszego el. przez pierwszy itd
d = a.^2
%%
close all; clear; clc;

%wyciąganie informacji z macierzy itd
C(1,:); %1 wiersz, wszystkie kolumny
C(:,2); % kolumna
C(2:2:10, 1:2:10); %parzyste wiersze, nieparzyste kolumny
C([1,2,5],[1:3,10]);

max(C); %max z każdej kolumny
max(C(:)); %max z całej macierzy C: traktuje macierz jako wektor jednokolumnowy pionowy
%%
%uwaga! policzenie osobno dla kolumn, a dla całej macierzy da czasami inne
%wyniki; dlatego zawsze liczyć od razu dla całej macierzy
D=rand(10)
median(median(D))
median(D(:))
%%
close all; clear; clc;

t=0:0.01:10;
x=sin(2*pi*t);
plot(t,x,'.-r'); %rgb, cmyk, k, white
%formatowanie wyglądu wykresu - doczytać
xlabel('czas [s]');
ylabel('sinus');
title('sinus(2\pi t)'); %literki greckie poprzedzone \

%%
close all; clear; clc;
t=0:0.01:10;
x=sin(2*pi*t);
plot(t,x,'.r','MarkerSize',10); hold on
plot(t,x,'k','LineWidth',3); hold off;
%%
close all; clear; clc;
t=0:0.01:10;
x=sin(2*pi*t);
subplot(2,2,1), plot(t,x,'.r','MarkerSize',10);
subplot(2,2,2), plot(t,x,'k','LineWidth',3);
subplot(2,2,[3,4]), plot(t,x);
%%
close all; clear; clc;

% 1) x(t) = pierwiastek 3 stopnia z t t=<0,10>, z krokiem 0.02
% 2) y(t) = (t+1)/(t+2) dla t j.w.
% 3) histogram rozkładu normalnego B=1000x1000 z N(0,2);
% figura 2x2, NW - x czarne kółeczka, SW - żółta linia o grub 2, E - hist

t=0:0.02:10;
x = t.^(1/3); %sqrt - pierw. kwadratowy
y = (t+1)./(t+2);
B = 2*randn(1000);
subplot(2,2,1), plot(t,x,'ok');
subplot(2,2,3), plot(t,y,'y','LineWidth', 2);
subplot(2,2,[2,4]), histogram(B(:),20);
%%
close all; clear; clc;

x = 5;
if x < 3
    displ('mniejsze od 3');
else
    x = x.^2
end

% & and
% | or
% ~ neg
% == przyrównanie
% ~= różne od

for k=1:2:10
    disp(k)
end

mac=(1:10);
for k=mac
    disp(k)
end

x=0
while (x<5)
    x = x+1;
end

%%
close all; clear; clc;
% stworzyć tablicę R(-2,2) 8x8
% zsumować elementy leżące nad przekątną (bez przekątnej)

A = -2+ 4*round(8,8);
res = 0;
for k=1:7 
    res = res + sum(A(k, (k+1:8)));
end




