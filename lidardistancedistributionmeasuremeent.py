import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm
from scipy.ndimage import median_filter, label

# === CONFIGURABLE PARAMETERS ===
file_paths = [
    "21.07.2025/-2/Y.txt",
    "21.07.2025/-2/O.txt",
    "21.07.2025/-2/U.txt",
    "21.07.2025/-2/Z.txt",
    "21.07.2025/-2/D.txt"
]

labels = ['Y', 'O', 'U', 'Z', 'D']
colors = ['blue', 'green', 'orange', 'purple', 'red']

mppc_pixels       = 32
frame_size        = mppc_pixels ** 2
start_frame       = 10
end_frame         = 300
median_filter_size = 2
valid_range       = (80, 200)
lens_offset       = 9
ns                = 1e-9
c_cm_per_s        = 2.99e10
round_trip        = 0.5
slope, offset     = -1.9, 861
c_adjust          = 0.15
iqr_bounds        = (45, 55)

# === HELPER FUNCTION ===
def extract_iqr_data(file_path):
    raw = np.loadtxt(file_path, dtype=str)
    img = np.array([int(d[6:10], 16) for d in raw])
    tof_ns = img * slope + offset
    tof_array = (tof_ns * ns * c_cm_per_s * round_trip * c_adjust) - lens_offset

    stacked = np.zeros((mppc_pixels, mppc_pixels))
    valid_counts = np.zeros_like(stacked)

    for f in range(start_frame, end_frame + 1):
        s, e = (f - 1) * frame_size, f * frame_size
        if e > len(tof_array):
            break
        frame = tof_array[s:e].reshape(mppc_pixels, mppc_pixels)
        frame = median_filter(frame, size=median_filter_size)
        mask = (frame >= valid_range[0]) & (frame <= valid_range[1])
        frame_masked = np.where(mask, frame, np.nan)
        stacked += np.nan_to_num(frame_masked, nan=0.0)
        valid_counts += mask.astype(int)

    with np.errstate(invalid='ignore'):
        avg_frame = stacked / valid_counts
        avg_frame[valid_counts == 0] = np.nan

    # Keep only largest object
    mask = ~np.isnan(avg_frame) & (avg_frame < valid_range[1])
    labeled, num = label(mask)
    if num == 0:
        return np.array([])
    max_label = np.argmax(np.bincount(labeled.ravel()[labeled.ravel() > 0]))
    object_mask = labeled == max_label
    target_frame = np.where(object_mask, avg_frame, np.nan)

    # IQR filtering
    data = target_frame[~np.isnan(target_frame)]
    q_low, q_high = np.percentile(data, iqr_bounds)
    return data[(data >= q_low) & (data <= q_high)]

# === PROCESS FILES ===
iqr_data_list = [extract_iqr_data(fp) for fp in file_paths]

# === PLOT ===
plt.figure(figsize=(14, 7), dpi=300)
x = np.linspace(valid_range[0], valid_range[1], 1000)
bins = np.linspace(valid_range[0], valid_range[1], 300)
bin_width = bins[1] - bins[0]

for data, label, color in zip(iqr_data_list, labels, colors):
    if len(data) == 0:
        continue

    mu, sigma = np.mean(data), np.std(data)

    # Plot raw histogram (not normalized)
    counts, _, _ = plt.hist(
        data, bins=bins, density=False,
        alpha=0.4, color=color, edgecolor='white'
    )

    # Scale Gaussian to match histogram counts
    pdf = norm.pdf(x, mu, sigma)
    scaled_pdf = pdf * len(data) * bin_width

    plt.plot(
        x, scaled_pdf, lw=2.5, color=color,
        label=f"{label}: μ = {mu:.2f} cm, σ = {sigma:.2f} cm"
    )

# === FORMATTING ===
plt.title("LiDAR Measured Distance Distributions at Diffraction Order -2",
          fontsize=25, fontweight='normal', pad=15)
plt.xlabel("Distance (cm)", fontsize=20, labelpad=10)
plt.ylabel("Valid TOF Counts", fontsize=20, labelpad=10)
plt.xticks(fontsize=12)
plt.yticks(fontsize=12)
plt.grid(alpha=0.3)
plt.legend(fontsize=15, loc="upper right", frameon=True)
plt.tight_layout()
plt.show()
