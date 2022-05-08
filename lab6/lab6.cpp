// Project1.cpp : Ten plik zawiera funkcję „main”. W nim rozpoczyna się i kończy wykonywanie programu.
//

#include <iostream>
using namespace std;
using namespace System;
using namespace System::Drawing;


int main() {
    Bitmap^ input;
    input = gcnew Bitmap("D:\\polar.bmp", true);
    int wys, szer;
    const int N = 256;
    wys = input->Height;
    szer = input->Width;

    // allocate memory
    int** A = new int*[wys];
    for (int i = 0; i < wys; i++) {
        A[i] = new int[szer];
    }
    int* hist = new int[N];
    int* LUT = new int[N];

    // wyzerowanie histogramu
    for (int k = 0; k < N; k++) {
        hist[k] = 0;
        cout << hist[k] << " ";
    }

    // histogram intensywnosci
    int a;
    Color Px;
    for (int kx = 0; kx < szer; kx++) {
        for (int kz = 0; kz < wys; kz++) {
            Px = input->GetPixel(kx, kz);
            A[kz][kx] = (int)(0.299 * (double)(Px.R) + 0.587 * (double)(Px.G) + 0.114 * (double)(Px.B));
            hist[A[kz][kx]]++;
        }
    }

    // stworzenie dystrybuanty
    for (int k = 1; k < N; k++) {
        hist[k] += hist[k - 1];
    }

    // na ile klas podzielimy
    int N_klas;
    cout << "Podaj ilosc klas" << endl;
    cin >> N_klas;
    int pole = szer * wys; 

    // LUT
    int n = 0;
    for (int k = 0; k < N; k++) {
        if (hist[k] > (n + 1) * pole / N_klas && n < N_klas) {
            n++;
        }

        LUT[k] = (int)((n * 255) / (double)(N_klas));
    }

    for (int k = 0; k < N; k++) {
        cout << k << ": " << LUT[k] << " " << hist[k] << endl;
    }


    for (int kz = 0; kz < wys; kz++) {
        for (int kx = 0; kx < szer; kx++) {
            A[kz][kx] = LUT[A[kz][kx]];
            Px = Color::FromArgb(A[kz][kx], A[kz][kx], A[kz][kx]);
            input->SetPixel(kx, kz, Px);
        }
    }
    input->Save("D:\\polar4.png");

    // free memory
    for (int i = 0; i < wys; i++) {
        delete[] A[i];
    }
    delete[] A;
    delete[] hist;
    delete[] LUT;
}




int funkcja_2() {
    Bitmap^ input;
    input = gcnew Bitmap("D:\\polar.bmp", true);
    int wys, szer;
    wys = input->Height;
    szer = input->Width;
    int wys2 = (int)floor(wys / 2);
    int szer2 = (int)floor(szer / 2);

    Bitmap^ output;
    output = gcnew Bitmap(szer, wys);

    double phi;
    cout << "Podaj kat obrotu ( w stopniach): ";
    cin >> phi;

    phi = phi * 3.141592 / 180;
    int nx, nz;
    int kx, kz;
    Color Px;

    double cc = cos(phi);
    double ss = sin(phi);

    for (int nz = 0; nz < wys; nz++) {
        for (int nx = 0; nx < szer; nx++) {
            kx = (int)(cc * (double)(nx - szer2) - ss * (double)(nz - wys2) + szer2);
            kz = (int)(ss * (double)(nx - szer2) + cc * (double)(nz - wys2) + wys2);
            
            if (kx >= 0 && kx < szer && kz >= 0 && kz < wys) {
                Px = input->GetPixel(kx, kz);
                output->SetPixel(nx, nz, Px);
            }
        }
    }

    output->Save("D:\\polar3.png");
    return(0);

}



int funkcja_1()
{
    Bitmap^ obraz;
    obraz = gcnew Bitmap("D:\\polar.bmp", true);
    int wys, szer;
    wys = obraz->Height;
    szer = obraz->Width;

    Bitmap^ obraz2;
    int wys2, szer2;
    wys2 = (int)floor(wys / 2);
    szer2 = (int)floor(szer / 2);
    obraz2 = gcnew Bitmap(szer2, wys2);
    
    Color Px;

    int bright;
    cout << "Podaj poziom rozjasnienia" << endl;
    cin >> bright;

    // bezpieczniej jest chodzic po mniejszym obrazie, poniewaz dla kazdego piksela jest
    // odpowiadający piksel w dużym
    int r, g, b;

    for (int kz = 0; kz < wys2; kz++) {
        for (int kx = 0; kx < szer2; kx++) {
            Px = obraz->GetPixel(2 * kx + 1, 2 * kz + 1);
            r = min(Px.R + bright, 255);
            g = min(Px.G + bright, 255);
            b = min(Px.B+ bright, 255);

            Px = Color::FromArgb(r, g, b);
            obraz2->SetPixel(kx, kz, Px);
        }
    }

    obraz2->Save("D:\\polar2.png");
    return(0);
}

