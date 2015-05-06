# Exit the script if any command returns a non-true return value (http://www.davidpashley.com/articles/writing-robust-shell-scripts/)
set -e
# Print commands and their arguments as they are executed, so you see what's happening.
set -x

## Must use absolute instead of relative path here
# Not needed within Docker VM, as we've already globally set these (@see Dockerfile)
# export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
# export TAFJ_HOME=$MB_HOME/TAFJ
# export PATH=$TAFJ_HOME/bin:$PATH

export T24_HOME=$T24MB_HOME/h2/UD
export PACKAGE=$T24_HOME/package
export DS_PACKAGE_UPDATES=$T24_HOME/DSPackageUpdates
rm -rf $PACKAGE; mkdir $PACKAGE
rm -rf $DS_PACKAGE_UPDATES; mkdir $DS_PACKAGE_UPDATES

if [[ $# -ne 1 ]]; then
	echo "Missing argument"
	exit 1
fi
echo $1 copying to $PACKAGE
cp $1 $PACKAGE

tRun -cf tafj T24PackageInstaller
# TODO Need to run this several times?? How many? (Required for some use cases.. find details, and test)
tRun -cf tafj packageDataInstaller
