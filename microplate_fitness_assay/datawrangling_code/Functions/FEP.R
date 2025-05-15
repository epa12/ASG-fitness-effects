# ctrl avgs from od.long
ctrl_avg <- od.long %>%
  filter(Infection == "Ctrl") %>%  # Keep only control rows
  group_by(Media, Strain) %>%
  summarize(ctrl_avg = mean(total.OD, na.rm = TRUE), .groups = "drop")

# subtract control average
FEP <- od.long %>%
  left_join(ctrl_avg, by = c("Media", "Strain")) %>%
  mutate(total.OD = total.OD - ctrl_avg) %>%
  select(-ctrl_avg)  # Remove temporary column

FEP<-FEP%>%  #Fitness effects of Phage
  filter(!grepl("Ctrl", Infection))
