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


if __name__ == '__main__':
    size = 3
    # Structuring Element
    kernel = np.ones((size, size), np.uint8)
    # padding size
    p_size = size//2
    # image reading
    #orginalImg = np.array(Image.open('P1/img/circles.png'))
    originalImg = cv.imread('P1/img/test.png', 0)
    print(type(originalImg))
    # getting size of image
    rows = originalImg.shape[0]
    columns = originalImg.shape[1]
    print(rows, columns)
    # padding function call
    padImg = padding(originalImg, p_size)

    # Then applu closing to remove gaps
    output = closing(padImg, kernel, 3)
    output_img = Image.fromarray(np.uint8(output))
    plt.imshow(output, cmap="gray")
    plt.show()

    # test_img = np.zeros(shape=(200, 200))
    # test_img[50:150, 50:150] = 1
    # from itertools import combinations
    # from random import sample

    # n = 100
    # x = sample(range(50, 150), 100)
    # y = sample(range(50, 150), 100)
    # for i in range(100):
    #     test_img[x[i], y[i]] = 0

    # print(np.sum(test_img))
    # output = Image.fromarray(np.bool8(test_img))
    # output.save("P1/img/test.png")
