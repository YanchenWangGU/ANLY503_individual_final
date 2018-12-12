#package used for map plotting
library(leaflet)
#package used for reading in shape file
library(rgdal)
library(OneR)
#read in shape file: https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html
us.map <- readOGR(dsn = ".", layer = "cb_2017_us_state_20m", stringsAsFactors = FALSE)
us.map = us.map[1:52,]
#us.map$NAME
#a = na.omit(us.map)

ownership <- read.csv('ev_ownership_by_state.csv')
gas_price <- read.csv('gas_price.csv')
df = merge(ownership,gas_price,by='state')
df$current_share = as.character(df$current_share)
df$current_share = substr(df$current_share,1,nchar(df$current_share)-1)
df$current_share = as.numeric(df$current_share)
loc = read.csv('charging_sta_count.csv')

#replace the dataframe in shape.file with the dataframe we created in
#us.map@data = df
us.map = us.map[us.map$NAME != "Puerto Rico", ]
new_df = merge(us.map,df,by.x = "NAME",by.y = 'state')
new_df = merge(new_df,loc,by.x = "STUSPS",by.y = 'State')
lat_long = read.csv('combine.csv')
lat_long = lat_long[c('NAME','LAT','LON')]
new_df = merge(new_df,lat_long,by='NAME')
#create a bins palette
mybins_1=c(0,0.5,1,2,3,4,6,8,Inf)
mypalette_1 = colorBin( palette="YlGnBu", domain=new_df$current_share, na.color="transparent", bins=mybins_1)

mybins_2=c(0,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,3,Inf)
mypalette_2 = colorBin( palette="YlOrBr", domain=new_df$price, na.color="transparent", bins=mybins_2)

#create a highlight text
mytext=paste("State: ", new_df$NAME,"<br/>", "Electric Vehicle Market Share: ", new_df$current_share,"%","<br/>", "Average Gas Price (Regular): $", new_df$price, sep="") %>%
  lapply(htmltools::HTML)

#create pop up text
population_pop_up <- paste0("<strong>State: </strong>", 
                            new_df$NAME, 
                            "<br><strong>Number of EV Charging Stations: </strong>", 
                            new_df$sta_count)


gmap = leaflet(new_df) %>%
  addTiles()  %>%
  setView( lng=-105, lat=40 , zoom=3) %>%
  #first layer
  addPolygons(
    fillColor = ~mypalette_1(new_df$current_share), stroke=TRUE, fillOpacity = 0.9, color="white", weight=0.3,
    highlight = highlightOptions( weight = 5, color = ~colorNumeric("Blues", new_df$current_share), dashArray = "", fillOpacity = 0.3, bringToFront = TRUE),
    label = mytext,
    labelOptions = labelOptions( style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", direction = "auto"),
    group="Electric Vehicle Market Share"
  ) %>%
  #second layer
  addPolygons(
    fillColor = ~mypalette_2(new_df$price), stroke=TRUE, fillOpacity = 0.9, color="white", weight=0.3,
    highlight = highlightOptions( weight = 5, color = ~colorNumeric("Blues", new_df$price), dashArray = "", fillOpacity = 0.3, bringToFront = TRUE),
    label = mytext,
    labelOptions = labelOptions( style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", direction = "auto"),
    group="Average Gas Price"
  ) %>%
  
  #marker layer
  addMarkers(data=new_df,lat=new_df$LAT, lng=new_df$LON, popup=population_pop_up, group = "State Info") %>% 
  
  # Layers control
  addLayersControl(
    baseGroups = c("Electric Vehicle Market Share"),
    #overlayGroups = c("Rate2","State Info"),
    overlayGroups = c('Average Gas Price',"State Info"),
    options = layersControlOptions(collapsed = FALSE)
  )

gmap
saveWidget(gmap, 'leaflet_map.html', selfcontained = TRUE)