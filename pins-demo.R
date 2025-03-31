# Set up board and dependencies
library(pins)
library(paws.storage)
bucket_name <- '3mw-pins-test'
board <- board_s3(bucket_name, region = 'eu-central-1')

# Set up data extractor
extract_data <- function() {
  data.frame(timestamp = Sys.time(), value = runif(1))
}

# Check if pin available
desired_pin <- 'gh-action-demo'
available_pins <- board |> pin_list()
pin_is_available <- (desired_pin %in% available_pins)

# Create pin with new data if pin not available
if (!pin_is_available) {
  board |>
    pin_write(
      extract_data(),
      name = desired_pin
    )
}

# Append data if pin is available
if (pin_is_available) {
  dat_old <- board |> pin_read(desired_pin)
  dat_new <- extract_data()
  dat_combined <- rbind(dat_new, dat_old)
  board |>
    pin_write(
      dat_combined,
      name = desired_pin
    )
}
