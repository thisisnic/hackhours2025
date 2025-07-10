## Part 1: Experimenting with LLM Applications in R - UseR Talk Preview

## Part 2: {ellmer} basics, non-text inputs, and structured outputs

### {ellmer} basics
library(ellmer)
chat <- chat_github()

# Simple output
chat$chat("What is the capital of England?")

# Questions about R code
chat$chat("How do I calculate the mean, median, and mode of a dataset in R? Use the airquality dataset as an example")

# Get specific about output length
chat$chat("How do I calculate the mean, median, and mode of a dataset in R? Use the airquality dataset as an example. Answer in 100 words or fewer.")

### Non-text inputs
basic_prompt <- "What is the text in the slide in this image?"

chat$chat(
  basic_prompt,
  content_image_file("simple_slide.jpg")
)

# Try to extract code from an unclear image with a URL
chat$chat(
  basic_prompt,
  content_image_file("slide_with_url.jpg")
)

# Refine the prompt
refined_prompt <- paste(
  "What is the text in the slide in this image?", 
  "Do not guess or make up any part.",
  "If something is unreadable (especially small text or URLS), leave it as '[unreadable]'. Do not try to fill in gaps."
)

chat$chat(
  refined_prompt,
  content_image_file("slide_with_url.jpg")
)

### Structured outputs

# The chat contains all of our previous answers and so we want to reset it here
chat <- chat_github()

chat$chat_structured(
  content_image_file("slide_with_url.jpg"),
  type = type_object(
    text = type_string(refined_prompt),
    summary = type_string("brief summary of the text on the slide"),
    url = type_string("any urls shown on the slide")
  )
)