
# source: http://moderndata.plot.ly/radial-bar-charts-in-r-using-plotly/

# inspired by 
# https://s-media-cache-ak0.pinimg.com/736x/22/1a/d0/221ad079e362ba13969b1bef30b6a5f2.jpg

library(plotly)

# read in data
df <- read.csv("https://cdn.rawgit.com/plotly/datasets/master/Emissions%20Data.csv", stringsAsFactors = F)

# Show only 2011 values
df <- subset(df, Year == "2011")

# Arrange in increasing order of emissions
df <- df %>% dplyr::arrange(Emission)
df <- df[-(1:50),]

#  Add colors
colors <- RColorBrewer::brewer.pal(length(unique(df$Continent)), "Spectral")
continent <- unique(df$Continent)

df$colors <- df$Continent

for(i in 1:length(continent)){
  idx <- df$colors %in% continent[i]   
  df$colors[idx] <- colors[i]
}

# Get incremental angle value
n <- nrow(df) + 20
dtheta <- 2*pi / n
theta <- pi / 2

# Initialise
x.coord <- c()
y.coord <- c()
cols <- c()

# This is for the white - circle in the middle
adjust <-  20

# Initialize plot
p <- plot_ly()

for(ctr in 1:nrow(df)){
  
  a <- df$Emission[ctr] + adjust
  
  x1 <- adjust * cos(theta)
  y1 <- adjust * sin(theta)
  
  x2 <- a * cos(theta)
  y2 <- a * sin(theta)
  
  x.coord <- c(x.coord, x1, x2, NA)
  y.coord <- c(y.coord, y1, y2, NA)
  cols <- c(cols, df$Continent[ctr], df$Continent[ctr], NA)
  
  theta <- theta + dtheta
  
  p <- add_trace(p, 
                 x = c(x1, x2),
                 y = c(y1, y2),
                 mode = "lines", 
                 line = list(width = 5, color = df$colors[ctr]),
                 evaluate = T)
}

# Keep x and y axis extents the same
up <- max(na.omit(c(x.coord, y.coord))) + 10
down <- min(na.omit(c(y.coord, y.coord))) - 10

# Add layout options, shapes etc
p <- layout(p,
            showlegend = F,
            xaxis = list(range = c(down, up), domain = c(0, 0.5),
                         title = "", showgrid = F, zeroline = F, showticklabels = F),
            yaxis = list(range = c(down, up), 
                         title = "", showgrid = F, zeroline = F, showticklabels = F),
            shapes = list(
              list(type = "circle",
                   x0 = (-5 - adjust),
                   y0 = (-5 - adjust),
                   x1 = (5 + adjust),
                   y1 = (5 + adjust),
                   fillcolor = "transparent",
                   line = list(color = "white", width = 2)),
              
              list(type = "circle",
                   x0 = (-15 - adjust),
                   y0 = (-15 - adjust),
                   x1 = (15 + adjust),
                   y1 = (15 + adjust),
                   fillcolor = "transparent",
                   line = list(color = "white", width = 2)),
              
              list(type = "circle",
                   x0 = (-25 - adjust),
                   y0 = (-25 - adjust),
                   x1 = (25 + adjust),
                   y1 = (25 + adjust),
                   fillcolor = "transparent",
                   line = list(color = "white", width = 2)),
              
              list(type = "circle",
                   x0 = (-35 - adjust),
                   y0 = (-35 - adjust),
                   x1 = (35 + adjust),
                   y1 = (35 + adjust),
                   fillcolor = "transparent",
                   line = list(color = "white", width = 2))))


# Add annotations for country names
p <- plotly_build(p)

theta <- pi / 2
textangle <- 90

for(ctr in 1:nrow(df)){
  
  a <- df$Emission[ctr] + adjust
  a <- a + a/12
  
  x <- a * cos(theta)
  y <- a * sin(theta)
  
  if(ctr < 51) {xanchor <- "right"; yanchor <- "bottom"}
  if(ctr > 51 & ctr < 84) {xanchor <- "right"; yanchor <- "top"}
  if(ctr > 84) {xanchor <- "left"; yanchor <- "top"}
  
  p$layout$annotations[[ctr]] <- list(x = x, y = y, showarrow = F,
                                      text = paste0(df$Country[ctr]),
                                      textangle = textangle,
                                      xanchor = xanchor,
                                      yanchor = yanchor,
                                      font = list(family = "serif", size = 9),
                                      borderpad = 0,
                                      borderwidth = 0)
  theta <- theta + dtheta
  textangle <- textangle - (180 / pi * dtheta)
  
  if(textangle < -90) textangle <- 90
}

# Titles and some other details
p$layout$annotations[[148]] <- list(xref = "paper", yref = "paper",
                                    x = 0, y = 1, showarrow = F,
                                    xanxhor = "left", yanchor = "top",
                                    align = "left",
                                    text = "<em>Carbon dioxide emissions</em><br><sup>(metric tons per capita)</sup>",
                                    font = list(size = 25, color = "black"))

p$layout$annotations[[149]] <- list(xref = "paper", yref = "paper",
                                    x = 0, y = 0.9, showarrow = F,
                                    xanxhor = "left", yanchor = "top",
                                    align = "left",
                                    text = "Emissions from burning of solid, liquid and <br>gas fuels and the manufacture of cement.",
                                    font = list(size = 18, color = "#808080"))

p$layout$annotations[[150]] <- list(xref = "paper", yref = "paper",
                                    x = 0.15, y = 0.5, showarrow = F,
                                    xanxhor = "left", yanchor = "top",
                                    align = "left",
                                    text = "<b>Annual CO<sub>2</sub> emissions</b><br><b>for 147 countries.</b>",
                                    font = list(size = 13, color = "black"))

p$data[[149]] <- list(x = rep(-7, 6), y = c(-6, -4, -2, 0, 2, 4), mode = "markers",
                      marker = list(color = colors, size = 10))

p$data[[150]] <- list(x = rep(1, 6), y = c(-6, -4, -2, 0, 2, 4), mode = "text",
                      text = rev(continent),
                      marker = list(color = colors, size = 10))
p
