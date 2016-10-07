if [ ! -f previous_nb_words.txt ]; then
    touch previous_nb_words.txt
    nb_lines=$(cat webpages.txt | wc -l)
    for idx in $(seq 0 $nb_lines); do
        echo "0" >> previous_nb_words.txt
    done
fi

cat  previous_nb_words.txt

# -------- STEP 0 --------
# build the set of words to scan
idx=0
while read word; do
    if [ $idx = 0 ]; then
        key_words="$word"
    else
        key_words="$key_words\|$word"
    fi
    idx=$(($idx+1))
    done < keywords.txt

echo ----- key words: $key_words

# -------- STEP 1 -------- 
# update the previousNbWord array with the previous number 
# of key words found per web pages
idx=0
while read previous_nb_word; do
    previousNbWord[$idx]=$previous_nb_word
    idx=$(($idx+1))
done < previous_nb_words.txt

# -------- STEP 2 --------
# for each web page of the webpages.txt file
# looking for the key words in its content
idx=0
while read line_content; do
    echo ----- $line_content

    # download the web page and read its content
    web_page=$(wget $line_content -q -O -)
    echo $web_page > ${PWD}/log.txt

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

    # find and count the number of key words into the current web page
    nb_words[$idx]=$(grep -o $key_words ${PWD}/log.txt | wc -l)

    # test the current and the previous number of words found
    if [ ${nb_words[$idx]} = ${previousNbWord[$idx]} ]; then
        echo not found
    else
        echo found
    fi

    idx=$(($idx+1))

    done < webpages.txt

# -------- STEP 3 -------- 
# update the previous_nb_words.txt file with the number
# of key words found per web pages
nb_lines=$(cat previous_nb_words.txt | wc -l)
rm  previous_nb_words.txt
for idx in $(seq 0 $nb_lines); do
    echo -n ${nb_words[$idx]} >> previous_nb_words.txt
    # avoid to add a line at the end of the file
    if [ $idx -ne $(($nb_lines-1)) ]; then
        echo -n -e "\n" >> previous_nb_words.txt
    fi
done

echo ----- end
