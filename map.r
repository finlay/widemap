args = commandArgs(trailingOnly=TRUE)
filename <- args[1] 

library(rgdal)
library(ggplot2)

# read shapefile
wmap <- readOGR(dsn="/shapes/", layer="ne_110m_land")
# convert to dataframe
wmap_df <- fortify(wmap)

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
ggplot(wmap_df, aes(long,lat, group=group)) + 
  geom_polygon() + 
  labs(title="World map (longlat)") + 
  coord_equal() + 
  theme_opts

ggsave(filename,  width=12.5, height=8.25, dpi=72) 
