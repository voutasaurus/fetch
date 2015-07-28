$fileroot = "./"
add-type -AssemblyName System.Drawing

# Teefury
$teefuryPageContent = curl www.teefury.com
$teefuryPrefix = "http://www.teefury.com/media/catalog/product/*"

if (Test-Path ($fileroot + "teefury")) {
    rm -Recurse ($fileroot + "teefury")
}
mkdir ($fileroot + "teefury")
$teefuryPageContent.Images.src | ForEach-Object { 
  if ($_ -like $teefuryPrefix) {
    $outfile = $fileroot + "teefury\" + (Split-Path $_ -Leaf)
    curl $_ -OutFile $outfile
    im-convert.exe $outfile -background black -alpha remove ($outfile + "black.png")
  }
}

# Ript Apparel
$riptPageContent = curl www.riptapparel.com -OutFile ript.html
Function url($str) { return (($str.Split(':').length -eq 2) -and ($str -like "http*")) }
$designs = (cat ript.html | grep "img src" | grep "designs").Split('"') | Where-Object {url($_)}
rm ript.html

if (Test-Path ($fileroot + "ript")) {
    rm -Recurse ($fileroot + "ript")
}
mkdir ($fileroot + "ript")
$designs | ForEach-Object {
    $outfile = $fileroot + "ript\" + (Split-Path $_ -Leaf)
    curl $_ -OutFile $outfile
}
