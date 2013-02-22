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

#################################################################################
args=("$@")
NUM1=$#
NUM2=2

maxZoom=14
minZoom=10
deps # check dependencies imagemagick-convert 
 n=-1
 for i in ${args[@]}; do
 	if [ -d $i ]; then 
 	 	echo "["."$(( n += 1 ))"."]" " $i"		
 	fi
 done
 DIRS="$n"


for directory in ${Directories[@]}; do
	if [ -d $directory ]; then 
		echo "$directory" 
		FILES=$directory/**
		TILEFILESARRAY=(`echo $FILES`)
		# echo "*******\n$FILES\n"
	 	for tiledirectory in ${TILEFILESARRAY[@]}
		do
			#assign the tiledirectory with the directory of the TMS images 


		done
###############################################################define band combinations 
			# echo "band combination = $bandCombination"
			#assign bands array withe the directories of the tms bands so they can be located. 

			echo "/n################################################"		
			echo "# processing $bandCombination"		
			echo "##################################################"		
###############################################################process zoom levels		
	 #for band in ${bands[@]}; do
		for (( i=$minZoom; i <=$maxZoom; i++ )); do #ZOOM - LEVEL OF DETAIL  #n 	n>2 × n>2 tiles 	2>2n tiles 
			#n = level of detail source http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#X_and_Y 

				echo "Rows = $(pow 2 $i)"
				ROWFILES=${bands[0]}/$i/**
				ROWTILEFILESARRAY=(`echo $ROWFILES`)
				a=$ROWTILEFILESARRAY; 

				# echo $a
				for rows in ${ROWTILEFILESARRAY[@]}	
					do
						a=${rows##*/}
						# echo "a = $a ROWS = $rows"
						# echo "rows = $rows"
						COLFILES=$rows/**
						COLTILEFILESARRAY=(`echo $COLFILES`)
						# echo "########## $COLTILEFILESARRAY"
						b=$COLTILEFILESARRAY; 

						# echo $b
						for col in ${COLTILEFILESARRAY[@]}	
						do

							b=${col##*/}
							# echo "i = $i"
							# echo "a = $a"
							# echo "b = $b"

						done
					fi 
				done	
			fi 
		done
	fi
done