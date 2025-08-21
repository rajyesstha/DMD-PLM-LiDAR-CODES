import matplotlib.pyplot as plt
import numpy as np

# Data
orders = np.arange(-2, 5)  # Orders from -2 to 4
theoretical_angles = np.array([63.4, 53.2, 45.0, 37.8, 31.3, 25.2, 19.4])  # Theoretical angles in degrees
measured_angles = np.array([64.0, 54.0, 45.0, 37.5, 32.0, 26.0, 20.0])  # Measured angles in degrees

# Create figure and axis with specified size for publication
plt.figure(figsize=(8, 6), dpi=500)

# Plot data
plt.plot(orders, theoretical_angles, 'o-', label='Theoretical', color='#1f77b4', markersize=8, linewidth=2)
plt.plot(orders, measured_angles, 's--', label='Measured', color='#ff7f0e', markersize=8, linewidth=2)

# Add annotations for theoretical and measured angles
for i, (order, theo, meas) in enumerate(zip(orders, theoretical_angles, measured_angles)):
    # Theoretical angles (slightly above the point)
    plt.annotate(f'{theo:.1f}°', 
                  (order, theo), 
                  textcoords="offset points", 
                  xytext=(0, 10), 
                  ha='center', 
                  fontsize=10, 
                  color='#1f77b4')
    # Measured angles (slightly below the point)
    plt.annotate(f'{meas:.1f}°', 
                  (order, meas), 
                  textcoords="offset points", 
                  xytext=(0, -15), 
                  ha='center', 
                  fontsize=10, 
                  color='#ff7f0e')

# Customize plot
plt.xlabel('Diffraction Orders', fontsize=14, fontweight='regular')
plt.ylabel('Diffraction Angle (°)', fontsize=14, fontweight='regular')


plt.title(
    r'Theoretical vs Measured Diffraction Angles at $\theta_{\mathrm{inc}} = 45^\circ$',
    fontsize=16,
    fontweight='regular',
    pad=15
)


# Set grid with dashed lines
plt.grid(True, linestyle='--', alpha=0.7)

# Customize ticks
plt.xticks(orders, fontsize=12)
plt.yticks(fontsize=12)

# Add legend
plt.legend(fontsize=12, loc='upper right', frameon=True, edgecolor='black')

# Adjust layout to prevent label cutoff
plt.tight_layout()

# Save the plot as a high-resolution JPG for publication
plt.savefig('diffraction_angles.jpg', format='jpg', bbox_inches='tight')

# Display the plot
plt.show()






#for nonlineariity test of dmd anlges of incidences
# import matplotlib.pyplot as plt
# import numpy as np
# from matplotlib import rcParams

# # Configure font settings
# rcParams['font.family'] = 'sans-serif'
# rcParams['font.sans-serif'] = ['DejaVu Sans']
# rcParams['text.usetex'] = True  # Enable LaTeX only for specific elements

# # Input parameters
# lambda_ = 0.905  # Wavelength in micrometers
# pitch = 13.68 / np.sqrt(2)  # Pitch in micrometers
# theta_i_values = [0, 30, 45]  # Incident angles in degrees
# orders = [np.arange(-2, 5)] * 3  # Orders from -2 to 4 for each angle
# line_colors = ['#1f77b4', '#2ca02c', 'red']  # Blue (0°), Green (30°), Red (45°)
# markers = ['s', 'o', 'd']  # Square, circle, diamond

# # Initialize figure with publication quality settings
# fig = plt.figure(figsize=(8, 6), dpi=300)
# ax = fig.add_subplot(111)

# legend_entries = []
# plot_handles = []

# # Calculate y-axis limits by computing all diffraction angles
# all_theta_d = []
# for i, theta_i in enumerate(theta_i_values):
#     curr_orders = orders[i]
#     arg = np.sin(np.radians(theta_i)) - curr_orders * lambda_ / pitch
#     theta_d = np.degrees(np.arcsin(np.clip(arg, -1, 1)))
#     all_theta_d.extend(theta_d)
# y_min, y_max = min(all_theta_d) - 10, max(all_theta_d) + 3  # Increased padding for looser fit

# # Loop through incident angles
# for i, theta_i in enumerate(theta_i_values):
#     curr_orders = orders[i]
    
#     # Calculate diffraction angles with clipping
#     arg = np.sin(np.radians(theta_i)) - curr_orders * lambda_ / pitch
#     theta_d = np.degrees(np.arcsin(np.clip(arg, -1, 1)))
    
#     # Calculate regression slope
#     p = np.polyfit(curr_orders, theta_d, 1)  # Linear fit: p[0] is slope, p[1] is intercept
#     slope = p[0]
    
#     # Plot with professional styling and store handle
#     line, = ax.plot(curr_orders, theta_d, color=line_colors[i], linewidth=2, linestyle='-')
#     ax.scatter(curr_orders, theta_d, s=100, marker=markers[i], 
#                edgecolors='white', facecolors=line_colors[i], linewidths=1.5)
#     plot_handles.append(line)
    
#     # Annotate data points directly below the slope lines with adjusted offset
#     for j, order in enumerate(curr_orders):
#         y_pos = theta_d[j]
#         ax.annotate(f'{y_pos:.1f}°', 
#                     (order, y_pos), 
#                     textcoords="offset points", 
#                     xytext=(0, -20),  # Increased negative offset for looser fit
#                     ha='center', 
#                     va='top',  # Align top of text with point
#                     fontsize=10)
    
#     # Store legend entry with LaTeX for θ_i
#     legend_entries.append(f'$\\theta_i = {theta_i}^\\circ$, slope = {slope:.2f}')

# # Axis formatting
# ax.set_xlim(-2.5, 4.5)
# ax.set_ylim(y_min, y_max)
# ax.set_xlabel('Diffraction Order', fontsize=14, fontweight='regular')
# ax.set_ylabel('Diffraction Angle (°)', fontsize=14, fontweight='regular')
# ax.set_title(
#     f'Diffraction Angles vs. Orders at Multiple Incident Angles on DLP7000\n'
#     f'$p = 13.68/\\sqrt{{2}} \\, \\mu\\mathrm{{m}}$, $\\theta_{{\\mathrm{{inc}}}} = [0^\\circ, 30^\\circ, 45^\\circ]$',
#     fontsize=16, fontweight='bold', pad=15)

# # Grid and tick styling
# ax.grid(True, linestyle='--', alpha=0.7)
# ax.tick_params(axis='both', which='major', direction='in', length=6, width=1, labelsize=12)
# ax.tick_params(axis='both', which='minor', direction='in', length=3, width=1)

# # Legend with explicit handles
# ax.legend(plot_handles, legend_entries, loc='best', fontsize=12, frameon=True, edgecolor='black')

# # Final adjustments
# ax.set_axisbelow(False)
# ax.set_box_aspect(1)
# plt.tight_layout()

# # Save the plot with extra padding for a looser fit
# plt.savefig('diffraction_angles_multi.jpg', format='jpg', bbox_inches='tight', pad_inches=0.2)

# # Display the plot
# plt.show()