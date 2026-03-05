# scripts/00_download_kaggle_data.R
# Downloads: Student Alcohol Consumption dataset from Kaggle
# Kaggle slug: uciml/student-alcohol-consumption  (confirmed) :contentReference[oaicite:2]{index=2}

dataset_slug <- "uciml/student-alcohol-consumption"
zip_path <- file.path("data", "raw", "kaggle_dataset.zip")

dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)

# Check kaggle CLI exists
kaggle_ok <- nzchar(Sys.which("kaggle"))
if (!kaggle_ok) {
  stop("Kaggle CLI not found. Install it: pip install kaggle (and configure kaggle.json).")
}

cmd <- sprintf('kaggle datasets download -d %s -p "%s" -f "" --force', dataset_slug, "data/raw")
# Some versions ignore -f ""—safe to just download the whole dataset:
cmd <- sprintf('kaggle datasets download -d %s -p "%s" --force', dataset_slug, "data/raw")

message("Running: ", cmd)
system(cmd)

# Find the downloaded zip (Kaggle names it like student-alcohol-consumption.zip)
zips <- list.files("data/raw", pattern = "\\.zip$", full.names = TRUE)
if (length(zips) == 0) stop("No zip found in data/raw after download.")

# Unzip all zips (safe)
for (z in zips) {
  message("Unzipping: ", z)
  unzip(z, exdir = "data/raw")
}

message("✅ Downloaded + unzipped into data/raw/")
message("Files in data/raw: ", paste(list.files("data/raw"), collapse = ", "))

