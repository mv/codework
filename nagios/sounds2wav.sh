

# http://www.trekcore.com/audio/
# http://soundbible.com/1450-Air-Horn.html

# http://www.cyberciti.biz/faq/convert-mp3-files-to-wav-files-in-linux/
# brew install mpg321


# from mp3 to wav
for f in *mp3
do
    [ ! -f "${f%.*}.wav ] && mpg321 -1 $f ${f%.*}.wav
done

