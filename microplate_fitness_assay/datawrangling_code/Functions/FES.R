# wt avgs from od.long
WTavg <- od.long %>%
  filter(Strain == "WT") %>%  # Keep only control rows
  group_by(Media, Infection) %>%
  summarize(WTavg = mean(total.OD, na.rm = TRUE), .groups = "drop")

# subtract control average
FES <- od.long %>%
  left_join(WTavg, by = c("Media", "Infection")) %>%
  mutate(total.OD = total.OD - WTavg) %>%
  select(-WTavg)  # Remove temporary column

FES<-FES%>%  #Fitness effects of Phage
  filter(!grepl("WT", Strain))