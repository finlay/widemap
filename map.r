args = commandArgs(trailingOnly=TRUE)
filename <- args[1] 

library(rgdal)
library(rgeos)
library(ggplot2)

# Centre point and rotation angle
lat <- 0
long <- 150
angle <- 50

# read shapefile
wmap.raw <- readOGR(dsn="/shapes/", layer="ne_110m_land")

# Transform map around angle and lat long
proj <- paste('+proj=omerc +gamma=0',
              sprintf('+lat_0=%s +lonc=%s +alpha=%s', lat, long, angle),
              '+k_0=1 +x_0=0 +y_0=0 +ellps=WGS84 +units=km')
wmap <- spTransform(wmap.raw, CRS(proj))  # reproject graticule
bbox(wmap)

# create a blank ggplot theme
theme_opts <- list(theme(panel.grid.minor = element_blank(),
                        panel.grid.major = element_blank(),
                        panel.background = element_blank(),
                        plot.background = element_rect(fill="#e6e8ed"),
                        panel.border = element_blank(),
                        axis.line = element_blank(),
                        axis.text.x = element_blank(),
                        axis.text.y = element_blank(),
                        axis.ticks = element_blank(),
                        axis.title.x = element_blank(),
                        axis.title.y = element_blank(),
                        plot.title = element_text(size=22)))

# plot map
ggplot(fortify(wmap), aes(long,lat, group=group)) + 
  geom_polygon() + 
  xlim(-6000,6000) +
  ylim(-4500,3500) +
  coord_equal() #+ theme_opts

ggsave(filename,  width=12.5, height=8.25, dpi=72) 
