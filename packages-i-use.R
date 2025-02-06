if (!require("remotes")) install.packages("remotes")

remotes::install_github('hadley/emo')

install.packages("pak")

# remotes::install_cran(
pak::pak(
  c(
    "arrow",
    "BH",
    "fstcore",
    "RApiSerialize",
    "stringfish",

    # Shiny packages:
    "bslib",
    "shiny",

    # webscraping
    "applicable",

    # modeling / stats
    "tidymodels",
    "broom.mixed",
    "DALEX",
    "DALEXtra",
    "doParallel",
    "gee",
    "glmnet",
    "lme4",
    "ltm",
    "LongituRF",
    "pins",
    "plumber",
    "pwr",
    "quantmod",
    "ranger",
    "vetiver",
    "vip",

    # plotting / visuals / tables
    "DiagrammeR",
    "extrafont",
    "flextable",
    "ggiraph",
    "ggstatsplot",
    "ggthemes",
    "ggtext",
    "gtsummary",
    "kableExtra",
    "mapproj",
    "mapview",
    "patchwork",
    "table1",
    "textrecipes",
    "vcd",
    "vcdExtra",
    "viridis",

    # for package development
    "available",
    "devtools",

    # misc
    "addinslist",
    "crsuggest",
    "janitor",
    "lorem",
    "palmerpenguins",
    "quarto",
    "qpcR",
    "redcapAPI",
    "rio",
    "rUM",
    "sjlabelled",
    "skimr",
    "tidyREDCap",

    'froggeR',
    'nascaR.data'

  )
)


rio::install_formats()
