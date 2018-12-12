library(ggplot2)

df = read.csv('ev_ownership_by_state_long.csv')
df$year = as.factor(df$year)
p <- ggplot(df, aes(x=year, y=share)) + 
  geom_boxplot(outlier.size=0)+
  geom_jitter(width = 0.1)+
  geom_smooth(aes(x = as.numeric(df$year),y = share),method = lm, se = FALSE)

p = p + labs(y = 'Electric Car Market Share(%)', 
             x = 'Year', 
             title = 'Electric Car Market Share by State')+
  theme(plot.title = element_text(size=15,hjust = 0.5))