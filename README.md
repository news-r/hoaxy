<!-- README.md is generated from README.Rmd. Please edit that file -->



<!-- badges: start -->
[![Travis build status](https://travis-ci.org/news-r/hoaxy.svg?branch=master)](https://travis-ci.org/news-r/hoaxy)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/news-r/hoaxy?branch=master&svg=true)](https://ci.appveyor.com/project/news-r/hoaxy)
<!-- badges: end -->

# hoaxy

[Hoaxy](https://rapidapi.com/truthy/api/hoaxy) visualizes the spread of claims and related fact checking online. A claim may be a fake news article, hoax, rumor, conspiracy theory, satire, or even an accurate report. Anyone can use Hoaxy to explore how claims spread across social media. You can select any matching fact-checking articles to observe how those spread as well.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("news-r/hoaxy")
```

## Calls

- `hx_articles` - Get fake articles on a specific query. 
- `hx_tweets` - Get tweets on specific articles.
- `hx_edges` - Get network of tweets on specific articles.
- `hx_timeline` - Get timeline of tweets on specific articles.
- `hx_spreaders` - Get top Twitter users.
- `hx_top_articles` - Get top articles.
- `hx_latest_articles` - Get latest fake news.

## Setup

Create a free account at [rapidapi.com](https://rapidapi.com/truthy/api/hoaxy) to create an API key.

```r
hoaxy_key("xxXXxxXx")
```

Note that you can specify the `RAPIDAPI_API_KEY` key as an environment variable in your `.Renviron` for convenience.

## Example

Get fakes articles.


```r
library(hoaxy)

(articles <- hx_articles("pizzagate"))
#> # A tibble: 100 x 8
#>    canonical_url date_published domain     id number_of_tweets score
#>    <chr>         <chr>          <chr>   <int>            <int> <dbl>
#>  1 https://www.… 2019-03-16T12… breit… 1.29e6              820  8.91
#>  2 https://www.… 2019-01-29T21… infow… 1.24e6              400  8.91
#>  3 https://www.… 2019-01-23T10… redst… 1.23e6              113  6.77
#>  4 https://www.… 2019-05-21T23… snope… 1.35e6              103  8.31
#>  5 https://www.… 2019-03-17T05… dcclo… 1.29e6              102  5.77
#>  6 https://www.… 2019-06-08T01… infow… 1.36e6               93  9.98
#>  7 https://www.… 2019-04-05T15… polit… 1.31e6               72  4.54
#>  8 https://www.… 2019-01-24T23… snope… 1.23e6               66  7.03
#>  9 https://www.… 2019-01-30T01… snope… 1.24e6               63  3.90
#> 10 https://www.… 2019-04-13T05… dcclo… 1.31e6               59  5.80
#> # … with 90 more rows, and 2 more variables: site_type <chr>, title <chr>
```

Get tweets on some of said articles.


```r
(tweets <- hx_tweets(articles$id[1:5]))
#> # A tibble: 1,538 x 8
#>    canonical_url date_published domain     id site_type title
#>    <chr>         <chr>          <chr>   <int> <chr>     <chr>
#>  1 https://www.… 2019-01-23T10… redst… 1.23e6 claim     The …
#>  2 https://www.… 2019-01-23T10… redst… 1.23e6 claim     The …
#>  3 https://www.… 2019-01-23T10… redst… 1.23e6 claim     The …
#>  4 https://www.… 2019-01-23T10… redst… 1.23e6 claim     The …
#>  5 https://www.… 2019-01-23T10… redst… 1.23e6 claim     The …
#>  6 https://www.… 2019-01-23T10… redst… 1.23e6 claim     The …
#>  7 https://www.… 2019-01-23T10… redst… 1.23e6 claim     The …
#>  8 https://www.… 2019-01-23T10… redst… 1.23e6 claim     The …
#>  9 https://www.… 2019-01-23T10… redst… 1.23e6 claim     The …
#> 10 https://www.… 2019-01-23T10… redst… 1.23e6 claim     The …
#> # … with 1,528 more rows, and 2 more variables: tweet_created_at <chr>,
#> #   tweet_id <chr>
```

Get timeline of tweets on articles.


```r
(tl <- hx_timeline(articles$id[1:5]))
#> # A tibble: 164 x 3
#>    timestamp            volume type 
#>    <chr>                 <dbl> <chr>
#>  1 2019-01-23T00:00:00Z     40 claim
#>  2 2019-01-24T00:00:00Z    111 claim
#>  3 2019-01-25T00:00:00Z    112 claim
#>  4 2019-01-26T00:00:00Z    112 claim
#>  5 2019-01-27T00:00:00Z    112 claim
#>  6 2019-01-28T00:00:00Z    112 claim
#>  7 2019-01-29T00:00:00Z    138 claim
#>  8 2019-01-30T00:00:00Z    473 claim
#>  9 2019-01-31T00:00:00Z    512 claim
#> 10 2019-02-01T00:00:00Z    512 claim
#> # … with 154 more rows
```
