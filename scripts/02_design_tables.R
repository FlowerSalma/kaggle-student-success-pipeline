# scripts/02_design_tables.R
library(dplyr)
library(readr)

df <- read_csv("data/processed/students_clean.csv", show_col_types = FALSE)

dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)

# ---- Design: students dimension table (one row per student) ----
students_dim <- df %>%
  select(student_key, dataset, sex, age, school, address, famsize, pstatus) %>%
  distinct()

# ---- Design: performance fact table ----
# g1,g2,g3 are common in this dataset (period grades)
performance_fact <- df %>%
  select(student_key, dataset, g1, g2, g3, absences, studytime, failures) %>%
  mutate(
    avg_period_grade = rowMeans(across(any_of(c("g1","g2","g3"))), na.rm = TRUE)
  )

# ---- Feature engineering: simple risk flag ----
master <- students_dim %>%
  left_join(performance_fact, by = c("student_key","dataset")) %>%
  mutate(
    pass = ifelse(!is.na(g3) & g3 >= 10, 1, NA),  # typical UCI pass threshold
    at_risk = ifelse(!is.na(avg_period_grade) & avg_period_grade < 10, 1, 0)
  )

write_csv(students_dim, "output/tables/students_dim.csv")
write_csv(performance_fact, "output/tables/performance_fact.csv")
write_csv(master, "output/tables/student_master.csv")

message("✅ Wrote tables to output/tables/: students_dim.csv, performance_fact.csv, student_master.csv")