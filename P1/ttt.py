import matplotlib.pyplot as plt
import numpy as np

R = 20
n = 2*R + 1
center = (R, R)
mask = np.zeros(shape=(n, n))
for x in range(n):
    for y in range(n):
        dist = ((center[0] - x)**2 + (center[1] - y)**2)**0.5
        if dist <= R:
            mask[x, y] = 1
