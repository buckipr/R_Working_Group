# topic_models.R
# R Working Group -- 2025/03/07
# Following example in vignette of topicmodels R package
# (https://cran.r-project.org/web/packages/topicmodels/vignettes/topicmodels.pdf)

# Load packages
library(topicmodels)
library(tm)
library(SnowballC)
library(slam)

# Load examples data set & convert to document-term-matrix
data("JSS_papers")
colnames(JSS_papers)
JSS_papers[1:5, "description"]

corpus <- Corpus(VectorSource(unlist(JSS_papers[, "description"])))
inspect(corpus[1])

jss_dtm <- DocumentTermMatrix(corpus,
                              control=list(tolower = TRUE,
                                           stemming = TRUE,
                                           stopwords = TRUE,
                                           minWordLength = 3,
                                           removeNumbers = TRUE,
                                           removePunctuation = TRUE))
## these are stored in a special format
jss_dtm
nDocs(jss_dtm)
nTerms(jss_dtm)
inspect(jss_dtm[1:5, 1:5])

# mean tf-idf (term frequency-inverse document frequency)
term_tfidf <- tapply(jss_dtm$v/row_sums(jss_dtm)[jss_dtm$i],
                     jss_dtm$j, mean) *
  log2(nDocs(jss_dtm)/col_sums(jss_dtm > 0))
length(term_tfidf)
summary(term_tfidf)

## select "important" terms
jss_dtm <- jss_dtm[, term_tfidf >= 0.1]
dim(jss_dtm)

# fit models
m1_k30 <- LDA(jss_dtm, k = 30)
m1_k30
slotNames(m1_k30)  # S4 Object
m1_k30@alpha
slot(m1_k30, "alpha")
dim(slot(m1_k30, "beta"))

m1_k30_results <- posterior(m1_k30)
str(m1_k30_results)
names(m1_k30_results)
dim(posterior(m1_k30)$terms)
posterior(m1_k30)$terms[1,1:10]  # Pr(Term | Topic) -- term distribution over topics
posterior(m1_k30)$topics[1:3,]   # Pr(Topic | Doc) -- topic distribution over documents

topics(m1_k30, 1) # most likely topic for each document
terms(m1_k30, 5) # 5 most frequent terms for each topic

## Gibbs
m2_k30 <- LDA(jss_dtm, k = 30, method = "Gibbs")
