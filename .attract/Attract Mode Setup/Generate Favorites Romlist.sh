cd /home/pi/.attract/romlists
rm Favorites.tag

clear
echo
echo "This script will generate a new romlist called Favorites.txt."
echo 
echo "The new romlist will contain all of your current tagged favorites from all different romlists."
echo
sleep 5

echo
echo "Renaming old Favorites.txt file ....."
sleep 5
mv Favorites.txt Favorites.txt.backup

echo
echo "Gathering file listing of tagged favorites ....."
sleep 5

echo
echo "Generating new Favorites.txt file ....."
sleep 5
echo

ls *.tag > tagfiles

while read filename
do
echo "Using ${filename} ....."
echo

  while read gamename
  do
    romlist=`echo ${filename} |cut -f1 -d '.'`
    echo "     Searching ${romlist}.txt for ${gamename} ....."
    cat "${romlist}.txt"|grep "[;]${gamename}[;]" >> Favorites.txt
  done < "${filename}"

sleep 5
echo
done < tagfiles

rm tagfiles

echo "Finished creating new Favorites.txt ....."
echo
echo

echo "Using this new romlist, create a new Display and choose Favorites as the romlist for it."
echo    
echo "You may need to periodically update the Favorites romlist as you add tad new favorites."
echo
echo
sleep 10
echo 
