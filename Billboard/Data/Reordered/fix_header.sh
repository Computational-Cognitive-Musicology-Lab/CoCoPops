#!/bin/sh
###############################################################################################
###############################################################################################
for i in "$@"
do
old_name="$i"
new_name=${old_name%.*}
# sed -E 's:(\*\*[a-z]+)\.[0-9]+:\1:g' ${i} > ./FixedHeader/$old_name
extract -i "**harmony,**harte" $old_name > renamed1.txt
extract -i "**kern,**silbe" $old_name > renamed2.txt
extract -i "**rhyme,**timestamp,**phrase" $old_name > renamed3.txt
extractx -s "2,3,1" ./renamed3.txt > renamed4.txt
assemble ./renamed1.txt ../renamed2.txt ./renamed4.txt > ./AAssembly/$old_name
rm renamed1.txt
rm renamed2.txt
rm renamed3.txt
rm renamed4.txt
done

exit
