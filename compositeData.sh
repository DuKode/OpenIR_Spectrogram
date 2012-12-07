#!/bin/bash
#The DuKode Studio 2012
#author ilias koen
#desc: generate single band tms files. 
#ex .createTMSforSingleBands <directory of band tiffs> 
# place tif files on their directories and parce the directories as arguments (where test a directory with the unzipped tif bands)
#ex sh createTMSforSingleBands.sh test test1 


function deps(){
        DEPENDENCIES="convert"
         deps_ok=YES
        for dep in $DEPENDENCIES
        do
                if ! which $dep &>/dev/null;  then
                        echo "This script requires $dep to run but it is not installed."
                        echo "If you are running ubuntu or debian you might be able to install $dep with the following command:"
                        echo "sudo apt-get install $dep"
						deps_ok=NO
                fi
        done        
        if [[ $deps_ok == NO ]]; then
                echo Unmet dependencies... Aborting!
                exit 1
        else               
			return 0
        fi
}

# x to the power of y function  
pow() {
    local x y res i
    x=$1
    y=$2
    res=1
    i=1
    while [ $i -le $y ]; do
        res=$(( res * x ))
        i=$(( i + 1 ))
    done
    echo $res
}

#copy and merge the TMS grey scale files with the newTMS directory name and the specified band combination 
#ex. createTMSLayerWithDirectoriesAndDestinationAndBandCombinations ${args[@]} "754" "754" 
createTMSLayerWithDirectoriesAndDestinationAndBandCombinations()
{ 
	local Directories DestinationDirectory bandCombination
	DestinationDirectory=$1
	bandCombination=$2
	directory=$3 
	echo "DestinationDirectory = $DestinationDirectory"
	# echo "Directories = ${args[@]}"
	echo "bandCombination = $bandCombination"
	echo "directory = $directory"
 	
	# check for errors 
	#
	
	#

###############################################################go into the directories of the data parced in the original command  
	if [ -d $directory ]; then 
		# echo "$directory" 
		echo "/n################################################"		
		echo "#"
		echo "# processing $directory"		
		echo "#"
		echo "#################################################\n"		
		
		FILES=$directory/**
		TILEFILESARRAY=(`echo $FILES`)
		# echo "*******\n$FILES\n"
	 	for tiledirectory in ${TILEFILESARRAY[@]}
		do
		
				if [ -d $tiledirectory ]; then 
					# echo "tiledirectory = $tiledirectory"
					#assign the tms bands directories to the variables. 
					############# GLS2005 ############# || #### EarthSat-Orthorectified ### || ################# USGS ######## || ############# GLS2000 ###########
					if [[ "$tiledirectory" == *B10* ]]  || [[ "$tiledirectory" == *nn10* ]] || [[ "$tiledirectory" == *nn1* ]] || [[ "$tiledirectory" == *_10* ]] || [[ "$tiledirectory" == *b01 ]]; then 
						# echo "tiled directory10 "
						band10="$tiledirectory"
					elif [[ "$tiledirectory" == *B20* ]] || [[ "$tiledirectory" == *nn20* ]] || [[ "$tiledirectory" == *nn2* ]] || [[ "$tiledirectory" == *_20* ]] || [[ "$tiledirectory" == *b02* ]]; then 
						# echo "tiled directory20"
						 band20="$tiledirectory"
					elif [[ "$tiledirectory" == *B30* ]] || [[ "$tiledirectory" == *nn30* ]] || [[ "$tiledirectory" == *nn3* ]] || [[ "$tiledirectory" == *_30* ]] || [[ "$tiledirectory" == *b03* ]]; then 
						# echo "tiled directory30"
						band30="$tiledirectory"
					elif [[ "$tiledirectory" == *B40* ]] || [[ "$tiledirectory" == *nn40* ]] || [[ "$tiledirectory" == *nn4* ]] || [[ "$tiledirectory" == *_40* ]] || [[ "$tiledirectory" == *b04* ]]; then 
						# echo "tiled directory40"
						band40="$tiledirectory"
					elif [[ "$tiledirectory" == *B50* ]] || [[ "$tiledirectory" == *nn50* ]] || [[ "$tiledirectory" == *nn5* ]] || [[ "$tiledirectory" == *_50* ]] || [[ "$tiledirectory" == *b05* ]]; then 
						# echo "tiled directory50"
						band50="$tiledirectory"
					elif [[ "$tiledirectory" == *B60* ]] || [[ "$tiledirectory" == *nn60* ]] || [[ "$tiledirectory" == *nn6* ]] || [[ "$tiledirectory" == *_60* ]] || [[ "$tiledirectory" == *b06* ]]; then 
						# echo "tiled directory60"
						band60="$tiledirectory"
					elif [[ "$tiledirectory" == *B70* ]] || [[ "$tiledirectory" == *nn70* ]] || [[ "$tiledirectory" == *nn7* ]] || [[ "$tiledirectory" == *_70* ]] || [[ "$tiledirectory" == *b07* ]]; then 
						# echo "tiled directory70"
						band70="$tiledirectory"
					elif [[ "$tiledirectory" == *B80* ]] || [[ "$tiledirectory" == *nn80* ]] || [[ "$tiledirectory" == *nn8* ]] || [[ "$tiledirectory" == *_80* ]] || [[ "$tiledirectory" == *b08* ]]; then 
						# echo "tiled directory70"
						band80="$tiledirectory"
					fi
				fi

		done
###############################################################define band combinations 
			# echo "band combination = $bandCombination"
			#assign bands array withe the directories of the tms bands so they can be located. 
				if [[ $bandCombination == "321" ]]; then 
					bands=($band30 $band20 $band10);
				elif [[ $bandCombination == "432" ]]; then 
					bands=($band40 $band30 $band20);
				elif [[ $bandCombination == "453" ]]; then 
					bands=($band40 $band50 $band30);
				elif [[ $bandCombination == "543" ]]; then 
					bands=($band50 $band40 $band30);
				elif [[ $bandCombination == "754" ]]; then 
					# echo "############################754"
					bands=($band70 $band50 $band40);
				fi
		# echo "bands array = ${bands[@]}" 
		tLen=${#bands[@]}
		if [[ $tLen != "3" ]]
		then 
			echo "error: band combimation array is not setup properly, check your TMS layers to identify missing data"
			exit 0 
		fi
		
		echo "/n################################################"		
		echo "# processing $bandCombination"		
		echo "##################################################"
###############################################################process zoom levels		
	 #for band in ${bands[@]}; do
		for (( i=$minZoom; i <=$maxZoom; i++ )); do #ZOOM - LEVEL OF DETAIL  #n 	n>2 × n>2 tiles 	2>2n tiles 
			#n = level of detail source http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#X_and_Y 
			########
			echo "# processing $bandCombination zoomlevel $i of $maxZoom"		
			echo "################################################"
			
			# echo "bands is set or not ?: ${bands[1]}/$i"
			if [ -d "${bands[0]}/$i" ]; then 
				 echo "directory $i exists" 
				# echo "*"
				#start tiles rows and columns. 
				echo "Rows = $(pow 2 $i)"
				ROWFILES=${bands[0]}/$i/**
				ROWTILEFILESARRAY=(`echo $ROWFILES`)
				# echo ${ROWTILEFILESARRAY[0]/*%/}
				a=$ROWTILEFILESARRAY; 
			
				# echo $a
				for rows in ${ROWTILEFILESARRAY[@]}	
					do
						a=${rows##*/}
						# echo "a = $a ROWS = $rows"
						echo "rows = $a "
						if [ -d "${bands[0]}/$i/$a" ]; then 
 					    # echo "row directory $r exists" 
 						# echo "*"
 						if [[ ! -d $DestinationDirectory ]]; then 
 							mkdir $DestinationDirectory 
 						fi 
 						if [[ ! -d $DestinationDirectory/$i/ ]]; then 
 							mkdir $DestinationDirectory/$i/
 						fi
 						if [[ ! -d $DestinationDirectory/$i/$a ]]; then 
 							mkdir $DestinationDirectory/$i/$a
 						fi
						# echo "rows = $rows"
						COLFILES=$rows/**
						COLTILEFILESARRAY=(`echo $COLFILES`)
						# echo "########## $COLTILEFILESARRAY"
						b=$COLTILEFILESARRAY; 
						
						# echo $b
						for col in ${COLTILEFILESARRAY[@]}	
						do
							
							b=${col##*/}
							# echo ""
							# echo ""
							# echo "{bands[0]} = ${bands[0]}"
							# echo "i = $i"
							# echo "a = $a"
							# echo "b = $b"
							# # echo ""
							# 						 	echo "{bands[0]}/i/a/b = ${bands[0]}/$i/$a/$b"
							# echo "here" 
							# cd "${bands[0]}/7/"
							# ls 

							if [ -f "${bands[0]}/$i/$a/$b" ]; then 	# if file exists
								# echo "*"
								if [ -f "$DestinationDirectory/$i/$a/$b" ]; then #destination file exist: merge to composite with files in directory
									 # echo "file exists and it is combined *" 
									# echo "directory $i processing" 
									convert -channel RGB "${bands[0]}/$i/$a/$b" "${bands[1]}/$i/$a/$b" "${bands[2]}/$i/$a/$b" -set colorspace RGB -combine -set colorspace sRGB -transparent black "c.png"
									convert "$DestinationDirectory/$i/$a/$b" c.png -composite "$DestinationDirectory/$i/$a/$b" 
									# rm "c.png"
						
							 	else 	#destination file does not exist: copy file to directory
									 # echo "directory $a does not exist and it is copied"
							 	  	# cp "${bands[0]}/$i/$r/$c.png" "$DestinationDirectory/$i/$r/c.png"
								    convert  -channel RGB  "${bands[0]}/$i/$a/$b" "${bands[1]}/$i/$a/$b" "${bands[2]}/$i/$a/$b" -set colorspace RGB -combine -set colorspace sRGB -transparent black "$DestinationDirectory/$i/$a/$b"
								fi
							else 
								echo "file does not exist"
							fi
						done
 					fi 
				done	
			fi 
		done
	fi

}


