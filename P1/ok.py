from PIL import Image
import numpy as np

image = ""


def transformation():
    global image

    while 1:
        print("Podaj ścieżkę do obrazu, na którym chcesz dokonać przekształceń: \n")
        path = input()

        image = Image.open(path)
        image = np.array(image)

        print("Dostępne przekształcenia: \n")
        transformations = ["przekształcenie afiniczne", "filtracja entropii", "zamknięcie elementem kołowym",
                           "wypukłe otoczenie"]
        for i, name in enumerate(transformations):
            print("{}. {}".format(i + 1, name))

        choice = int(input())

        if choice == 1:
            print("Podaj 4 wartości macierzy przekształcenia afinicznego")

            tab = []
            for i in range(4):
                tab.append(float(input()))

            affine(image, tab[0], tab[1], tab[2], tab[3])

        elif choice == 2:
            print("Podaj rozimar okna, w którym chcesz dokonać filtracji (liczba nieparzysta)")

            size = int(input())
            if size % 2 == 0:
                print("Error: rozmiar maski powinien być liczbą nieparzystą")
                exit(2)

            entropyFilter(image, size)

        elif choice == 3:
            print("Podaj promień elementu kołowego")

            r = int(input())

            close(image, circle(r))

        elif choice == 4:
            convex(image)

        else:
            print("Error: podano błędny numer przekształcenia")
            exit(2)


def circle(r):
    size = 2 * r + 1
    SE = np.zeros((size, size))

    for i in range(size):
        for j in range(size):
            if (r - i) ** 2 + (r - j) ** 2 <= r ** 2:
                SE[i, j] = 1
    return SE


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


def close(img, SE):
    res = erode(dilate(img, SE), SE)
    res = Image.fromarray(res)
    res.save(fp="close.png", format="png")


def convex(img):
    img = np.array(img)

    SE1 = np.array([[1, 1, 0], [1, -1, 0], [1, 0, -1]])
    SE2 = np.array([[1, 1, 1], [1, -1, 0], [0, -1, 0]])

    [N, M] = img.shape
    cmp = np.full((N, M), False)

    while not np.array_equal(img, cmp):
        cmp = img

        for i in range(1, 5):
            img = np.logical_or(img, hitmiss(img, SE1))
            img = np.logical_or(img, hitmiss(img, SE2))
            SE1 = np.rot90(SE1)
            SE2 = np.rot90(SE2)

    res = Image.fromarray(img)
    res.save(fp="convex.png", format="png")


def hitmiss(img, SE):
    img = np.array(img)

    [N, M] = img.shape
    n = SE.shape[0]

    res = np.full((N, M), False)

    side = int((n - 1) / 2)

    for i in range(side, N - side):
        for j in range(side, M - side):
            res[i, j] = compare(img[i - side:i + side + 1, j - side:j + side + 1], SE)

    return res


def compare(slc, SE):
    n = SE.shape[0]
    slc = np.where(slc <= 0, -1, slc)
    slc = np.where(slc > 0, 1, slc)

    for i in range(n):
        for j in range(n):
            if SE[i, j] == 0:
                continue
            elif SE[i, j] != slc[i, j]:
                return False
    return True


def affine(img, Ta, Tb, Tc, Td):
    img = np.array(img, copy=True)

    [N, M] = img.shape[:2]

    dims = img.ndim
    names = ["affine1.png", "affine2.png", "affine3.png"]

    img2 = np.array(img, copy=True)
    if dims == 3:
        img2[:, :, 0] = np.zeros((N, M))
        img2[:, :, 1] = np.zeros((N, M))
        img2[:, :, 2] = np.zeros((N, M))
    res = np.zeros((N, M))

    det = Ta * Td - Tb * Tc
    if det == 0:
        print("det=0")
        exit(2)

    for k in range(dims) if dims != 2 else range(1):
        for i in range(M):
            for j in range(N):

                xNew = int(Ta * i + Tc * j)
                yNew = int(Tb * i + Td * j)

                if M > xNew >= 0 and N > yNew >= 0:
                    res[yNew, xNew] = img[j, i] if dims == 2 else img[j, i, k]

        if dims == 2:
            res = Image.fromarray(res)
            if res.mode != 'RGB':
                res = res.convert('RGB')
            res.save(fp=names[k], format="png")
        else:
            img2[:, :, k] = res
            tmp = Image.fromarray(img2)
            tmp.save(fp=names[k], format="png")
            tmp.show()


def entropyFilter(img, maskSize):
    img = np.array(img, copy=True)
    res = np.zeros(img.shape[:2])

    [N, M] = img.shape[:2]
    dims = img.ndim

    side = int((maskSize - 1) / 2)

    for i in range(side, N - side):
        for j in range(side, M - side):
            reg = img[i - side:i + side + 1, j - side:j + side + 1] if dims == 2 else img[i - side:i + side + 1,
                                                                                      j - side:j + side + 1, :]
            res[i, j] = entropy(reg)

    min_entropy = min(res.flatten())
    max_entropy = max(res.flatten())
    res = (res - min_entropy) / (max_entropy - min_entropy) * 255
    res = res.astype(np.uint8)

    res = Image.fromarray(res)
    res.save(fp="entropy.png", format="png")


def entropy(slc):
    [A, B] = slc.shape[:2]

    hist = np.zeros(256)
    slc = slc.flatten()

    for i in slc:
        hist[i] += 1

    hist = hist / (A * B)
    hist = list(filter(lambda p: p > 0, hist))

    e = -np.sum(np.multiply(np.log(hist), hist))

    return e


transformation()
