#!/bin/bash

#png=`find | grep -v "\.git" | grep "\.png$"`
#jpg=`find | grep -v "\.git" | grep "\.jpg$"`
#   find  -maxdepth 1   may be useful


timestartg()
{
	TSG=`date +%s.%N`
}
timestartg


timeendg()
{
	TEG=`date +%s.%N`
	TDG=`calc $TEG - $TSG`
	echo "$TDG"
}



timestart()
{
	TS=`date +%s.%N`
}

timeend()
{
	TE=`date +%s.%N`
	TD=`calc $TE - $TS`
}

for i in $(git ls-files ./ | grep "\.jpg$") ; do #jpg (ALSO NEEDS JpEg)
	timestart 
	jpegoptim --strip-all $i >> /tmp/mytrimage_jpeg.log
	timeend
	echo $TD $i
done &

for i in $(git ls-files ./ | grep "\.png$"); do # png
	timestart
	optipng -zc1-9 -zm1-9 -zs0-3 -f0-5 $i >> /tmp/mytrimage_png.log
	advpng -z4 $i >> /tmp/mytrimage_png.log
	pngcrush -rem gAMA -rem alla -rem cHRM -rem iCCP -rem sRGB -rem time $i $i.foo  >> /tmp/mytrimage_png.log
	#find out if we save sth or not
	if [[ `du -b $i | awk '{print $1}'` -gt `du -b $i.foo | awk '{print $1}'` ]] ; then
		mv $i.foo $i
	else
		rm $i.foo
	fi
	timeend
	echo $TD $i
done & 
wait


git status | grep "modified" | awk '{print $3}' > /tmp/mytrimage.todo #reprocess already changed images
todonr=`cat /tmp/mytrimage.todo | wc -l`
echo $todonr todo
date=`date`
git commit -a -m "mytrimage $date"

while [ $todonr -gt 0 ] ; do
	for i in $(cat /tmp/mytrimage.todo | grep "\.jpg$") ; do # jpg  ALSO NEEDS jpEg
		timestart 
		jpegoptim -f --strip-all $i >> /tmp/mytrimage_jpeg.log
		timeend
		echo $TD $i
	done &



	for i in $(cat /tmp/mytrimage.todo | grep "\.png$"); do  #png
		timestart
		optipng -zc1-9 -zm1-9 -zs0-3 -f0-5 $i >> /tmp/mytrimage_png.log
		advpng -z4 $i >> /tmp/mytrimage_png.log
		pngcrush -rem gAMA -rem alla -rem cHRM -rem iCCP -rem sRGB -rem time $i $i.foo  >> /tmp/mytrimage_png.log
		#find out if we save sth or not
		if [[ `du -b $i | awk '{print $1}'` -gt `du -b $i.foo | awk '{print $1}'` ]] ; then
			mv $i.foo $i
		else
			rm $i.foo
		fi
		timeend
		echo $TD $i
	done &
	wait

git status | grep "modified" | awk '{print $3}' > /tmp/mytrimage.todo
todonr=`cat /tmp/mytrimage.todo | wc -l`
echo $todonr todo
date=`date`
git commit -a -m "mytrimage $date"
done


timeendg


exit
# how can we do multithreading ?

while [ $i -lt (lessthen) ${$cores + 1} ] ; do
	if [ i != 0 ] ; then
		i = i +1
	else
		i = 4
	fi
done

func1() { 
	cmd= echo $i | grep  "^1" | sed s/^1//
	$cmd
	 }

func2() { 
	cmd= echo $i | grep  "^2" | sed s/^2//
	$cmd
	 }
	 

func3() { 
	cmd= echo $i | grep  "^3" | sed s/^3//
	$cmd
	 }

func4() { 
	cmd= echo $i | grep  "^4" | sed s/^4//
	$cmd
	 }
	 
funct1 &
funct2 &
funct3 &
funct4 &
wait