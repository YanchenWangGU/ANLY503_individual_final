library(ggplot2)

df = read.csv('ev_ownership_by_state_long.csv')
df = subset(df, year ==2018)
df1 = read.csv('gas_price.csv')
df = merge(df,df1,by='state')

p <- ggplot(df, aes(x=price, y=share)) + 
  geom_point()+ 
  geom_smooth(se = FALSE)+ 
  geom_smooth(method = lm, formula = y ~ x, colour = 'red',se = FALSE)+
  labs(y = 'Electric Car Market Share(%)', 
       x = 'Gasoline Price (Regular Grade, $/Gallon)', 
       title = 'Electric Car Market Share vs Gasoline Price')+
  theme(plot.title = element_text(size=15,hjust = 0.5))

p

fit = lm(formula = share ~ price, data = df)
summary(fit)