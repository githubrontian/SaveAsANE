#!/bin/sh

#Get the path to the script and trim to get the directory.
echo "Setting path to current directory to:"
pathtome=$0
pathtome="${pathtome%/*}"
echo $pathtome

PROJECT_NAME=SaveAsANE

AIR_SDK="/Applications/Adobe Flash Builder 4.7/sdks/4.6.0"
echo $AIR_SDK

#Setup the directory.
echo "Making directories."

if [ ! -d "$pathtome/platforms" ]; then
mkdir "$pathtome/platforms"
fi


if [ ! -d "$pathtome/platforms/mac" ]; then
mkdir "$pathtome/platforms/mac"
mkdir "$pathtome/platforms/mac/release"
mkdir "$pathtome/platforms/mac/debug"
fi

if [ ! -d "$pathtome/platforms/win" ]; then
mkdir "$pathtome/platforms/win"
mkdir "$pathtome/platforms/win/release"
mkdir "$pathtome/platforms/win/debug"
fi




#Copy SWC into place.
echo "Copying SWC into place."
cp "$pathtome/../bin/$PROJECT_NAME.swc" "$pathtome/"

#Extract contents of SWC.
echo "Extracting files form SWC."
unzip "$pathtome/$PROJECT_NAME.swc" "library.swf" -d "$pathtome"

#Copy library.swf to folders.
echo "Copying library.swf into place."
cp "$pathtome/library.swf" "$pathtome/platforms/mac/release"
cp "$pathtome/library.swf" "$pathtome/platforms/mac/debug"
cp "$pathtome/library.swf" "$pathtome/platforms/win/release"
cp "$pathtome/library.swf" "$pathtome/platforms/win/debug"

#Copy native libraries into place.
echo "Copying native libraries into place."
cp -R -L "$pathtome/../../native_library/mac/$PROJECT_NAME/Build/Products/Release/$PROJECT_NAME.framework" "$pathtome/platforms/mac/release"
cp -R -L "$pathtome/../../native_library/mac/$PROJECT_NAME/Build/Products/Debug/$PROJECT_NAME.framework" "$pathtome/platforms/mac/debug"

if [ -d "$pathtome/../../native_library/win/$PROJECT_NAME/Release" ]; then
cp -R -L "$pathtome/../../native_library/win/$PROJECT_NAME/Release/$PROJECT_NAME.dll" "$pathtome/platforms/win/release"
cp -R -L "$pathtome/../../native_library/win/$PROJECT_NAME/Release/$PROJECT_NAME.dll" "$pathtome/platforms/win/debug"
fi

#Run the build command.
echo "Building Release."
"$AIR_SDK"/bin/adt -package \
-target ane "$pathtome/$PROJECT_NAME.ane" "$pathtome/extension_multi.xml" \
-swc "$pathtome/$PROJECT_NAME.swc" \
-platform MacOS-x86-64 -C "$pathtome/platforms/mac/release" "$PROJECT_NAME.framework" "library.swf" \
-platform Windows-x86 -C "$pathtome/platforms/win/release" "$PROJECT_NAME.dll" "library.swf"

echo "Building Debug."
"$AIR_SDK"/bin/adt -package \
-target ane "$pathtome/$PROJECT_NAME-debug.ane" "$pathtome/extension_multi.xml" \
-swc "$pathtome/$PROJECT_NAME.swc" \
-platform MacOS-x86-64 -C "$pathtome/platforms/mac/debug" "$PROJECT_NAME.framework" "library.swf" \
-platform Windows-x86 -C "$pathtome/platforms/win/debug" "$PROJECT_NAME.dll" "library.swf"

if [[ -d "$pathtome/debug" ]]
then
rm -r "$pathtome/debug"
fi
z

mkdir "$pathtome/debug"
unzip "$pathtome/$PROJECT_NAME-debug.ane" -d  "$pathtome/debug/$PROJECT_NAME.ane/"

#rm -r "$pathtome/platforms"
rm "$pathtome/$PROJECT_NAME.swc"
rm "$pathtome/library.swf"
rm "$pathtome/$PROJECT_NAME-debug.ane"
