# Student Academic Performance Pipeline (R)

## Project Overview

This project demonstrates a **reproducible data science pipeline in R** for analyzing student academic performance. The goal is to explore how behavioral and academic variables influence whether a student becomes a **high-performing student**.

The project is structured to mirror a typical **real-world analytics workflow**, including:

* Data ingestion
* Data cleaning and validation
* Data design and feature preparation
* Predictive modeling
* Model evaluation

The analysis uses the **Student Performance dataset from Kaggle**, which contains demographic, behavioral, and academic variables describing student outcomes.

---

# Dataset

The dataset includes information about students' academic behavior and grades.

Key variables used in the analysis include:

| Variable         | Description                        |
| ---------------- | ---------------------------------- |
| `studytime`      | Weekly study time                  |
| `absences`       | Number of school absences          |
| `failures`       | Number of past class failures      |
| `age`            | Student age                        |
| `G1`, `G2`, `G3` | Grades from three academic periods |

From these grades, an **average period grade** is computed to summarize overall academic performance.

---

# Project Structure

```
kaggle-student-success-pipeline

data
 ├── raw
 └── processed

scripts
 ├── 01_clean_validate.R
 ├── 02_design_tables.R
 └── 03_model.R

output
 ├── tables
 └── models

README.md
```

Each script represents a **step in the data pipeline**.

---

# Pipeline Steps

## 1. Data Cleaning and Validation

Script: `scripts/01_clean_validate.R`

This step loads the raw dataset and performs basic quality checks:

* Removes duplicates
* Checks missing values
* Validates expected columns
* Generates a data quality report

Output files:

```
data/processed/students_clean.csv
data/processed/quality_report.csv
```

---

## 2. Data Design

Script: `scripts/02_design_tables.R`

The cleaned dataset is transformed into structured analysis tables.

Three tables are created:

### Students Dimension Table

```
students_dim.csv
```

Contains student-level attributes such as demographic variables and behavior.

### Performance Fact Table

```
performance_fact.csv
```

Contains observations of student grades across academic periods.

### Master Table

```
student_master.csv
```

A combined table used for modeling and analysis.

Output location:

```
output/tables/
```

---

## 3. Predictive Modeling

Script: `scripts/03_model.R`

A **logistic regression model** is used to predict whether a student is a **high-performing student**.

The target variable is defined as:

```
high_performance = 1 if avg_period_grade >= median(avg_period_grade)
```

This splits students into two groups:

* High-performing students
* Lower-performing students

The model uses the following predictors:

* studytime
* absences
* failures
* age

Model specification:

```
glm(high_performance ~ studytime + absences + failures + age,
    family = "binomial")
```

---

# Model Results

The model estimates how each variable influences the probability that a student will be a high performer.

Example coefficient interpretation:

| Variable  | Interpretation                                                             |
| --------- | -------------------------------------------------------------------------- |
| studytime | Students who study more are more likely to perform well                    |
| failures  | Previous failures significantly reduce the probability of high performance |
| absences  | More absences tend to reduce academic success                              |
| age       | Age does not show a strong relationship with performance                   |

Positive coefficients increase the probability of success, while negative coefficients reduce it.

---

# Model Evaluation

The model is evaluated using a **confusion matrix** and prediction accuracy.

Example confusion matrix:

```
           Actual
Predicted     0    1
       0     192   49
       1     320  483
```

This table compares predicted outcomes with actual outcomes.

Definitions:

| Term           | Meaning                                              |
| -------------- | ---------------------------------------------------- |
| True Positive  | Model correctly predicts a high-performing student   |
| True Negative  | Model correctly predicts a low-performing student    |
| False Positive | Model incorrectly predicts a high-performing student |
| False Negative | Model misses a high-performing student               |

Model accuracy:

```
64.6%
```

This means the model correctly classifies student performance about **65% of the time**.

---

# How to Run the Pipeline

Run the scripts sequentially:

```
source("scripts/01_clean_validate.R")
source("scripts/02_design_tables.R")
source("scripts/03_model.R")
```

Each step produces outputs used by the next step.

---

# Tools and Technologies

* R
* dplyr
* readr
* tibble
* logistic regression (`glm`)

---

# Key Takeaways

This project demonstrates a complete **data science workflow**, including:

* reproducible data pipelines
* structured data cleaning
* dimensional data design
* predictive modeling
* model evaluation

The structure is similar to workflows used in **analytics and data science teams**.

---

# Possible Improvements

Future extensions could include:

* additional predictive features
* cross-validation
* alternative models (Random Forest, Gradient Boosting)
* feature importance visualization
* performance comparison between models

---

# Author

Salma Hasannejad\
Mathematics & Data Science
