set -e

originalPath=~/code/invoice-harness/
package=invoice-harness
version=0.1.0

rm -rf ~/.local/share/typst/packages/local/$package/$version
mkdir -p ~/.local/share/typst/packages/local/$package/$version
ln -s $originalPath* ~/.local/share/typst/packages/local/$package/$version

echo "Linked @local/$package:$version"
