library(ggplot2)

df = read.csv('ev_ownership_by_state_long.csv')
df = subset(df, year ==2018)
df1 = read.csv('income.csv')
df = merge(df,df1,by='state')