import numpy as np
import cv2 as cv
from PIL import Image
import matplotlib.pyplot as plt


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


def closing(padImg, kernel, size):
    # First apply Dilation
    dilation = Dilation(padImg, size)
    padImg2 = padding(dilation, size//2)
    # secondly apply Erosion on Dilated
    output = Erosion(padImg2, kernel, size)
    return output


def convex(img):
    pad_img = padding(img, 1)
    changed = True

    mask_1 = np.array([[1, 1, 0], [1, -1, 0], [1, 0, -1]])
    mask_2 = np.array([[1, 1, 1], [1, -1, 0], [0, -1, 0]])
    # output = np.zeros((rows, columns), dtype=np.uint8)
    output = np.full((rows, columns), False)

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


if __name__ == '__main__':
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
    # image reading
    #orginalImg = np.array(Image.open('P1/img/circles.png'))
    originalImg = cv.imread('P1/img/figure.png', 0)
    print(type(originalImg))
    # getting size of image
    rows = originalImg.shape[0]
    columns = originalImg.shape[1]
    print(rows, columns)
    # padding function call
    # padImg = padding(originalImg, p_size)

    # zad3
    # output = closing(padImg, mask, 3)

    # zad4
    output = convex(originalImg)

    output_img = Image.fromarray(np.uint8(output))
    plt.imshow(output, cmap="gray")
    plt.show()

    output_img.save("P1/img/result.png")
