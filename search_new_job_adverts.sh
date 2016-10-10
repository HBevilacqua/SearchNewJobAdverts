# -------- STEP 0  --------
# create the file to store the number of key words
if [ ! -f reg_nb_words.txt ]; then
    touch reg_nb_words.txt
    nb_lines=$(cat list_webpages.txt | wc -l)
    for idx in $(seq 0 $nb_lines); do
        echo "0" >> reg_nb_words.txt
    done
fi
# test purpose:
#cat reg_nb_words.txt

# -------- STEP 1 --------
# build the set of words to scan
idx=0
while read word; do
    if [ $idx = 0 ]; then
        key_words="$word"
    else
        key_words="$key_words\|$word"
    fi
    idx=$(($idx+1))
    done < list_keywords.txt

# test purpose:
#echo ----- key words: $key_words

# -------- STEP 2 --------
# update the previousNbWord array with the previous number
# of key words found per web pages
idx=0
while read previous_nb_word; do
    previousNbWord[$idx]=$previous_nb_word
    idx=$(($idx+1))
done < reg_nb_words.txt

# -------- STEP 3 --------
# for each web page of the list_webpages.txt file
# looking for the key words in its content
idx=0
while read line_content; do
    echo ----- $line_content

    # download the web page and read its content
    web_page=$(wget $line_content -q -O -)
    echo $web_page > ${PWD}/log.txt

    # arg?
    if [ ! -z "$1" ]; then
        # verbose ?
        if [ $1 = "-v" ]; then
            echo $web_page | grep --color=always $key_words
        fi
    fi

    # find and count the number of key words into the current web page
    currentNbWords[$idx]=$(grep -o $key_words ${PWD}/log.txt | wc -l)

    # test the current and the previous number of words found
    if [ ! ${currentNbWords[$idx]} = ${previousNbWord[$idx]} ]; then
        echo page to visit
    fi

    idx=$(($idx+1))

    done < list_webpages.txt

# -------- STEP 4 --------
# update the reg_nb_words.txt file with the number
# of key words found per web pages
nb_lines=$(cat reg_nb_words.txt | wc -l)
rm  reg_nb_words.txt
for idx in $(seq 0 $nb_lines); do
    echo -n ${currentNbWords[$idx]} >> reg_nb_words.txt
    # avoid to add a line at the end of the file
    if [ $idx -ne $(($nb_lines-1)) ]; then
        echo -n -e "\n" >> reg_nb_words.txt
    fi
done
