# source: http://jkunst.com/highcharter/index.html

# Highcharter is a R wrapper for Highcharts javascript libray and its modules


library("highcharter")

# Hello World Example

hc <- highchart() %>% 
  hc_chart(type = "column") %>% 
  hc_title(text = "A highcharter chart") %>% 
  hc_xAxis(categories = 2012:2016) %>% 
  hc_add_series(data = c(3900,  4200,  5700,  8500, 11900),
                name = "Downloads")

hc

# Generic Function hchart
# Among its features highcharter can chart various objects 
# with the generic2 hchart function and add themes.

data(diamonds, package = "ggplot2")

hchart(diamonds$price, color = "#B71C1C", name = "Price") %>% 
  hc_title(text = "You can zoom me")

hchart(diamonds$cut, colorByPoint = TRUE, name = "Cut")

#One of the nicest class which hchart can plot is the forecast class from the forecast package.

library("forecast")

airforecast <- forecast(auto.arima(AirPassengers), level = 95)

hchart(airforecast) %>%
  hc_title(text = "Charting Example using hchart") %>% 
  hc_add_theme(hc_theme_smpl())


# Highstock

library("quantmod")

usdjpy <- getSymbols("USD/JPY", src = "oanda", auto.assign = FALSE)
eurkpw <- getSymbols("EUR/KPW", src = "oanda", auto.assign = FALSE)

dates <- as.Date(c("2015-05-08", "2015-09-12"), format = "%Y-%m-%d")

highchart(type = "stock") %>% 
  hc_title(text = "Charting some Symbols") %>% 
  hc_subtitle(text = "Data extracted using quantmod package") %>% 
  hc_add_series_xts(usdjpy, id = "usdjpy") %>% 
  hc_add_series_xts(eurkpw, id = "eurkpw") %>% 
  hc_add_series_flags(dates,
                      title = c("E1", "E2"), 
                      text = c("Event 1", "Event 2"),
                      id = "usdjpy") %>% 
  hc_add_theme(hc_theme_flat()) 


# Highmaps

data(unemployment)
data(uscountygeojson)
library("viridisLite")


highchart() %>% 
  hc_title(text = "US Counties unemployment rates, April 2015") %>% 
  hc_add_series_map(uscountygeojson, unemployment,
                    value = "value", joinBy = "code") %>% 
  hc_colorAxis(dataClasses = color_classes(c(seq(0, 10, by = 2), 50),viridis(10, option = "C"))) %>% 
  hc_legend(layout = "vertical", align = "right",
            floating = TRUE, valueDecimals = 0,
            valueSuffix = "%") %>% 
  hc_mapNavigation(enabled = TRUE) 


# Let’s use a simple plot to show how do with the differentes funcions from the package.

data(citytemp)

hc <- highchart() %>% 
  hc_xAxis(categories = citytemp$month) %>% 
  hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
  hc_add_series(name = "London", data = citytemp$london) %>% 
  hc_add_series(name = "Other city",
                data = (citytemp$tokyo + citytemp$london)/2)

hc


# With hc_chart you can define general chart options.

hc %>% 
  hc_chart(borderColor = '#EBBA95',
           borderRadius = 10,
           borderWidth = 2,
           backgroundColor = list(
             linearGradient = c(0, 0, 500, 500),
             stops = list(
               list(0, 'rgb(255, 255, 255)'),
               list(1, 'rgb(200, 200, 255)')
             )))


# Now change type to colum and add 3d effect.

hc <- hc %>% 
  hc_chart(type = "column",
           options3d = list(enabled = TRUE, beta = 15, alpha = 15))

hc

# Now remove 3deffect and add the original type to work with the next examples.

hc <- hc_chart(hc, type = "line", options3d = list(enabled = FALSE))


# With hc_colors you can redefine general color options.

library("viridisLite")

cols <- viridis(3)
cols <- substr(cols, 0, 7)

hc %>% 
  hc_colors(cols)

# hc_xAxis and hc_yAxis
# This functions allow between other things:
  
  # 1. Modify the gridlines.
  # 2. Add plotBands or plotLines to remark some information.
  # 3. Show in the opposite side the axis.

hc %>% 
  hc_xAxis(title = list(text = "Month in x Axis"),
           opposite = TRUE,
           plotLines = list(
             list(label = list(text = "This is a plotLine"),
                  color = "#FF0000",
                  width = 2,
                  value = 5.5))) %>% 
  hc_yAxis(title = list(text = "Temperature in y Axis"),
           opposite = TRUE,
           minorTickInterval = "auto",
           minorGridLineDashStyle = "LongDashDotDot",
           showFirstLabel = FALSE,
           showLastLabel = FALSE,
           plotBands = list(
             list(from = 25, to = JS("Infinity"), color = "rgba(100, 0, 0, 0.1)",
                  label = list(text = "This is a plotBand")))) 


