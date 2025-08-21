# -*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression

# Your data
orders = np.array([-2, -1, 0, 1, 2, 3, 4])
ground_truth = np.array([124, 118, 125, 123, 124.5, 135, 125])
measured_mean = np.array([124.66, 117.86, 124.41, 124.52, 124.67, 135.06, 124.64])
measured_std = np.array([2.4, 2.86, 3.58, 2.43, 2.44, 2.87, 2.39])

# Reshape for sklearn
X = ground_truth.reshape(-1, 1)
y = measured_mean

# Fit linear regression
model = LinearRegression()
model.fit(X, y)
y_pred = model.predict(X)

slope = model.coef_[0]
intercept = model.intercept_

# Plot
plt.figure(figsize=(8,6), dpi=150)

# Data with error bars
plt.errorbar(ground_truth, measured_mean, yerr=measured_std/5,
             fmt='o', capsize=4, color='black', label='Data with Error Bars')

# Linear fit
plt.plot(ground_truth, y_pred, 'r-', linewidth=1.5, label='Linear Fit')

# Annotate each point with diffraction order
for gt, meas, order in zip(ground_truth, measured_mean, orders):
    plt.annotate(f"{order}", (gt, meas), textcoords="offset points", xytext=(5,-10), fontsize=8)

# Labels & legend
plt.xlabel("Ground Truth (cm)")
plt.ylabel("Measured with ToF (cm)")
plt.title("Linear Regression Analysis of distance measurement for seven diffraction orders")
plt.legend()
plt.grid(alpha=0.3)
plt.tight_layout()
plt.show()
