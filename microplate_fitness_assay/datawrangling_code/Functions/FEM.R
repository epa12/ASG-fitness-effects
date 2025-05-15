# LB avgs from od.long
LBavg <- od.long %>%
  filter(Media == "LB") %>%  # Keep only control rows
  group_by(Strain, Infection) %>%
  summarize(LBavg = mean(total.OD, na.rm = TRUE), .groups = "drop")

# subtract control average
FEM <- od.long %>%
  left_join(LBavg, by = c("Strain", "Infection")) %>%
  mutate(total.OD = total.OD - LBavg) %>%
  select(-LBavg)  # Remove temporary column

FEM<-FEM%>%  #Fitness effects of Phage
  filter(!grepl("LB", Media))