# hc_add_series and hc_rm_series
 
hc <- highchart() %>% 
  hc_xAxis(categories = citytemp$month) %>% 
  hc_add_series(name = "Tokyo", data = citytemp$tokyo) %>% 
  hc_add_series(name = "New York", data = citytemp$new_york) 

hc 

hc %>% 
  hc_add_series(name = "London", data = citytemp$london, type = "area") %>% 
  hc_rm_series(name = "New York")

# hc_title, hc_subtitle, hc_credits and hc_legend, hc_tooltip, hc_exporting
# Functions to modify the chart’s main title, subtitle, credits, legend and tooltip.

hc %>% 
  hc_title(text = "This is a title with <i>margin</i> and <b>Strong or bold text</b>",
           margin = 20, align = "left",
           style = list(color = "#90ed7d", useHTML = TRUE)) %>% 
  hc_subtitle(text = "And this is a subtitle with more information",
              align = "left",
              style = list(color = "#2b908f", fontWeight = "bold")) %>% 
  hc_credits(enabled = TRUE, # add credits
             text = "www.lonk.tomy.site",
             href = "http://jkunst.com") %>% 
  hc_legend(align = "left", verticalAlign = "top",
            layout = "vertical", x = 0, y = 100) %>%
  hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
             shared = TRUE, borderWidth = 5) %>% 
  hc_exporting(enabled = TRUE) # enable exporting option

# More examples:

# Scatter plot

highchart() %>%
  hc_title(text = "Scatter chat with size and color") %>%
  hc_add_series_scatter(mtcars$wt, mtcars$mpg,
                        mtcars$drat, mtcars$hp)
# Histogram

data(diamonds, package = "ggplot2")

hchart(diamonds$price, color = "#B71C1C", name = "Price") %>% 
  hc_title(text = "Histogram") %>% 
  hc_subtitle(text = "You can zoom me")

# Quadrants with annotations

n <- 50
df <- data.frame(x = rnorm(n), y = rnorm(n))
ds <- list.parse2(df)

df2 <- data.frame(x = c(1, -1, -1, 1)*2,
                  y = c(1, 1, -1, -1)*2,
                  text = paste("Quadrant", letters[1:4]))

ds2 <- list.parse3(df2)

highchart() %>% 
  hc_add_theme(hc_theme_538()) %>% 
  hc_add_serie(data = ds, name = "data", type = "scatter") %>% 
  hc_add_serie(data = ds2,
               name = "annotations",
               type = "scatter",
               color = "transparent",
               showInLegend = FALSE,
               enableMouseTracking = FALSE,
               dataLabels = list(enabled = TRUE, y = 10, format = "{point.text}",
                                 style = list(fontSize = "20px",
                                              color =  'rgba(0,0,0,0.70)')))


# Gauges like Apple Watch

highchart(width = 400, height = 400) %>% 
  hc_chart(
    type = "solidgauge",
    backgroundColor = "#F0F0F0",
    marginTop = 50
  ) %>% 
  hc_title(
    text = "Activity",
    style = list(
      fontSize = "24px"
    )
  ) %>% 
  hc_tooltip(
    borderWidth = 0,
    backgroundColor = 'none',
    shadow = FALSE,
    style = list(
      fontSize = '16px'
    ),
    pointFormat = '{series.name}<br><span style="font-size:2em; color: {point.color}; font-weight: bold">{point.y}%</span>',
    positioner = JS("function (labelWidth, labelHeight) {
                    return {
                    x: 200 - labelWidth / 2,
                    y: 180
                    };
                    }")
    ) %>% 
  hc_pane(
    startAngle = 0,
    endAngle = 360,
    background = list(
      list(
        outerRadius = '112%',
        innerRadius = '88%',
        backgroundColor = JS("Highcharts.Color('#F62366').setOpacity(0.1).get()"),
        borderWidth =  0
      ),
      list(
        outerRadius = '87%',
        innerRadius = '63%',
        backgroundColor = JS("Highcharts.Color('#9DFF02').setOpacity(0.1).get()"),
        borderWidth = 0
      ),
      list(
        outerRadius = '62%',
        innerRadius =  '38%',
        backgroundColor = JS("Highcharts.Color('#0CCDD6').setOpacity(0.1).get()"),
        borderWidth = 0
      )
    )
  ) %>% 
  hc_yAxis(
    min = 0,
    max = 100,
    lineWidth = 0,
    tickPositions = list()
  ) %>% 
  hc_plotOptions(
    solidgauge = list(
      borderWidth = '34px',
      dataLabels = list(
        enabled = FALSE
      ),
      linecap = 'round',
      stickyTracking = FALSE
    )
  ) %>% 
  hc_add_series(
    name = "Move",
    borderColor = JS("Highcharts.getOptions().colors[0]"),
    data = list(list(
      color = JS("Highcharts.getOptions().colors[0]"),
      radius = "100%",
      innerRadius = "100%",
      y = 80
    ))
  ) %>% 
  hc_add_series(
    name = "Exercise",
    borderColor = JS("Highcharts.getOptions().colors[1]"),
    data = list(list(
      color = JS("Highcharts.getOptions().colors[1]"),
      radius = "75%",
      innerRadius = "75%",
      y = 65
    ))
  ) %>% 
  hc_add_series(
    name = "Stand",
    borderColor = JS("Highcharts.getOptions().colors[2]"),
    data = list(list(
      color = JS("Highcharts.getOptions().colors[2]"),
      radius = "50%",
      innerRadius = "50%",
      y = 50
    ))
  )