createTMSLayerWithDirectoriesAndDestinationAndBandCombinations_singleBand()
{ 
	local Directories DestinationDirectory bandCombination
	Directories=("${args[@]}")
	DestinationDirectory=$1
	bandCombination=$2

	echo "Directories = ${args[@]}"
	echo "DestinationDirectory = $DestinationDirectory"
	echo "bandCombination = $bandCombination"
	# exit 0 

	# exit 0 
###############################################################go into the directories of the data parced in the original command  
for directory in ${Directories[@]}; do
	if [ -d $directory ]; then 
		echo "$directory" 
		FILES=$directory/**
		TILEFILESARRAY=(`echo $FILES`)
		# echo "*******\n$FILES\n"
	 	for tiledirectory in ${TILEFILESARRAY[@]}
		do
		
				if [ -d $tiledirectory ]; then 
					# echo "tiledirectory = $tiledirectory"
					#assign the tms bands directories to the variables. 
					############# GLS2005 ############# || #### EarthSat-Orthorectified ### || ################# USGS ######## || ############# GLS2000 ###########
					if [[ "$tiledirectory" == *B10* ]]  || [[ "$tiledirectory" == *nn10* ]] || [[ "$tiledirectory" == *nn1* ]] || [[ "$tiledirectory" == *_10* ]] || [[ "$tiledirectory" == *b01 ]]; then 
						# echo "tiled directory10 "
						band10="$tiledirectory"
					elif [[ "$tiledirectory" == *B20* ]] || [[ "$tiledirectory" == *nn20* ]] || [[ "$tiledirectory" == *nn2* ]] || [[ "$tiledirectory" == *_20* ]] || [[ "$tiledirectory" == *b02* ]]; then 
						# echo "tiled directory20"
						 band20="$tiledirectory"
					elif [[ "$tiledirectory" == *B30* ]] || [[ "$tiledirectory" == *nn30* ]] || [[ "$tiledirectory" == *nn3* ]] || [[ "$tiledirectory" == *_30* ]] || [[ "$tiledirectory" == *b03* ]]; then 
						# echo "tiled directory30"
						band30="$tiledirectory"
					elif [[ "$tiledirectory" == *B40* ]] || [[ "$tiledirectory" == *nn40* ]] || [[ "$tiledirectory" == *nn4* ]] || [[ "$tiledirectory" == *_40* ]] || [[ "$tiledirectory" == *b04* ]]; then 
						# echo "tiled directory40"
						band40="$tiledirectory"
					elif [[ "$tiledirectory" == *B50* ]] || [[ "$tiledirectory" == *nn50* ]] || [[ "$tiledirectory" == *nn5* ]] || [[ "$tiledirectory" == *_50* ]] || [[ "$tiledirectory" == *b05* ]]; then 
						# echo "tiled directory50"
						band50="$tiledirectory"
					elif [[ "$tiledirectory" == *B60* ]] || [[ "$tiledirectory" == *nn60* ]] || [[ "$tiledirectory" == *nn6* ]] || [[ "$tiledirectory" == *_60* ]] || [[ "$tiledirectory" == *b06* ]]; then 
						# echo "tiled directory60"
						band60="$tiledirectory"
						elif [[ "$tiledirectory" == *B61* ]] ; then 
							# echo "tiled directory60"
							band61="$tiledirectory"
						elif [[ "$tiledirectory" == *B62* ]] ; then 
							# echo "tiled directory60"
							band62="$tiledirectory"
					elif [[ "$tiledirectory" == *B70* ]] || [[ "$tiledirectory" == *nn70* ]] || [[ "$tiledirectory" == *nn7* ]] || [[ "$tiledirectory" == *_70* ]] || [[ "$tiledirectory" == *b07* ]]; then 
						# echo "tiled directory70"
						band70="$tiledirectory"
					elif [[ "$tiledirectory" == *B80* ]] || [[ "$tiledirectory" == *nn80* ]] || [[ "$tiledirectory" == *nn8* ]] || [[ "$tiledirectory" == *_80* ]] || [[ "$tiledirectory" == *b08* ]]; then 
						# echo "tiled directory70"
						band80="$tiledirectory"
					fi
				fi

		done
###############################################################define band combinations 
			# echo "band combination = $bandCombination"
			#assign bands array withe the directories of the tms bands so they can be located. 
				if [[ $bandCombination == "111" ]]; then 
					bands=($band10 $band10 $band10);
				elif [[ $bandCombination == "222" ]]; then 
					bands=($band20 $band20 $band20);
				elif [[ $bandCombination == "333" ]]; then 
					bands=($band30 $band30 $band30);
				elif [[ $bandCombination == "444" ]]; then 
					bands=($band40 $band40 $band40);
				elif [[ $bandCombination == "555" ]]; then 
					bands=($band50 $band50 $band50);
					# band 6 has issues 
				elif [[ $bandCombination == "666" ]]; then  
					bands=($band60 $band60 $band60);
					# 
				elif [[ $bandCombination == "61" ]]; then  
						bands=($band61 $band61 $band61);
				elif [[ $bandCombination == "62" ]]; then  
						bands=($band62 $band62 $band62);
				elif [[ $bandCombination == "777" ]]; then 
					bands=($band70 $band70 $band70);
				elif [[ $bandCombination == "888" ]]; then 
					bands=($band80 $band80 $band80);
				fi
		# echo "bands array = ${bands[@]}" 
		tLen=${#bands[@]}
		if [[ $tLen != "3" ]]
		then 
			echo "bandCombination: $bandCombination"
			echo "bands: ${#bands[@]}"
			echo "$band80 "
			echo "error: band combimation array is not setup properly, check your TMS layers to identify missing data"
			exit 0 
		fi
			echo "/n################################################"		
			echo "# processing $bandCombination"		
			echo "##################################################"		
###############################################################process zoom levels		
	 #for band in ${bands[@]}; do
		for (( i=$minZoom; i <=$maxZoom; i++ )); do #ZOOM - LEVEL OF DETAIL  #n 	n>2 × n>2 tiles 	2>2n tiles 
			#n = level of detail source http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#X_and_Y 
			########
			echo "# processing $bandCombination zoomlevel $i of $maxZoom"		
			echo "################################################"
			
			# echo "bands is set or not ?: ${bands[1]}/$i"
			if [ -d "${bands[0]}/$i" ]; then 
				 echo "directory $i exists" 
				# echo "*"
				#start tiles rows and columns. 
				echo "Rows = $(pow 2 $i)"
				ROWFILES=${bands[0]}/$i/**
				ROWTILEFILESARRAY=(`echo $ROWFILES`)
				# echo ${ROWTILEFILESARRAY[0]/*%/}
				a=$ROWTILEFILESARRAY; 
			
				# echo $a
				for rows in ${ROWTILEFILESARRAY[@]}	
					do
						a=${rows##*/}
						# echo "a = $a ROWS = $rows"
						echo "rows = $a "
						if [ -d "${bands[0]}/$i/$a" ]; then 
					    # echo "row directory $r exists" 
						# echo "*"
						if [[ ! -d $DestinationDirectory ]]; then 
							mkdir $DestinationDirectory 
						fi 
						if [[ ! -d $DestinationDirectory/$i/ ]]; then 
							mkdir $DestinationDirectory/$i/
						fi
						if [[ ! -d $DestinationDirectory/$i/$a ]]; then 
							mkdir $DestinationDirectory/$i/$a
						fi
						# echo "rows = $rows"
						COLFILES=$rows/**
						COLTILEFILESARRAY=(`echo $COLFILES`)
						# echo "########## $COLTILEFILESARRAY"
						b=$COLTILEFILESARRAY; 
						
						# echo $b
						for col in ${COLTILEFILESARRAY[@]}	
						do
							
							b=${col##*/}
							# echo ""
							# echo ""
							# echo "{bands[0]} = ${bands[0]}"
							# echo "i = $i"
							# echo "a = $a"
							# echo "b = $b"
							# # echo ""
							# 						 	echo "{bands[0]}/i/a/b = ${bands[0]}/$i/$a/$b"
							# echo "here" 
							# cd "${bands[0]}/7/"
							# ls 

							if [ -f "${bands[0]}/$i/$a/$b" ]; then 	# if file exists
								# echo "*"
								if [ -f "$DestinationDirectory/$i/$a/$b" ]; then #destination file exist: merge to composite with files in directory
									 # echo "file exists and it is combined *" 
									# echo "directory $i processing" 
									convert -channel RGB "${bands[0]}/$i/$a/$b" "${bands[1]}/$i/$a/$b" "${bands[2]}/$i/$a/$b" -set colorspace RGB -combine -set colorspace sRGB -transparent black "c.png"
									convert "$DestinationDirectory/$i/$a/$b" c.png -composite "$DestinationDirectory/$i/$a/$b" 
									# rm "c.png"
						
							 	else 	#destination file does not exist: copy file to directory
									 # echo "directory $a does not exist and it is copied"
							 	  	# cp "${bands[0]}/$i/$r/$c.png" "$DestinationDirectory/$i/$r/c.png"
								    convert  -channel RGB  "${bands[0]}/$i/$a/$b" "${bands[1]}/$i/$a/$b" "${bands[2]}/$i/$a/$b" -set colorspace RGB -combine -set colorspace sRGB -transparent black "$DestinationDirectory/$i/$a/$b"
								fi
							else 
								echo "file does not exist"
							fi
						done
					fi 
				done	
			fi 
		done
	fi
