from re import L
import numpy as np
import cv2 as cv
from PIL import Image
import matplotlib.pyplot as plt
from sympy import Q


def padding(originalImg, padSize):
    padImg = np.zeros((rows+2*padSize, columns+2*padSize), dtype=np.uint8)
    # Slicing
    padImg[padSize:rows+padSize, padSize:columns+padSize] = originalImg
    return padImg


def Erosion(padImg, kernel, size):
    output = np.zeros((rows, columns), dtype=np.uint8)
    for i in range(0, rows):
        for j in range(0, columns):
            # Slicing
            portion = padImg[i:i+size, j:j+size]
            # sum of Kernel and window
            portion1 = portion.flatten()
            portion2 = kernel.flatten()
            p1 = (np.sum(portion1))
            p2 = (np.sum(portion2))*255
            # if Fit Condition Satisfies
            if p1 == p2:
                output[i, j] = 255
            else:
                output[i, j] = np.min(portion1)
    return output


def Dilation(padImg, size):
    output = np.zeros((rows, columns), dtype=np.uint8)
    for i in range(0, rows):
        for j in range(0, columns):
            # Slicing
            portion = padImg[i:i+size, j:j+size]
            portion1 = portion.flatten()
            # if Hit Condition Satisfies
            if 255 in portion1:
                output[i, j] = 255
            else:
                output[i, j] = np.max(portion1)
    return output


def zad_3(img):
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


def zad_4(img):
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


def hitmiss(img, mask):
    [N, M] = img.shape
    res = np.zeros((3, 3), dtype=np.bool8)

    output = np.zeros((N, M), dtype=np.uint8)
    for y in range(1, N-1):
        for x in range(1, M-1):
            fig = img[y-1:y+2, x-1:x+2]
            for i in range(3):
                for j in range(3):
                    if mask[i, j] == 1:
                        res[i, j] = fig[i, j] == 1
                    elif mask[i, j] == -1:
                        res[i, j] = fig[i, j] == 0
                    else:
                        res[i, j] = 1
            output[y, x] = np.all(res)
            res.fill(False)
    return output


def zad_1(img):
    output = np.empty(shape=img.shape)

    n = int(input("Podaj liczbe punktow: "))
    print("Podaj punkty, wspolrzedne oddzielone spacją np: 100 50")
    p = []
    for i in range(n):
        point = input(f"Punkt {i+1}: ").split()
        point[0] = int(point[0])
        point[1] = int(point[1])
        p.append(point)
    p.append([0, 0])
    p.append([255, 255])

    p = sorted(p, key=lambda point: point[0])

    for y in range(N):
        for x in range(M):
            i = 0
            while(p[i+1][0] < img[y, x]):
                i += 1
            a = (p[i][1] - p[i+1][1])/(p[i][0] - p[i+1][0])
            if mono:
                output[y, x] = a*img[y, x] + (p[i][1] - a*p[i][0])
            else:  # RGB
                for c in range(2):
                    output[y, x, c] = a*img[y, x, c] + (p[i][1] - a*p[i][0])

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
        # output = zad_2()
        pass
    elif zad == 3:
        output = zad_3(img)
    elif zad == 4:
        output = zad_4(img)
    else:
        print("Zly numer zadania. Wybierz 1-4.\n")
        exit()

    output_img = Image.fromarray(np.uint8(output))
    plt.subplot(121)
    plt.imshow(img, cmap="gray")
    plt.subplot(122)
    plt.imshow(output, cmap="gray")
    plt.show()

    output_img.save("P1/img/result.png")
