#!/usr/bin/env zsh
setopt null_glob

mkdir -p temp

echo "Removing old files..."
rm -v ../*.html
rm -v temp/*.temp

echo "Compiling links..."
echo "<span class=\"toc\">" >> temp/links.temp
for infile in sources/[^_]*.md; do
    infile=$(basename $infile)
    file=${infile%.*}
    outfile=${file}.html
    echo "<a href=\"./${outfile}\" class=\"toc_entry\">${file}</a>&nbsp;&nbsp;&nbsp;&nbsp;" >> temp/links.temp
done
echo "</span>" >> temp/links.temp

cat t0.html temp/links.temp t1.html > temp/template.temp

echo "Generating outputs..."
for infile in sources/*.md*; do
    infile=$(basename $infile)
    file=${infile%.*}
    outfile=${file#_}.html
    pandoc -o ../$outfile sources/$infile --standalone --standalone --mathml --template temp/template.temp --metadata pagetitle=${file#_} -c resources/styles.css
done

echo "Copying resources..."
cp -r sources/resources ..

echo "Make complete!"
