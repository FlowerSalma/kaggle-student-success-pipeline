library(readr)
library(dplyr)

dir.create("output/models", recursive = TRUE, showWarnings = FALSE)

students <- read_csv("output/tables/student_master.csv", show_col_types = FALSE)

# create target variable
students <- students %>%
  mutate(
    high_performance = ifelse(
      avg_period_grade >= median(avg_period_grade, na.rm = TRUE),
      1,
      0
    )
  )

# logistic regression model
model <- glm(
  high_performance ~ studytime + absences + failures + age,
  data = students,
  family = "binomial"
)

print(summary(model))
# ---- Model evaluation ----

# ---- Model evaluation ----

pred <- ifelse(predict(model, type = "response") > 0.5, 1, 0)

conf_matrix <- table(
  Predicted = pred,
  Actual = students$high_performance
)

print(conf_matrix)

accuracy <- mean(pred == students$high_performance)

cat("Model accuracy:", accuracy, "\n")

