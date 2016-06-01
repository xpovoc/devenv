# .bashrc
#
# Source global definitions
#
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#
# bash completion
#
#bash="4.3.30"%.*;
#bmajor=$bash%.*;
#bminor=$bash#*.;
#if [ "$PS1" ] && [ $bmajor -eq 2 ] && [ $bminor ’>’ 04 ] \
#&& [ -f /etc/bash_completion ] ; then # interactive shell
## Source completion code
. /etc/bash_completion
#fi
#unset bash bmajor bminor

#
# Alias
#
alias mv='mv -i'
alias minidoux='minicom'
alias grep='grep --color'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias rm='rm -i'
alias cp='cp -i'
alias azerty='setxkbmap fr'
alias ij='java -Xmx512m -jar /home/rgounelle/GoPro/soft/imageJ3/ij.jar' ## >> /dev/null'
alias ls='ls -CF --color=tty'
alias ll='ls -alF'
alias h='history'
alias gview='gview -c "color torte"'
alias gvim='gvim -geom 170x90'
alias gros='gvim -font "LucidaTypeWriter 32"'
alias beh='gvim ~/.bash_eternal_history'
alias tree='/home/rgounelle/BIN/tree'
alias togvim='gvim -R -'
#alias ssh='ssh -X'
alias gppm='ssh -X moon'
alias gitpull='git pull; git submodule sync --recursive; git submodule update --init --recursive'
alias gsms='git submodule sync --recursive; git submodule update --init --recursive'
alias rmake='./build/scripts/r make'
alias rshow='./build/scripts/r show -d'
alias lmake='./build/scripts/l make -l'
alias rclean='./build/scripts/r clean'
alias lclean='./build/scripts/l clean'
alias gitk='gitk --all &'
alias gst='git br; git st'
alias sourcebash='source ~/.bashrc'
alias meteomtp='curl -4 wttr.in/montpellier'
alias meteoprs='curl -4 wttr.in/paris'
alias syncDev='rsync -au --delete-after --info=progress2 /home/rgounelle rgounelle@moon05:/home/rgounelle/rgounelle.data'

#
# Export
#
export SVN_EDITOR=gvim
export PYTHON2_5=/soft/Python-2.5.1/bin/python2.5
export EDITOR=gvim
export HISTFILE=~/.bash_history
export HISTCONTROL=ignorespace:ignoredups
export HISTIGNORE=h:history
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%d/%m/%Y %H:%M:%S "
export TRACE_FILE='/dev/null'
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'.
export HISTSIZE=10000 #taille de l’historique
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo "$PWD $(history 1)" >> ~/.bash_eternal_history'
export PATH=/home/rgounelle/GoPro/pybin/pybin-20141226-1810-4a17794:$PATH
export PATH=/home/rgounelle/GoPro/toolchain/gcc-arm-none-eabi-4_7-2013q3/bin:$PATH
export LMAKE_ROOT_DIR=/home/rgounelle/GoPro/Bases/LMAKE
export LMAKE_DIR=/home/rgounelle/GoPro/Bases/LMAKE

#
# Functions
#

# convenient search fonctions for our bases (separation with products dir):
# find base inside - find files which names contains pattern
function fbi() {                                      
	find . \( -name "\.git" -o -name "\.svn" -o -name "%*" \) -prune -o -type f -print | xargs /bin/grep -i -s -n --color --binary-files=without-match $1 
}

function epfbi() {                                      
	find . \( -name "\.git" -o -name "\.svn" -o -name "banzai_link" -o -name "%*" \) -prune -o -type f -print | xargs /bin/grep -i -s -n --color --binary-files=without-match $1 
}

# find base - find files which names contains pattern
function fb() {                                       
	find . \( -name "\.git" -o -name "\.svn" -o -name "%*" \) -prune -o -type f -print |       /bin/grep -i -s    --color $1
}

# find base - mainly used for vif function
function fbx() {                                       
	find . \( -name "\.git" -o -name "\.svn" -o -name "%*" -o -name "products" \) -prune -o -type f -print |       /bin/grep -s -F --color $1
}

# quicker cleanup function (delete products dir in background process)
function myclean() {
	TMPDIR=$( mktemp -p ~/tmp -d productsTMP.XXXXXXXXXX )
	IMPDIR=$( mktemp -p ~/tmp -d imports_TMP.XXXXXXXXXX )
	mkdir -p products
	mkdir -p %STATE
	mv products $TMPDIR
	mv %STATE $TMPDIR
	chmod 777 -R $TMPDIR && rm -rf $TMPDIR &
	find . -type d -exec chmod u+w {} \; #fucking lmake2 rights managements !
    if [[ $1 == "-ki" ]]; then
        echo "keeping import directory to speed up first lmake"
        mv imports $IMPDIR
    fi
	if [ -e .svn ]; then
		svn-clean
	elif [ -e .git ]; then
		git clean -f -d -x
	else
		echo "error: don't know base type: git/svn"
	fi
    if [[ $1 == "-ki" ]]; then
        mv $IMPDIR/imports .
    fi
}

