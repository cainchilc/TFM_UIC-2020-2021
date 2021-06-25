library(readr)
library(ggplot2)
library(jcolors)
library(RColorBrewer)
library(stringr)

#########################################################
# Grafica 1 :: Resolucion por tejido  #
#########################################################

# Podemos ver la resolucion en cada tejido
# Podemos deducir la forma de la imagen (en la diagonal seria cuadrada), o si es 
# mas apaisada o alargada

types_file <- read.csv("all_types.csv",sep = "\t")
# View(types_file)

# length(types_file$resolucion_corregida_NAC)
# unique(types_file$resolucion_corregida_NAC)

df_res <- data.frame(str_split_fixed(types_file$resolucion_corregida_NAC, "x", 2))
colnames(df_res) <- c("resX", "resY")
df_res$type <- types_file$type
df_res$resX <- as.numeric(df_res$resX)
df_res$resY <- as.numeric(df_res$resY)
tail(df_res)

my_palette <- c("#33ccff", "#ff0066" ,"#ffcc00")
ggplot(data=df_res,aes(x=resX, y=resY,col=type)) +
  geom_point(size=2, shape=16) + 
  scale_color_manual(values=my_palette, name="Tipo de tejido") + 
  labs(title="Resolucion por tipo de tejido", subtitle="Imagenes PNG extraidas", x="pixeles por ancho", y="pixeles por alto") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        plot.margin = unit(c(.5, .5, .5, .8), "cm"),
        panel.background = element_rect(fill="grey96"),
        axis.title.x = element_text(size = 12, angle = 0, vjust = -1, colour="grey26"),
        axis.title.y = element_text(size = 12, angle = 90, vjust = 4, colour="grey26"),
        axis.text.x = element_text(size=10, angle=0, vjust=1),
        axis.text.y = element_text(size=10, angle=0, vjust=1))




#########################################################
# Grafica 2 :: Resolucion por peso  #
#########################################################

# La tendencia general es que a mas resolucion mas peso, mas Megas
# Pero hay una franja mas central que el peso tanto puede ser mayor como menor

types_file <- read.csv("all_types.csv",sep = "\t")
# View(types_file)
# length(types_file$resolucion_corregida_NAC)
# unique(types_file$resolucion_corregida_NAC)

df_res <- data.frame(str_split_fixed(types_file$resolucion_corregida_NAC, "x", 2))
colnames(df_res) <- c("resX", "resY")
df_res$type <- types_file$type
df_res$weight <- gsub("M", "", types_file$weight_PNG_NAC)
df_res$resX <- as.numeric(df_res$resX)
df_res$resY <- as.numeric(df_res$resY)
tail(df_res)

ggplot(data=df_res,aes(x=resX, y=resY, col=as.numeric(weight))) +
  geom_point(size=2, shape=16) + 
  scale_color_gradient(low="yellow",high = "blue", name ="Megas") +
  # scale_color_gradient(low="orangered",high = "green", name ="Megas") +
  # scale_color_gradient(low="magenta",high = "turquoise1", name ="Megas") +
  labs(title="Peso en Megas segun resolucion", subtitle="Imagenes PNG extraidas", x="pixeles por ancho", y="pixeles por alto") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        plot.margin = unit(c(.5, .5, .5, .8), "cm"),
        panel.background = element_rect(fill="grey96"),
        axis.title.x = element_text(size = 12, angle = 0, vjust = -1, colour="grey26"),
        axis.title.y = element_text(size = 12, angle = 90, vjust = 4, colour="grey26"),
        axis.text.x = element_text(size=10, angle=0, vjust=1),
        axis.text.y = element_text(size=10, angle=0, vjust=1))




########################################################
# Grafica 3 :: Distribución de peso, Mgas  #
#########################################################

# Vemos que las imagenes de tumor son las que concentran el peso mas bajo
# N=forma descendiente
# T / TN = forma U

types_file <- read.csv("all_types.csv",sep = "\t")
# View(types_file)

types_file$weight_PNG_NAC <- gsub("M", "", types_file$weight_PNG_NAC)

# shortcut de la pipe de R %>% (ctr+shift+m)

# my_colors <- c("#33ccff", "#ffcc00","#ff0066") # blau = N
my_colors <- c("#40ff00", "#ff3366","#ffcc00")   # verd = N
ggplot(data=types_file, aes(x=weight_PNG_NAC, fill=type)) +
  geom_bar() +
  labs(title="Distribución por peso en Megas", subtitle="Imagenes PNG extraidas", x="Peso en Megas", y="Numero de imagenes") +
  # scale_fill_brewer(name="Tipo de tejido", palette = "Pastel2" ) +
  scale_fill_manual(values = my_colors, name="Tipo de tejido") +
  geom_text(stat = "count", aes(label=..count..),
            position = position_stack(vjust = 0.5), colour="black", size=3) +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        plot.margin = unit(c(.5, .5, .5, .8), "cm"),
        panel.background = element_rect(fill="grey96"),
        axis.title.x = element_text(size = 14, angle = 0, vjust=-2, colour="grey26"),
        axis.title.y = element_text(size = 14, angle = 90, vjust=2, colour="grey26"),
        axis.text.x = element_text(size=10,angle=0, vjust=1),
        axis.text.y = element_text(size=10,angle=0, vjust=1))




