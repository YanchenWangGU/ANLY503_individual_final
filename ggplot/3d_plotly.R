library(plotly)
df = read.csv('ev_ownership_by_state_long.csv')
df = subset(df, year ==2018)
df1 = read.csv('income.csv')
df = merge(df,df1, by = 'state')
df2 = read.csv('gas_price.csv')
df = merge(df,df2, by = 'state')


p <- plot_ly(x = df$share, y = df$price, z = df$income,name='State',text = df$state) %>%
  add_markers()%>%
  layout(title='3D Scatter Plot of Electric Car \nMarket Share, Gasoline Price and Income',
         scene = list(xaxis = list(title = 'Electric Car Market Share (%)'),
                      yaxis = list(title = 'Gasoline Price ($/Gallon)'),
                      zaxis = list(title = 'Annual Household Income ($)')))
chart_link = api_create(p, filename="3d_rotatable1")
chart_link