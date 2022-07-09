
DEST="Screenshots.md"

echo "# Screenshots" > $DEST

for i in $(find -name "*_*" -type d) ; do
	i=$(basename $i)
	pushd $i
	echo "## $i" >> ../$DEST
	head -3 *.v >> ../$DEST
	echo "![$i](screenshots/${i}.png" >> ../$DEST
	./$i &
	FOO_PID=$!
	maim -d 5.0 ../screenshots/${i}.png
	kill $FOO_PID
	echo "---" >> ../$DEST
	popd
done
