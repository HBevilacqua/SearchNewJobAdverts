# SearchNewJobAdverts
This script counts the number of key words (listed in list_keywords.txt)
per web pages (= per lines in list_webpages.txt),<br>
compares the result with the previous one (reg_nb_words.txt)<br>
informs the user about new information based on key words.<br>

### Motivations
Experimental code in *shell*.

### Instructions
1) Write the list of web pages in the "list_webpages.txt" file.

2) Write the list of words to look for in the "list_keywords.txt" file.

3) Run the script:
```sh
$ ./search_new_job_adverts.sh
```

Or:

(-v) verbose mode to see the web pages content with the found words
```sh
$ ./search_new_job_adverts.sh -v
```
### Outputs
- the web pages to visit
- reg_nb_words.txt: the number of key words found per web pages
- log.txt: the downloaded web pages
