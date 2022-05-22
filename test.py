import numpy as np

N = M = 3


def padding(img, pad):
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


a = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

b = padding(a, 3)
print(b)
