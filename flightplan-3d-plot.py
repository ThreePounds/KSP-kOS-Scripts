import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

df = pd.read_csv('log/Y001D001_08-49-28.csv')
df.head()

X = df[['longitude']]
Y = df[['latitude']]
Z = df[['altitude']]

fig = plt.figure()
ax = fig.add_subplot(projection='3d')
ax.scatter(X, Y, Z)
plt.show()