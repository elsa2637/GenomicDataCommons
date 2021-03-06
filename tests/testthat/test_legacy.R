library(GenomicDataCommons)
library(magrittr)
context('legacy endpoint')

## This fixes a problem whereby the testthat
## errors out with a 404 error unless this
## sleep is here. A sleep of 3 does not work;
## 5 seconds is the shortest time that I could
## find to be reproducibly fixing the problem.
Sys.sleep(5) 
             

## IDs here were selected interactively, just for testing.
## If GDC removes these IDs, expect tests to fail.

files_legacy_ids = files(legacy = TRUE) %>% results(size = 10) %>% ids()

cases_legacy_ids = cases(legacy = TRUE) %>% results(size = 10) %>% ids()

###########################
##
## FILES
##
###########################

## ID functionality

test_that("legacy file ids NOT in regular archive", {
    fquery = files(legacy = TRUE) %>% filter( ~ file_id %in% files_legacy_ids) 
    fres = fquery %>% ids()
    expect_length(fres,10)
})

test_that("legacy file ids found", {
    fquery = files()
    fquery$legacy = TRUE
    fres = fquery %>% filter( ~ file_id %in% files_legacy_ids) %>% ids()
    expect_length(fres,length(files_legacy_ids))
    rm(fquery,fres)
})


## Manifest functionality

test_that("legacy manifest matches legacy ids", {
    fquery = files()
    fquery$legacy = TRUE
    fres = fquery %>% filter( ~ file_id %in% files_legacy_ids) %>% manifest()
    expect_equal(nrow(fres),length(files_legacy_ids))
    expect_true(all(fres$id %in% files_legacy_ids))
})

###########################
##
## Cases
##
###########################


## ID functionality

test_that("legacy case ids found", {
    cquery = cases()
    cquery$legacy = TRUE
    cres = cquery %>% filter( ~ case_id %in% cases_legacy_ids) %>% ids()
    expect_equal(length(cres),length(cases_legacy_ids))
})

# Note that case ids may be in both legacy and default archives
test_that("legacy case ids NOT in default archive", {
    cquery = cases()
    cquery$legacy = TRUE
    cres = cquery %>% filter( ~ case_id %in% cases_legacy_ids) %>% ids()
    expect_equal(length(cres),10)
})

