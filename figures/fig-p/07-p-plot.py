import statsmodels.api as sm
my_data = sm.datasets.get_rdataset('cars', 'datasets').data
my_data.plot(x='speed', style='o')
import matplotlib.pyplot as plt
plt.savefig('07-p-plot.pdf')
