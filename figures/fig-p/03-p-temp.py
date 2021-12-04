import matplotlib.pyplot as plt
import pandas as pd

my_df = pd.DataFrame({
    'day': [25, 26, 27],
    'min': [20, 21, 15],
    'max': [24, 27, 21]})

my_longer = my_df.melt(id_vars='day')

my_wider = my_longer.pivot(
    index='day',
    columns='variable',
    values='value')

my_wider.plot(style='o-',
              xticks=my_wider.index,
              ylabel='temperature')

plt.savefig('03-p-temp.pdf')
