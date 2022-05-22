import numpy as np
import cv2 as cv
from PIL import Image
import matplotlib.pyplot as plt


def padding(img, pad):
    """
    Rozszerza obraz wejściowy o marginesy w celu obliczeń na brzegach.
    Przykład (pad = 1):

                        1 1 2 3 3
    1 2 3               1 1 2 3 3
    4 5 6       =>      4 4 5 6 6
    7 8 9               7 7 8 9 9
                        7 7 8 9 9
    """

    pad_img = np.zeros((N+2*pad, M+2*pad), dtype=np.uint8)

    # przekopiowanie wejsciowego obrazu
    pad_img[pad:N+pad, pad:M+pad] = img

    # # uzupełnienie marginesów po lewej i prawej stronie
    pad_img[pad:pad+N, :pad] = img[:, 0].reshape(-1, 1)
    pad_img[pad:pad+N, pad+M:] = img[:, M-1].reshape(-1, 1)

    # uzupełnienie marginesów u góry i dołu
    pad_img[:pad, :] = pad_img[pad, :]
    pad_img[pad+N:, :] = pad_img[pad+N-1, :]

    return pad_img


def zad_3_2(img):
    R = int(input('Podaj promien maski: '))

    n = 2*R + 1
    center = (R, R)
    mask = np.zeros(shape=(n, n), dtype=np.uint8)
    for x in range(n):
        for y in range(n):
            dist = ((center[0] - x)**2 + (center[1] - y)**2)**0.5
            if dist <= R:
                mask[x, y] = 1

    # padding size
    p_size = R//2
    p_img = padding(img, p_size)

    img = Dilation(p_img, p_size)
    p_img = padding(img, p_size // 2)

    output = Erosion(p_img, mask, p_size)

    return output


def erode(img, SE):
    img = np.array(img, copy=True)
    res = np.array(img, copy=True)

    [N, M] = img.shape
    n = SE.shape[0]

    side = int((n - 1) / 2)

    for i in range(side, N - side):
        for j in range(side, M - side):
            slc = img[i - side:i + side + 1, j - side:j + side + 1]
            bool_idx = (SE == 1)
            res[i, j] = min(slc[bool_idx])

    return res


def dilate(img, SE):
    img = np.array(img, copy=True)
    res = np.array(img, copy=True)

    [N, M] = img.shape
    n = SE.shape[0]

    side = int((n - 1) / 2)

    for i in range(side, N - side):
        for j in range(side, M - side):
            slc = img[i - side:i + side + 1, j - side:j + side + 1]
            bool_idx = (SE == 1)
            res[i, j] = max(slc[bool_idx])

    return res


def zad_3(img):
    R = int(input('Podaj promien maski: '))

    # Utworzenie elementu kołowego o zadanym promieniu
    n = 2*R + 1
    center = (R, R)
    mask = np.zeros(shape=(n, n), dtype=np.uint8)

    for x in range(n):
        for y in range(n):
            dist = ((center[0] - x)**2 + (center[1] - y)**2)**0.5
            if dist <= R:
                mask[x, y] = 1

    print(mask)
    # Poszerzenie obrazu
    pad = R

    # Dylacja
    pad_img = padding(img, pad)
    dilated = np.empty((N, M), dtype=np.uint8)

    for y in range(pad, pad+N):
        for x in range(pad, pad+M):
            fig = pad_img[y-pad:y+pad+1, x-pad:x+pad+1]
            dilated[y-pad, x-pad] = np.max(fig[mask == 1])

    # Erozja
    pad_img = padding(dilated, pad)
    output = np.empty((N, M), dtype=np.uint8)
    for y in range(pad, pad+N):
        for x in range(pad, pad+M):
            fig = pad_img[y-pad:y+pad+1, x-pad:x+pad+1]
            output[y-pad, x-pad] = np.min(fig[mask == 1])

    return output


def zad_4(img):
    def hitmiss(img, mask):
        # macierz wyników, przechowuje informacje czy na danej pozycji
        # wartości pikseli są poprawne na podstawie zadanej maski
        res = np.zeros((3, 3), dtype=np.bool8)

        output = np.zeros((N, M), dtype=np.uint8)

        for y in range(1, N-1):
            for x in range(1, M-1):
                # wycinek
                fig = img[y-1:y+2, x-1:x+2]

                # wypełnienie macierzy wyników
                for i in range(3):
                    for j in range(3):
                        if mask[i, j] == 1:
                            res[i, j] = fig[i, j] == 1
                        elif mask[i, j] == -1:
                            res[i, j] = fig[i, j] == 0
                        else:
                            res[i, j] = 1

                # piksel obrazu wyjściowego przyjmuje wartość True, gdy piksele
                # obrazu zgadzają się z maską na wszystkich pozycjach
                output[y, x] = np.all(res)

                # resetujemy macierz wyników
                res.fill(False)
        return output

    # Inicjalizacja maski
    mask_1 = np.array([[1, 1, 0], [1, -1, 0], [1, 0, -1]])
    mask_2 = np.array([[1, 1, 1], [1, -1, 0], [0, -1, 0]])
    output = np.zeros((N, M), dtype=np.bool8)

    i = 0
    while not np.array_equal(img, output):
        i += 1
        output = img

        for _ in range(4):
            img = np.logical_or(img, hitmiss(img, mask_1))
            img = np.logical_or(img, hitmiss(img, mask_2))
            mask_1 = np.rot90(mask_1)
            mask_2 = np.rot90(mask_2)

    print(i)
    return output


def zad_1(img):
    output = np.empty(shape=img.shape)

    n = int(input("Podaj liczbe punktow: "))
    print("Podaj punkty, wspolrzedne oddzielone spacją np: 100 50")
    p = []  # lista par współrzędnych
    for i in range(n):
        point = input(f"Punkt {i+1}: ").split()
        point[0] = int(point[0])
        point[1] = int(point[1])
        p.append(point)
    p.append([0, 0])
    p.append([255, 255])

    # sortujemy rosnąco po intensywności wejściowej
    p = sorted(p, key=lambda point: point[0])

    for y in range(N):
        for x in range(M):
            # sprawdzamy w którym przedziale jest intensywność wejściowa
            i = 0
            while(p[i+1][0] < img[y, x]):
                i += 1

            # dla tego przedziału obliczamy intensywność wyjściową
            # z równania prostej przechodzącej przez dwa punkty
            a = (p[i][1] - p[i+1][1])/(p[i][0] - p[i+1][0])
            if mono:
                output[y, x] = a*img[y, x] + (p[i][1] - a*p[i][0])
            else:  # RGB
                for c in range(2):
                    output[y, x, c] = a*img[y, x, c] + (p[i][1] - a*p[i][0])

    return output


def zad_2(img):
    n = int(input("Podaj rozmiar maski: "))
    pad = n // 2
    output = np.empty(shape=(N, M))

    pad_img = padding(img, pad)

    for y in range(pad, pad+N):
        for x in range(pad, pad+M):
            if mono:
                fig = pad_img[y-pad:y+pad+1, x-pad:x+pad+1]
            else:
                fig = pad_img[y-pad:y+pad+1, x-pad:x+pad+1, :]
            output[y-pad, x-pad] = np.std(fig)

    # normalizacja
    u = np.min(output)
    v = np.max(output)
    a = (0 - 255)/(u - v)

    for y in range(N):
        for x in range(M):
            output[y, x] = int(a*output[y, x] - a*u)

    return output


if __name__ == '__main__':

    img = cv.imread('P1/img/cameraman.tif', 0)
    N, M = img.shape[:2]
    mono = True if img.ndim == 2 else False

    zad = int(input("\
    1. Normalizacja wg lamanej\n\
    2. Filtracja odchylenia standardowego\n\
    3. Zamkniecie elementem kolowym\n\
    4. Wypukle otoczenie\n\n\
    Podaj numer zadania (1-4): "))

    output = None
    if zad == 1:
        output = zad_1(img)
        pass
    elif zad == 2:
        output = zad_2(img)
        pass
    elif zad == 3:
        output = zad_3(img)
    elif zad == 4:
        output = zad_4(img)
    else:
        print("Zly numer zadania. Wybierz 1-4.\n")
        exit()

    output_img = Image.fromarray(np.uint8(output))
    f, axarr = plt.subplots(1, 2)

    axarr[0].imshow(img, cmap="gray")
    axarr[1].imshow(output, cmap="gray")

    plt.show()

    output_img.save("P1/img/result.png")
