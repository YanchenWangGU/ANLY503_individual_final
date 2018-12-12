library(ggplot2)
library(gridExtra)
df = read.csv('us_stock_sale.csv')
df1 = read.csv('battery_price.csv')
df2 = merge(df,df1,by = 'year')

p = ggplot(data=df2, aes(year))
p = p+ geom_point(aes(y = price), fill = 'light blue')
p = p+ geom_line(aes(y = df2$price, colour = 'price'))
p = p+ geom_point(aes(y = sales*4, colour = 'sales'))
p = p+ geom_line(aes(y = sales*4, colour = 'sales'))
p = p+ scale_y_continuous(sec.axis = sec_axis(~./4, name = 'Sales Volume in Thousands'))
p = p + scale_color_manual(labels = c("Battery Price", "Sales"),values = c('blue','red'))
p = p + labs(y = 'Battery Cost/kWh', 
             x = 'Year', 
             colour = 'parameter',
             title = 'Electric Car Sales vs Battery Cost')+
  theme(plot.title = element_text(size=15,hjust = 0.5))
p

df3 = read.csv('gas_nation_by_yr.csv')
df2 = merge(df2,df3, by = 'year')

p1 = ggplot(data=df2, aes(year))
p1 = p1+ geom_point(aes(y = gas_price), fill = 'light blue')
p1 = p1+ geom_line(aes(y = df2$gas_price, colour = 'gas_price'))
p1 = p1+ geom_point(aes(y = sales/50, colour = 'sales'))
p1 = p1+ geom_line(aes(y = sales/50, colour = 'sales'))
p1 = p1+ scale_y_continuous(sec.axis = sec_axis(~.*50, name = 'Sales Volume in Thousands'))
p1 = p1 + scale_color_manual(labels = c("Gasoline Price", "Sales"),values = c('blue','red'))
p1 = p1 + labs(y = 'Regular Gasoline Price per Gallon', 
             x = 'Year', 
             colour = 'parameter',
             title = 'Electric Car Sales vs Gasoline Price')+
  theme(plot.title = element_text(size=15,hjust = 0.5))
p1

grid.arrange(p,p1,nrow=2)

