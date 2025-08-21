import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression

# --- Data ---
ground_truth = np.array([
    117, 127, 137, 147, 110, 125, 137, 158, 168,
    102, 125, 133, 152, 162, 103, 124, 134, 147, 170,
    92, 108, 111, 145, 163, 105, 120, 132, 155, 167,
    115, 125, 140, 155, 160
])

computed = np.array([
    120.03, 133.13, 143.89, 153.77, 111.68, 126.45, 138.79, 159.47, 169.75,
    103.37, 126.87, 134.22, 154.47, 164.48, 103.16, 124.01, 134.58, 147.09, 170.34,
    93.49, 109.92, 112.18, 146.42, 164.75, 106.38, 122.99, 133.46, 158.83, 170.45,
    116.79, 127.45, 141.79, 157.79, 161.74
])

errors = np.array([
    3.03, 6.13, 6.89, 6.77, 1.68, 1.45, 1.79, 1.47, 1.75,
    1.37, 1.87, 1.22, 2.47, 2.48, 0.16, 0.01, 0.58, 0.09, 0.34,
    1.49, 1.92, 1.18, 1.42, 1.75, 1.38, 2.99, 1.46, 3.83, 3.45,
    1.79, 2.45, 1.79, 2.79, 1.74
])

orders = [
    '-2Y', '-2O', '-2U', '-2Z',
    '-1Y', '-1O', '-1U', '-1Z', '-1D',
    '0Y',  '0O',  '0U',  '0Z',  '0D',
    '1Y',  '1O',  '1U',  '1Z',  '1D',
    '2Y',  '2O',  '2U',  '2Z',  '2D',
    '3Y',  '3O',  '3U',  '3Z',  '3D',
    '4Y',  '4O',  '4U',  '4Z',  '4D'
]

# --- Plotting ---
unique_orders = sorted(list(set(o[:-1] for o in orders)), key=lambda x: int(x))
colors = plt.cm.viridis(np.linspace(0, 1, len(unique_orders)))

plt.figure(figsize=(11, 6), dpi=300)

for order, color in zip(unique_orders, colors):
    indices = [i for i, o in enumerate(orders) if o.startswith(order)]
    x = ground_truth[indices]
    y = computed[indices]
    yerr = errors[indices]
    labels = [orders[i] for i in indices]

    # Scatter with error bars
    plt.errorbar(x, y, yerr=yerr, fmt='o', capsize=4, color=color, label=f"Order {order}")

    # Annotate points (e.g., '2Y')
    #for xi, yi, label in zip(x, y, labels):
     #   plt.text(xi + 0.5, yi + 0.5, label, fontsize=8, color=color)

    # Linear fit
    model = LinearRegression().fit(x.reshape(-1, 1), y)
    x_fit = np.linspace(min(x), max(x), 100)
    y_fit = model.predict(x_fit.reshape(-1, 1))
    plt.plot(x_fit, y_fit, linestyle='-', color=color)

# --- Formatting ---
plt.title("Linear Regression Analysis for Distance at 7 Diffraction Orders", fontsize=25)
plt.xlabel("Ground Truth Distance (cm)", fontsize=20)
plt.ylabel("Measured Distance with TOF (cm)", fontsize=20)
plt.grid(True, alpha=0.3)
plt.legend(title="Diffraction Order", fontsize=12, loc="upper left", frameon=True)
plt.tight_layout()
plt.show()
