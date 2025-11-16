import numpy as np
import matplotlib.pyplot as plt

curvealtitude = 63000
startturnaltitude = 1000
altitude = np.linspace(0, curvealtitude +  startturnaltitude, 1000)
exponents = {
    "Steeper Start (0.3)": 0.3,
    "Steeper Start (0.5)": 0.5,
    "Standard Cosine (1.0)": 1.0,
    "Steeper End (2.0)": 2.0,
    "Steeper End (3.0)": 3.0
}
plt.figure(figsize=(10, 6))

for key, exponent in exponents.items():
    pitch = 90 * (np.cos((np.pi / 2) * (altitude - startturnaltitude) / curvealtitude)) ** exponent
    plt.plot(altitude, pitch, label=key)


plt.title("Flight curve plot")
plt.xlabel("altitude")
plt.ylabel("pitch")

plt.legend()
plt.grid(True)
plt.show()