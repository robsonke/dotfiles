#!/bin/bash
#
# Simple Bash script to fix a merge conflict with either mine or yours as option
#
# @author R. Sonke
#
bold=$(tput bold)
normal=$(tput sgr0)

doTheMerge () {
  local fromBranch=${1}
  local toBranch=${2}
  local mergeOption=${3}

  local random=$(shuf -i 10000-99999 -n 1)
  local fixBranchName="fix-conflict-${fromBranch}-to-${toBranch}-${random}"
  fixBranchName="${fixBranchName// /-}"

  echo "A branch with the name ${bold}${fixBranchName}${normal} will be created and pushed to PR."
  echo

  git reset --hard
  git fetch

  # update the local source branch
  git checkout ${fromBranch}
  git reset --hard origin/${fromBranch}
  git fetch
  git pull

  # update branch we merge to
  git checkout ${toBranch}
  git reset --hard origin/${toBranch}
  git fetch
  git pull

  # create new branch based on mergeFrom branch.
  git branch ${fixBranchName}

  # switch to new branch
  git checkout ${fixBranchName}

  # merge toBranch into our fixBranch
  mergeResult=$(git merge -X${mergeOption} ${fromBranch})

  echo "The result of our merge:"
  echo $mergeResult

  # push changes to origin
  git push -u origin ${fixBranchName}
}

read -p "What is the source branch of your conflict? [master]: " fromBranch
read -p "What is the target branch of your conflict? [develop]: " toBranch

echo "What is the truth? Ours = target, theirs = source"
select mergeOption in ours theirs
do
  if [ "$mergeOption" = "ours" ] || [ "$mergeOption" = "theirs" ];
  then
    break
  else
    echo "Choose 1 or 2"
  fi
done

fromBranch=${fromBranch:-"master"}
toBranch=${toBranch:-"develop"}

echo "We will fix the conflict from ${bold}${fromBranch}${normal} to ${bold}${toBranch}${normal} using ${bold}${mergeOption}${normal}."

doTheMerge $fromBranch $toBranch $mergeOption
# Note: this url is pretty specific
open "https://bitbucket.maxxton.com/projects/$(git project-name)/repos/$(git repository-name)/pull-requests?create&sourceBranch=refs/heads/$(git branch-name)&targetBranch=refs%2Fheads%2F${toBranch}"

echo
echo "------------"
echo "${bold}Done!${normal}"
