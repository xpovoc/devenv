echo "bashrc exists ?"
if [ -f ~/.bashrc ]; then
	echo "moving to bashrc_old"
	sudo mv ~/.bashrc ~/.bashrc_old
fi
echo "vimrc exists ?"
if [ -f ~/.vimrc ]; then
	echo "moving to vimrc_oldf"
	sudo mv ~/.vimrc ~/.vimrc_old
fi
