for dir in ~/.local/share/nautilus/scripts/*; do
	[[ ":$PATH:" != *":$dir:"* ]] && PATH="$PATH:$dir"
done
