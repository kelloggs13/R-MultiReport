
rm(list=ls())

library(rmarkdown)
library(here)
library(haven)
library(tidyverse)
library(ggplot2)
library(reshape2)
library(readxl)

i_am("generate_reports.R")


# Get data 
data(mpg)
df.data = mpg


# read excel with meta information
df.meta <- read_excel(here("input", "meta.xlsx"))


# Loop through each score and render the R Markdown file
for (i in 1:nrow(df.meta)) {
  
  drv.curr = df.meta$drv[i]

  descr <- df.meta$file_descr[i]
  
  plot.bp <-df.data %>% filter(drv == drv.curr) %>%  
    ggplot(aes(cty, col = drv)) + 
    geom_boxplot()

  output.image <- paste0("output/", gsub(" ", "_", tolower(drv.curr)), "_plot.png")
  
  ggsave(output.image, plot.bp)
  
  output_file <- paste0("reports/report_", gsub(" ", "_", tolower(drv.curr)), ".html")

  render("report_template.Rmd",
         output_file = output_file,
         params = list(p.descr = descr,
                       p.plot = output.image
                       )
         )
}
