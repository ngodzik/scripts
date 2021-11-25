#!/bin/zsh

SCRIPT_NAME=$(basename "$0")
OPTION=$1

WORKPATH=.

if [[ "$OPTION" == "update" ]]; then
  if [[ "$2" != "" ]]; then
    WORKPATH=$2
  fi
  echo "updating all repositories"

else

  echo "$SCRIPT_NAME help:"
  echo
  echo "update all the registered git repositories in the provided path, default path is ."
  echo "./$SCRIPT_NAME update [path]"
  exit 0
fi

pushd ${WORKPATH}
FOLDERS_LIST=($(ls -1d */))
popd

for FOLDER in ${FOLDERS_LIST}; do
  FOLDER_PATH=$WORKPATH/$FOLDER

  pushd ${FOLDER_PATH}
  git checkout master 2> /dev/null
	[ $? != 0 ] && popd && continue

	echo
  echo "-------------------------------------------------------"
  echo
  echo "repository" $FOLDER
  echo $FOLDER_PATH

  git pull --ff-only
  # force update git tags that could have been remotely overwritten
  git fetch -f --tags
  popd
done
