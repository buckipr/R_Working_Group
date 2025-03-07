# Text Analysis



There are 2 sessions for text analysis: data preparation & topic models.



# Data Preparation

The first session makes use of the following packages

`
install.packages(c("stringr", "tidytext", "tm", "pdftools", "SnowballC"))
`

and uses of some data from the Supreme Court website:

[https://www.supremecourt.gov/opinions/slipopinion/24](https://www.supremecourt.gov/opinions/slipopinion/24)

# Topic Modeling

The second session uses the following packages (some repeats):

`
install.packages(c("topicmodels", "tm", "SnowballC", "slam"))
`

and follows the example from the [vignette](https://cran.r-project.org/web/packages/topicmodels/vignettes/topicmodels.pdf) from
the [topicmodels R package](https://cran.r-project.org/package=topicmodels)

# Misc

Sometimes, with HTML slides, the output from code chunks (when it is just
a bunch of text/long string) runs off the slide.  I found some code 
(in the Rmd) that fixes this with CSS and a text-wrap attribute(?):

(this is included in the Rmd file, but should probably go in css)

```{css, echo=FALSE}
.wrap code[class="remark-code"] {
  text-wrap: wrap;
}
```

and then, use this class to wrap around the code chunk that produces
the super long string

```
.wrap[
\`\`\`{r, split=TRUE}
JSS_papers[1, "description"]  ## abstract for 1st article
\`\`\`
]
```
