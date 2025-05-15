#subset design file, "wells" will be strain plus treatment but I can update design file to include a separate column for both
media<-design[1:8,1:12]
strain<-design[9:16,1:12]
infection<-design[17:24, 1:12]


# Create custom labels
rows <- LETTERS[1:8]  # A to H
cols <- 1:12  # 1 to 12
custom_labels <- unlist(lapply(rows, function(row) paste0(row, cols)))

#convert to long
med.long <- as.data.frame(pivot_longer(media, cols = everything(),
                                       names_to = "Well", values_to = "Media"))
stn.long <- as.data.frame(pivot_longer(strain, cols = everything(),
                                       names_to = "Well", values_to = "Strain"))
inf.long <- as.data.frame(pivot_longer(infection, cols = everything(),
                                       names_to = "Well", values_to = "Infection"))
OD.long <- data %>%
  pivot_longer(cols = -Time, names_to="Well", values_to="OD600")

#combine
OD.long$Media<-rep(med.long$Media, length.out=nrow(OD.long))
OD.long$Strain<-rep(stn.long$Strain, length.out=nrow(OD.long))
OD.long$Infection<-rep(inf.long$Infection, length.out=nrow(OD.long))

# Add total.OD
od.long <- OD.long %>%
  group_by(Well, Media, Strain, Infection) %>%
  summarize(total.OD = sum(OD600, na.rm = TRUE), .groups = "drop")

#filter out "Blanks" if needed
od.long<-od.long[!apply(od.long, 1, function(row) any(row=="Blank")), ]