# A spiderweb chart (Polígonos)

highchart() %>% 
  hc_chart(polar = TRUE, type = "line") %>% 
  hc_title(text = "Budget vs Spending") %>% 
  hc_xAxis(categories = c('Sales', 'Marketing', 'Development', 'Customer Support', 
                          'Information Technology', 'Administration'),
           tickmarkPlacement = 'on',
           lineWidth = 0) %>% 
  hc_yAxis(gridLineInterpolation = 'polygon',
           lineWidth = 0,
           min = 0) %>% 
  hc_series(
    list(
      name = "Allocated Budget",
      data = c(43000, 19000, 60000, 35000, 17000, 10000),
      pointPlacement = 'on'
    ),
    list(
      name = "Actual Spending",
      data = c(50000, 39000, 42000, 31000, 26000, 14000),
      pointPlacement = 'on'
    ),
    list(
      name = "Test de Raul",
      data = c(40000, 9000, 52000, 37000, 16000, 8000),
      pointPlacement = 'on'
    )
    
  )

# Funnels

highchart() %>% 
  hc_chart(type = "funnel") %>% 
  hc_add_theme(hc_theme_smpl()) %>% 
  hc_add_series(
    name = "Unique Users",
    data = list.parse3(
      data.frame(
        name = c("WS visits", "Downloads", "Requested", "Invoice", "Finalized"),
        y = c(15654, 4064, 1987, 976, 846)
      )
    )
  )

# World Chart

library("viridisLite")

data(worldgeojson, package = "highcharter")
data("GNI2010", package = "treemap")

dshmstops <- data.frame(q = c(0, exp(1:5)/exp(5)),
                        c = substring(viridis(5 + 1, option = "D"), 0, 7)) %>% 
  list.parse2()

highchart() %>% 
  hc_add_series_map(worldgeojson, GNI2010, value = "population", joinBy = "iso3") %>% 
  hc_colorAxis(stops = dshmstops) %>% 
  hc_legend(enabled = TRUE) %>% 
  hc_add_theme(hc_theme_db()) %>% 
  hc_mapNavigation(enabled = TRUE)


# Charting US states

library("dplyr")
library("viridisLite")

data("USArrests", package = "datasets")
data("usgeojson")

USArrests <- USArrests %>%
  mutate(state = rownames(.))

n <- 4
colstops <- data.frame(q = 0:n/n,
                       c = substring(viridis(n + 1, option = "A"), 0, 7)) %>%
  list.parse2()

highchart() %>%
  hc_title(text = "Violent Crime Rates by US State") %>%
  hc_subtitle(text = "Source: USArrests data") %>%
  hc_add_series_map(usgeojson, USArrests, name = "Murder arrests (per 100,000)",
                    value = "Murder", joinBy = c("woename", "state"),
                    dataLabels = list(enabled = TRUE,
                                      format = '{point.properties.postalcode}')) %>%
  hc_colorAxis(stops = colstops) %>%
  hc_legend(valueDecimals = 0, valueSuffix = "%") %>%
  hc_mapNavigation(enabled = TRUE)


# Highcharter include some plugins for highcharts 
# Motion is one of them

highchart() %>% 
  hc_chart(type = "column") %>% 
  hc_yAxis(max = 6, min = 0) %>% 
  hc_add_series(name = "A", data = c(2,3,4), zIndex = -10) %>% 
  hc_add_series(name = "B",
                data = list(
                  list(sequence = c(1,2,3,4)),
                  list(sequence = c(3,2,1,3)),
                  list(sequence = c(2,5,4,3))
                )) %>% 
  hc_add_series(name = "C",
                data = list(
                  list(sequence = c(3,2,1,3)),
                  list(sequence = c(2,5,4,3)),
                  list(sequence = c(1,2,3,4))
                )) %>% 
  hc_motion(enabled = TRUE,
            labels = 2000:2003,
            series = c(1,2))

# Parece que no va el hc_motion


# More info, plugins, themes and examples:
# http://jkunst.com/highcharter/shortcuts.html
# http://jkunst.com/highcharter/shortcuts.html
# http://jkunst.com/highcharter/themes.html
# http://jkunst.com/highcharter/highcharts.html
