# source; http://people.duke.edu/~aql3/gotta-plot-them-all/

rm(list = ls())
packs <- c("httr", "ggplot2", "dplyr")
lapply(packs, library, character.only = TRUE)

# Get Gen 1 information
rgen1 <- GET("http://pokeapi.co/api/v2/generation/1")
cgen1 <- content(rgen1, "parsed")

# Extract all species of Gen 1 into a data frame
df_poke_gen1 <- do.call(rbind.data.frame, c(cgen1$pokemon_species, stringsAsFactors = FALSE))

# We will crawl through the urls of all species, seen here in the url column
head(df_poke_gen1)

# A function to crawl through the url and extract the Pokemon and its stats
f_getpokemon <- function(url) {
  c_species <- content(GET(url), "parsed")
  
  # For gen 1, there's only one variety of Pokemon per species, so we can simply extract
  # the first element in the varieties list
  url_pokemon <- c_species$varieties[[1]]$pokemon$url
  c_pokemon <- content(GET(url_pokemon), "parsed")
  
  stats <- sapply(c_pokemon$stats, function(stats) stats[["base_stat"]])
  names(stats) <- sapply(c_pokemon$stats, function(stats) stats[["stat"]][["name"]])
  
  for (i in seq_along(c_pokemon$types)) {
    if (c_pokemon$types[[i]][["slot"]] == 1) {
      type <- c_pokemon$types[[i]][["type"]][["name"]]
    }
  }
  
  return(c(name = c_pokemon$name, url = url_pokemon,
           id = c_pokemon$id, order = c_pokemon$order,
           type = type,
           weight = c_pokemon$weight,
           sprite = c_pokemon$sprites$front_default,
           as.list(stats)))
}

# Get all pokemons using the function above
l_pokemon <- lapply(df_poke_gen1$url, f_getpokemon)
df_pokemon <- do.call(rbind.data.frame, c(l_pokemon, stringsAsFactors = FALSE))
df_pokemon <- df_pokemon %>% arrange(id)
write.csv(df_pokemon, file = "pokemon_gen1.csv", row.names = FALSE)

# Get all the pokemon sprites
dir.create("pokemon_png")
mapply(download.file,
       url = df_pokemon$sprite,
       destfile = paste0("pokemon_png/", df_pokemon$name, ".png"),
       MoreArgs = list(mode = "wb"))

# Load the packages
packs <- c("ggplot2", "dplyr", "png", "grid")
lapply(packs, library, character.only = TRUE)

# Read in the data
df_pokemon <- read.csv("pokemon_gen1.csv")

# Run PCA on the 6 stats
pca <- prcomp(df_pokemon[ , c("speed", "special.defense", "special.attack",
                              "defense", "attack", "hp")])

screeplot(pca, type = "lines", main = "Scree plot")

biplot(pca, cex = c(0.6, 0.85), arrow.len = 0.05,
       xlab = "PC1 - Overal Strength",
       ylab = "PC2 - Brawn over Brain")


# Get the PCA data
pd <- cbind.data.frame(df_pokemon, pca$x)

# A function to plot Pokemon's png file as ggplot2's annotation_custom
f_annotate <- function(x, y, name, size) {
  f_getImage <- function(name) {
    rasterGrob(readPNG(paste0("pokemon_png/", name, ".png")))
  }
  annotation_custom(f_getImage(name),
                    xmin = x - size, xmax = x + size, 
                    ymin = y - size, ymax = y + size)
}

# Wrap everything in a plot function
f_plot <- function(pd) {
  ggplot(data = pd, aes(x = PC1, y = PC2)) +
    geom_text(data = pd, aes(label = name), 
              hjust = 0.5, vjust = -1, size = 3.5, alpha = 0.5) +
    mapply(f_annotate, x = pd$PC1, y = pd$PC2, name = pd$name, size = 10)  +
    theme_bw() +
    labs(x = "Overall Strength", y = "Brawn over Brain") +
    coord_cartesian(xlim = c(-100, 120), ylim = c(-90, 90))
}

# Plot all 151 Pokemons
f_plot(pd)

f_plot(pd %>% filter(name %in% c("abra", "kadabra", "alakazam",
                                 "drowzee", "hypno")))

# Plot starter Pokemons
f_plot(pd %>% filter(id %in% 1:9))

f_plot(pd %>% filter(name %in% c("arcanine", "moltres", "zapdos", "articuno")))


























