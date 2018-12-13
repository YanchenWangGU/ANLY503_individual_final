import pandas as pd 
from wordcloud import WordCloud
import matplotlib.pyplot as plt

df = pd.read_csv('long_sale_by_make.csv')
df = df[df['year']==2017]
d = dict(zip(df.brand, df['count']))
wordcloud = WordCloud(background_color ='white')
wordcloud.generate_from_frequencies(frequencies=d)
                                    
plt.figure()
plt.imshow(wordcloud, interpolation="bilinear")
plt.axis("off")
plt.title('Top Selling Electric Vehicle Brands in 2017')
plt.show()