# scripts/01_clean_validate.R
library(dplyr)
library(readr)
library(stringr)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

# The dataset typically includes student-mat.csv and student-por.csv (UCI files).
# We'll read whichever exist.
raw_files <- list.files("data/raw", pattern = "\\.csv$", full.names = TRUE)
if (length(raw_files) == 0) stop("No CSV files found in data/raw. Did you unzip/download correctly?")

# Read all csvs into a named list
dfs <- lapply(raw_files, \(f) read_csv(f, show_col_types = FALSE))
names(dfs) <- basename(raw_files)

# Choose math/portuguese if present; otherwise take first
pick <- function(pattern) {
  hit <- grep(pattern, names(dfs), ignore.case = TRUE, value = TRUE)
  if (length(hit) > 0) dfs[[hit[1]]] else NULL
}

mat <- pick("mat")
por <- pick("por")

if (is.null(mat) && is.null(por)) {
  df <- dfs[[1]]
  df$dataset <- "unknown"
} else {
  # Harmonize & stack if both exist
  add_tag <- function(x, tag) { x$dataset <- tag; x }
  parts <- list()
  if (!is.null(mat)) parts <- append(parts, list(add_tag(mat, "math")))
  if (!is.null(por)) parts <- append(parts, list(add_tag(por, "portuguese")))
  df <- bind_rows(parts)
}

# Basic cleaning: standardize names
df_clean <- df %>%
  janitor::clean_names() %>%                 # makes snake_case
  mutate(across(where(is.character), str_trim)) %>%
  distinct()                                  # drop exact duplicate rows

# Validate a few expected columns (won't fail if dataset differs; just warns)
expected <- c("sex", "age", "studytime", "absences", "g1", "g2", "g3")
missing_expected <- setdiff(expected, names(df_clean))
if (length(missing_expected) > 0) {
  warning("Missing expected columns: ", paste(missing_expected, collapse = ", "))
}

# Range checks if columns exist
range_check <- function(x, lo, hi) ifelse(is.na(x) | (x >= lo & x <= hi), x, NA)
if ("age" %in% names(df_clean)) df_clean <- df_clean %>% mutate(age = range_check(as.numeric(age), 10, 30))
if ("absences" %in% names(df_clean)) df_clean <- df_clean %>% mutate(absences = range_check(as.numeric(absences), 0, 200))

# Create a stable student key (since no student_id in this dataset)
df_clean <- df_clean %>%
  mutate(student_key = sprintf("STU_%06d", row_number()))

# Save cleaned
write_csv(df_clean, "data/processed/students_clean.csv")
message("✅ Saved: data/processed/students_clean.csv")

# Quality report
quality <- tibble(
  n_raw = nrow(df),
  n_clean = nrow(df_clean),
  duplicates_removed = nrow(df) - nrow(df_clean),
  n_missing_total = sum(is.na(df_clean))
)
write_csv(quality, "data/processed/quality_report.csv")
print(quality)
