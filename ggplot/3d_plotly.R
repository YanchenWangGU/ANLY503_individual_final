library(plotly)
library(reshape2)
df = read.csv('ev_ownership_by_state_long.csv')
df = subset(df, year ==2018)
df1 = read.csv('income.csv')
df = merge(df,df1, by = 'state')
df2 = read.csv('gas_price.csv')
df = merge(df,df2, by = 'state')
df$income = df$income
df$income = as.numeric(df$income)
fit = lm(share~price+income, data = df)
summary(fit)

axis_x <- seq(min(df$price), max(df$price), by = 0.1)
axis_y <- seq(min(df$income), (max(df$income)), by = 1000)
petal_lm_surface <- expand.grid(price = axis_x,income = axis_y,KEEP.OUT.ATTRS = F)
petal_lm_surface$share <- predict.lm(fit, newdata = petal_lm_surface)
petal_lm_surface <- acast(petal_lm_surface, income ~ price, value.var = "share")

p <- plot_ly(x = df$price, y = df$income, z = df$share,name='State',text = df$state) %>%
  add_markers()%>%
  layout(title='3D Scatter Plot of Electric Car Market \nShare, Gasoline Price and Income',
         scene = list(xaxis = list(title = 'Gasoline Price ($/Gallon)'),
                      yaxis = list(title = 'Annual Household Income ($)'),
                      zaxis = list(title = 'Electric Car Market Share (%)')))
p = p %>% add_trace(z = petal_lm_surface,x = axis_x,
                    y = axis_y,
                    type = "surface",name = 'Predicted Market Share')
p
chart_link = api_create(p, filename="3d_rotatable2")
chart_link



