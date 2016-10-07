# build the words set
idx=0
while read word; do
    if [ $idx = 0 ]; then
        key_words="$word"
    else
        key_words="$key_words\|$word"
    fi
    idx=idx+1
    done < keywords.txt

echo ----- key words: $key_words

# for each web page of the webpages.txt file
# looking for the key words in its content
while read line_content; do
    echo ----- $line_content

    # download the web page and read its content
    web_page=$(wget $line_content -q -O -)
    echo $web_page >> ${PWD}/log.txt

    # arg?
    if [ -z "$1" ]; then
        echo .
    else
        # verbose ?
        if [ $1 = "-v" ]; then
            echo $web_page | grep --color=always $key_words
        else
            echo .
        fi
    fi

    # grep the key words into the page
    if grep -q $key_words ${PWD}/log.txt; then
        echo found
    else
        echo not found
    fi

    done < webpages.txt

echo ----- end
