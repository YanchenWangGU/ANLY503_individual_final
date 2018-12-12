library(plotly)

df = read.csv('us_stock_sale.csv')
df$year = df$year
p <- plot_ly(df, x = ~year, y = ~sales, type = 'scatter', mode = 'lines') %>%
               layout(title = "Electric Vehicle Sales",
                      xaxis = list(title = "Year"),
                      yaxis = list (title = "Number of Electric Vehicles Sold (in Thousands)"))


chart_link = api_create(p, filename="indiv_line")
chart_link