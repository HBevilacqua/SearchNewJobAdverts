key_words='developpeur\|ingenieur\|temps-reel\|embarqué'

#---------- citech ------------
web_citech=$(wget https://careers.smartrecruiters.com/CITECH/citech_jobs -q -O -)
if [ $1 = "-v" ]
then
    echo $web_citech | grep --color=always $key_words
else
    echo is seeking on citech...
fi

echo $web_page_citech >> /home/pi/workspace/log.txt
if grep -q $key_words /home/pi/workspace/log.txt; then
    echo citech found
else
    echo citech not found
fi

#---------- viveris ------------
web_page_viveris=$(wget https://www.viveris.fr/index.php/carrieres-et-emplois/viveris-ressources-humaines-offres-emplois-stages-ssi/viveris-ressources-humaines-offres-emplois.html?filter_32=3 -q -O -) 
echo $web_page_viveris >> /home/pi/workspace/log.txt

if [ $1 = "-v" ]
then
    echo $web_page_viveris | grep --color=always $key_words
else
    echo is sekking on viveris...
fi

if grep -q $key_words /home/pi/workspace/log.txt; then
    echo viveris found 
else
    echo viveris not found
fi


#http://www.cyberciti.biz/faq/grep-regular-expressions/