function myqstat(){
	s sge
	export SGE_LONG_QNAMES=1
	watch -n 1 qstat
}

function deps(){
	lshow -d $1 | grep -v fail
}

function kk() {
	echo "Multi Kill:" $1
	/bin/ps -C $1 -o pid= | xargs kill -15
}

function esp() {
	echo "Brutal Multi Kill:" $1
	/bin/ps -C $1 -o pid= | xargs kill -9
}

# recompress a tardir from imports to take modifications into account
function cleanTar (){
	find . -name "%MAKE" -prune -o -name "*.pyc"  -exec rm     {} \;
	find . -name "%MAKE" -prune -o -name ".*.swp"  -exec rm     {} \;
	find . -name "%MAKE" -prune -o -name ".*.swo"  -exec rm     {} \;
	find . -name "%STATE" -exec rm -rf {} \;
	find . -name "%MAKE"  -exec rm -rf {} \;
}

function reTar(){
	method="czf"
	ext="tgz"
	mode="auto"
	for i in $*; do
		if [[ $i == "bz" ]]; then
			method="cjf"
			ext="tbz"
			mode="forced"
		elif [[ $i == "gz" ]]; then
			method="czf"
			ext="tgz"
			mode="forced"
		fi
	done

	fileLst=""
	for i in $*; do
		if [[ $i != "" ]] && [[ $i != "bz" ]] && [[ $i != "gz" ]] && [[ $i != "tbz" ]] && [[ $i != "tgz" ]]; then
			filePath=$(dirname $i)
			fileName=$(basename $i)
			fileExt=${fileName##*.}
			fileName=${fileName%.*}
			tardir="$filePath/$fileName.tardir"


			if [[ $fileExt == "tbz" ]]; then
				if [[ -d "$tardir" ]];then
					echo "Deleting existing tardir: "$tardir
					rm -rf $tardir
				fi
				$(mkdir -p "$tardir")
				$(tar xjf $i -C "$tardir")
				chmod 755 -R $tardir/*
				if [[ $mode == "auto" ]]; then
					method="cjf"
					ext="tbz"
				fi
			elif [[ $fileExt == "tgz" ]]; then
				if [[ -d "$tardir" ]];then
					echo "Deleting existing tardir: "$tardir
					rm -rf $tardir
				fi
				$(mkdir -p "$tardir")
				$(tar xzf $i -C "$tardir")
				chmod 755 -R $tardir/*
				if [[ $mode == "auto" ]]; then
					method="czf"
					ext="tgz"
				fi
			elif [[ $fileExt == "tardir" ]] && [[ $mode == "auto" ]]; then
				if [[ -f "$filePath/$fileName.tbz" ]];then
					method="cjf"
					ext="tbz"
				fi

			fi
			fileLst="$fileLst $tardir"
		fi
	done

	for i in $fileLst; do
		if [[ $i != "" ]]; then
		fileName=$(basename $i)
		(
			cd $i
			cleanTar
			fileName=${fileName%.*}
			tar $method ../$fileName.$ext *
		)
		echo "$fileName.$ext remade with tar options $method"
		fi
	done
}

function hh () {
	if [ $# -gt 1 ]; then
		echo "error: usage: hh [word]" >&2
    else
        if [ "$1" == "" ]; then
            tail -1000 ~/.bash_eternal_history | uniq | tail -80
        else
            grep "$1" -a ~/.bash_eternal_history* | uniq | tail -80
        fi
    fi
}

# find base & open
function vif() {
    searchresult=$(fbx $1)
    n=$(echo $searchresult | wc -w)
    if [ "$n" != "1" ]
    then
        #echo "error: found $n files:" $searchresult
		fb $1
    else
        echo "opening $searchresult"
        gvim $searchresult
    fi
}

# Intall and save dpkg
function aptinstall() {
	sudo apt-get install $1
	if [ "$?" == "0" ]
	then
		if grep -Fxq "$1" ~/devenv/dpkgList.txt
		then
		    echo "devenv: pkg already in list"
		else
    		echo "$1" >> ~/devenv/dpkgList.txt
			echo "devenv: pkg added in list"
		fi
	fi
}

# Add tips
function addtips() {
	echo "$1 ### $2" >>  ~/devenv/useful/tuto/tiptools.txt
}

function tips () {
	if [ $# -gt 1 ]; then
		echo "error: usage: tips [word]" >&2
    else
        if [ "$1" == "" ]; then
            tail -1000 ~/devenv/useful/tuto/tiptools.txt | uniq | tail -40
        else
            grep "$1"  ~/devenv/useful/tuto/tiptools.txt | uniq | tail -40
        fi
    fi
}

#source ~/devenv/bash-git-prompt/gitprompt.sh
#GIT_PROMPT_ONLY_IN_REPO=1
