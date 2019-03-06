##%######################################################%##
#                                                          #
####                 Rob data analysis                  ####
#                                                          #
##%######################################################%##

ProjTemplate::reload()
datadir <- '~/Dropbox/Baabi_GarfieldDeviceDataDownload/RobKolb Data/'
files <- dir(datadir, pattern='txt')

length(files)
summs <- vector('list', length(files))
for(i in 1:length(files)){
  print(files[i])
  dat <- readData(file.path(datadir, files[i]))
  d <- dat$Sound %>% filter(Time <= max(Time) - 600)
  summs[[i]] <- quantile(d$Sound,c(0,0.25, 0.5, 0.75, 0.9, 0.95, 0.99, 0.999,1))
}
names(summs) <- files
qdat <- summs %>% lapply(function(x) as.data.frame(t(x))) %>% bind_rows(.id = 'filename')
qdat <- qdat %>%
  mutate(filename = str_replace(filename, '.txt','')) %>%
  separate(filename, c('Subject','Duration','DownDate','Device','FileNo'), remove=F)

qdat %>% rename(Min = `0%`, Max = `100%`) %>%
  select(-filename) %>%
  knitr::kable() %>% clipr::write_clip()

i <- 2

dat <- readData(file.path(datadir,files[i]))
d <- dat$Sound %>% filter(Time <= max(Time) - 300)
summary(dat$Sound$Sound)
quantile(dat$Sound$Sound, c(.95, .99, .999))
dat_downsampled <- dat$Sound[seq(1, nrow(dat$Sound), by = 16),]