done


}
#################################################################################
args=("$@")
NUM1=$#
NUM2=2

maxZoom=10
minZoom=5
deps # check dependencies imagemagick-convert 
 n=-1
 for i in ${args[@]}; do
 	if [ -d $i ]; then 
 	 	echo "["."$(( n += 1 ))"."]" " $i"		
 	fi
 done
 DIRS="$n"
 # echo $DIRS

# 
echo "\n "
# 
for i in ${args[@]}; do
 	createTMSLayerWithDirectoriesAndDestinationAndBandCombinations "321" "321" "$i"
done 

for i in ${args[@]}; do
	createTMSLayerWithDirectoriesAndDestinationAndBandCombinations "432" "432" "$i"
done 

for i in ${args[@]}; do
	createTMSLayerWithDirectoriesAndDestinationAndBandCombinations "543" "543" "$i"
done 

for i in ${args[@]}; do
	createTMSLayerWithDirectoriesAndDestinationAndBandCombinations "453" "453" "$i"
done 
# 
for i in ${args[@]}; do
	createTMSLayerWithDirectoriesAndDestinationAndBandCombinations "754" "754" "$i"
done 



# 
# echo "\n"
# 
createTMSLayerWithDirectoriesAndDestinationAndBandCombinations_singleBand "111" "111"
createTMSLayerWithDirectoriesAndDestinationAndBandCombinations_singleBand "222" "222"
createTMSLayerWithDirectoriesAndDestinationAndBandCombinations_singleBand "333" "333"
createTMSLayerWithDirectoriesAndDestinationAndBandCombinations_singleBand "444" "444"
createTMSLayerWithDirectoriesAndDestinationAndBandCombinations_singleBand "555" "555"

createTMSLayerWithDirectoriesAndDestinationAndBandCombinations_singleBand "61" "61"
createTMSLayerWithDirectoriesAndDestinationAndBandCombinations_singleBand "62" "62"

# # createTMSLayerWithDirectoriesAndDestinationAndBandCombinations_singleBand "666" "666" #band b06 is missing in some files and only b61 and b62 exist. 
createTMSLayerWithDirectoriesAndDestinationAndBandCombinations_singleBand "777" "777"
createTMSLayerWithDirectoriesAndDestinationAndBandCombinations_singleBand "888" "888" #band80 is not processed as of now. 

echo "\n"
exit 0 