#########################################################
# Grafica 4 :: Distribución de peso original  #
#########################################################

# histogram all samples TIF
types_file <- read.csv("all_original_size.csv",sep = "\t")

hist_tif <- ggplot(types_file, aes(M)) + 
  geom_histogram(col="lightblue3", fill="lightblue3", alpha = 0.5) +
  coord_cartesian(ylim = c(0, 160)) +
  labs(title="Imagenes originales TIF", x="Peso en Megas", y="Numero de imagenes", 
       caption="\nTodas las imagenes del dataset: T, TN, N") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        plot.margin = unit(c(.5, .5, .5, .8), "cm"),
        panel.background = element_rect(fill="grey96"),
        axis.title.x = element_text(size = 14, angle = 0, vjust=-1, colour="grey26"),
        axis.title.y = element_text(size = 14, angle = 90, vjust=2, colour="grey26"),
        axis.text.x = element_text(size=10,angle=0, vjust=1),
        axis.text.y = element_text(size=10,angle=0, vjust=1))

# histogram all samples PNG
types_file <- read.csv("all_types.csv",sep = "\t")
types_file$weight_PNG_NAC <- gsub("M", "", types_file$weight_PNG_NAC)
df <- subset(types_file, select=c("type", "weight_PNG_NAC"))
df$weight_PNG_NAC <- as.numeric(df$weight_PNG_NAC)

hist_png <- ggplot(df, aes(weight_PNG_NAC)) + 
  geom_histogram(col="lightblue3", fill="lightblue3", alpha = 0.5) +
  coord_cartesian(ylim = c(0, 160)) +
  labs(title="Imagenes extraidas PNG", x="Peso en Megas", y="Numero de imagenes", 
       caption="\nTodas las imagenes del dataset: T, TN, N") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        plot.margin = unit(c(.5, .5, .5, .8), "cm"),
        panel.background = element_rect(fill="grey96"),
        axis.title.x = element_text(size = 14, angle = 0, vjust=-1, colour="grey26"),
        axis.title.y = element_text(size = 14, angle = 90, vjust=2, colour="grey26"),
        axis.text.x = element_text(size=10,angle=0, vjust=1),
        axis.text.y = element_text(size=10,angle=0, vjust=1))

# library(grid)
grid.newpage()
pushViewport(viewport(layout = grid.layout(2,2, height = unit(c(.5, 5, 5, 5), "null"))))
grid.text("Histograma - Peso de las Imagenes",
          hjust = c(-0.4),
          gp = gpar(fontsize = 16, fontface = "bold"),
          vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(hist_tif, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
print(hist_png, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))



#########################################################
# Grafica 5 :: Densidad TIF / PNG   #
#########################################################

# Densidad por tejido TIF
types_file <- read.csv("all_original_size.csv",sep = "\t")
my_palette <- c("#33ccff", "#ff0066" ,"#ffcc00")
density_tif <- ggplot(types_file, aes(M)) +
  stat_density(aes(x=M, colour=type), geom="line", position="identity") +
  scale_color_manual(values=my_palette) + 
  labs(title="Imagenes originales TIF", x="Peso en Megas", y="Densidad", colour="Tipo de tejido") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        plot.margin = unit(c(.5, .5, .5, .8), "cm"),
        panel.background = element_rect(fill="grey96"),
        axis.title.x = element_text(size = 12, angle = 0, vjust=-2, colour="grey26"),
        axis.title.y = element_text(size = 12, angle = 90, vjust=2, colour="grey26"),
        axis.text.x = element_text(size=10,angle=0, vjust=1),
        axis.text.y = element_text(size=10,angle=0, vjust=1)) 


# Densidad por tejido PNG
types_file <- read.csv("all_types.csv",sep = "\t")
types_file$weight_PNG_NAC <- gsub("M", "", types_file$weight_PNG_NAC)
df <- subset(types_file, select=c("type", "weight_PNG_NAC"))
df$weight_PNG_NAC <- as.numeric(df$weight_PNG_NAC)

# my_palette <- c("#40ff00", "#ff3366","#ffcc00")   # verd = N
my_palette <- c("#33ccff", "#ffcc00","#ff0066") # blau = N
density_png <- ggplot(df, aes(weight_PNG_NAC)) +
  stat_density(aes(x=weight_PNG_NAC, colour=type), geom="line", position="identity") +
  scale_color_manual(values=my_palette) + 
  labs(title="Imagenes extraidas PNG", x="Peso en Megas", y="Densidad", colour="Tipo de tejido") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        plot.margin = unit(c(.5, .5, .5, .8), "cm"),
        panel.background = element_rect(fill="grey96"),
        axis.title.x = element_text(size = 12, angle = 0, vjust=-2, colour="grey26"),
        axis.title.y = element_text(size = 12, angle = 90, vjust=2, colour="grey26"),
        axis.text.x = element_text(size=10,angle=0, vjust=1),
        axis.text.y = element_text(size=10,angle=0, vjust=1)) 


# library(grid)
grid.newpage()
pushViewport(viewport(layout = grid.layout(2,2, height = unit(c(.5, 5, 5, 5), "null"))))
grid.text("Densidad - Peso de las Imagenes segun el tejido", 
          hjust = c(-0.2),
          gp = gpar(fontsize = 16, fontface = "bold"),
          vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(density_tif, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
print(density_png, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))

