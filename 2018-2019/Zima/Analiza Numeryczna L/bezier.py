import seaborn
import math
import matplotlib.pyplot as plt


def binomial(i, n):
    """Binomial coefficient"""
    return math.factorial(n) / float(
        math.factorial(i) * math.factorial(n - i))


def bernstein(t, i, n):
    """Bernstein polynom"""
    return binomial(i, n) * (t ** i) * ((1 - t) ** (n - i))


def bezier(t, points):
    """Calculate coordinate of a point in the bezier curve"""
    n = len(points) - 1
    x = y = 0
    for i, pos in enumerate(points):
        bern = bernstein(t, i, n)
        x += pos[0] * bern
        y += pos[1] * bern
    return x, y


def bezier_curve_range(n, points):
    """Range of points in a curve bezier"""
    for i in xrange(n):
        t = i / float(n - 1)
        yield bezier(t, points)



controlPoints = (
        (0, 0), 
        (3.5, 36), 
        (25, 25), 
        (25, 1.5))
def curve = bezier_curve_range(100, controlPoints)
def curve_val = list(curve)

ax = curve_val.plot(num_pts=256)
plt.show()
        


