#Isolate 6h post-infection
OD.long6 <- OD.long6 %>%
  group_by(Well, Media, Strain, Infection) %>%
  summarize(total.OD = sum(OD600, na.rm = TRUE), .groups = "drop")

# ctrl avgs from OD.long6
ctrl_avg <- OD.long6 %>%
  filter(Infection == "Ctrl") %>%  # Keep only control rows
  group_by(Media, Strain) %>%
  summarize(ctrl_avg = mean(total.OD, na.rm = TRUE), .groups = "drop")

# subtract control average
FEP6 <- OD.long6 %>%
  left_join(ctrl_avg, by = c("Media", "Strain")) %>%
  mutate(total.OD = total.OD - ctrl_avg) %>%
  select(-ctrl_avg)  # Remove temporary column

FEP6<-FEP6%>%  #Fitness effects of Phage
  filter(!grepl("Ctrl", Infection))
