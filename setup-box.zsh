SCRIPT_PATH=$(dirname $(readlink -f "$0"))
echo "Script is at $SCRIPT_PATH"
echo "Home is at $HOME"
set -x
echo "Setting up zsh"
ln -s -T "$SCRIPT_PATH/.zsh" "$HOME/.zsh"
ln -s -T "$SCRIPT_PATH/.zshrc" "$HOME/.zshrc"

echo "Removing bash garbage"
rm "$HOME/.bash*"

echo "Setting up scripts"
ln -s -T "$SCRIPT_PATH/scripts" "$HOME/scripts"


echo "Setting up vim"
ln -s -T "$SCRIPT_PATH/.vim" "$HOME/.vim"
ln -s -T "$SCRIPT_PATH/.vimrc" "$HOME/.vimrc"

echo "Setting up TMUX"
ln -s -T "$SCRIPT_PATH/.tmux.conf" "$HOME/.tmux.conf"

echo "Setting up Git"
ln -s -T "$SCRIPT_PATH/.gitconfig" "$HOME/.gitconfig"

echo "Setting up i3"
mkdir -p "$HOME/.config"
ln -s -T "$SCRIPT_PATH/.config/i3" "$HOME/.config/i3"
ln -s -T "$SCRIPT_PATH/.config/i3status" "$HOME/.config/i3status"

echo "Setting up terminator"
ln -s -T "$SCRIPT_PATH/.config/terminator" "$HOME/.config/terminator"

echo "Setting up dunst"
ln -s -T "$SCRIPT_PATH/.config/dunst" "$HOME/.config/dunst"

echo "Setting up misc"
ln -s -T "$SCRIPT_PATH/.hushlogin" "$HOME/.hushlogin"
ln -s -T "$SCRIPT_PATH/.selected_editor" "$HOME/.selected_editor"
ln -s -T "$SCRIPT_PATH/.config/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"
ln -s -T "$SCRIPT_PATH/.config/user-dirs.locale" "$HOME/.config/user-dirs.locale"
