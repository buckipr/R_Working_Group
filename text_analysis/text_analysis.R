
# Introduction

# Setup


install.packages(c("stringr", "tidytext", "tm", "pdftools", "SnowballC"))

library(stringr)
library(tidytext)
library(tm)
library(pdftools)
library(SnowballC)


# Tidytext
poem <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")
poem


text_df <- data.frame(line = 1:4, text = poem)
text_df

text_df |> 
  unnest_tokens(  # create a new df with one token per row
  word,           # column name in new df
  text)          # column name in original df (with text)

text_df <- text_df |> 
  unnest_tokens(word, text) |> 
  count(line, word)
text_df

text_dtm <- text_df |> 
  cast_dtm(line, word, n)
text_dtm
dim(text_dtm)


# Preprocessing

stop_words

my_stop_words <- bind_rows(tibble(word = c("balloon"),
                                  lexicon = c("custom")), 
                               stop_words)
my_stop_words[1:3, ]

text_df |> 
  anti_join(stop_words)

text_df %>%
  mutate(stem = wordStem(word))


# Loading Data: single PDF

dir(".")    # list contents of working directory

dir("scotus")    # list contents of scotus folder

## why not use dir() again??
fnames <- paste("scotus", list.files("scotus"), sep="/")
fnames


scotus1 <- pdf_text(fnames[1])  # read in a PDF file
str(scotus1)                    # look at the structure of scotus1
r scotus1[1]

# Loading Data: multiple PDFs

scotus_all <- Corpus(URISource(fnames),
                     readerControl = list(reader = readPDF))
scotus_all
scotus_all[[1]]  # look at the first document
scotus_all[[1]]$meta
length(scotus_all[[1]]$content)  ## number of pages
scotus_all[[1]]$content[1]       ## text on first page


# Cleaning Data

# deal with words that are split across lines with hyphens
"re-\n port"
str_replace("re-\n port", "-\n ", "") ## only replaces first match!


# deal with words that are split across lines with hyphens
scotus_p2 <- str_replace_all(scotus1[[2]], "-\n ", "")
scotus_p2


example <- c("re-\n port", "es-\nPage Proof Pending Publincation \n tate")
str_replace_all(example, "-\n ", "")

x <- "blah blah blah Connelly v. Department of Treasury, IRS, 70 F. 4th 412 (CA8 2023)."
str_extract(x, "[A-z]+ v. [^,]+")

str_replace_all(x, "([A-z]+) v. [^,]+", "\\1")

y <- str_replace_all(x, "([A-z]+) (v). ([^,]+)", "\\1_\\2_\\3")
y |> as.data.frame() |> 
  unnest_tokens(word, y)

# Exercises
  
# Who wrote the opinion? Can you add this to the data set?
  
# Sometimes there are names, e.g., "Court of Appeals".  How could you
# change these names so that they are considered as a single word?
  
# How could you deal with negation?  For example, should "not happy"
# be treated as two separate words?
  
# How would you handle a word break (with an hyphen) that was split
# across two pages?
  