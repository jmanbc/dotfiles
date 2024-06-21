#! /usr/bin/env sh
# this is a example of .lessfilter, you can change it
mime=$(file -bL --mime-type "$1")
category=${mime%%/*}
kind=${mime##*/}

dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}
if [[ $dim = x ]]; then
  dim=$(stty size < /dev/tty | awk '{print $2 "x" $1}')
elif ! [[ $KITTY_WINDOW_ID ]] && (( FZF_PREVIEW_TOP + FZF_PREVIEW_LINES == $(stty size < /dev/tty | awk '{print $1}') )); then
  dim=${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))
fi

if [ -d "$1" ]; then
	eza --git -hl --color=always --icons "$1"

elif [ "$category" = image ]; then
  if [[ $KITTY_WINDOW_ID ]]; then
  kitty icat --clear --transfer-mode=memory --unicode-placeholder --stdin=no --place="$dim@0x0" "$1" | sed '$d' | sed $'$s/$/\e[m/'
fi
if command -v exiftool > /dev/null; then
  exiftool "$1" | bat --color=always -plyaml
fi

elif [ "$category" = text ]; then
	bat --color=always "$1"

elif [ "$kind" = pdf ]; then
		pdftoppm -f 1 -l 1 -scale-to-x 1920 -scale-to-y -1 -jpeg -tiffcompression jpeg -singlefile "$1" cache && mv cache.jpg ~/.cache/ && kitty icat --clear --transfer-mode=memory --unicode-placeholder --stdin=no --place="$dim@0x0" ~/.cache/cache.jpg | sed '$d' | sed $'$s/$/\e[m/'

elif [ "$category" = video ]; then
  ffmpegthumbnailer -i "$1" -s 1024 -o ~/.cache/cache.jpg > /dev/null 2>&1 && kitty icat --clear --transfer-mode=memory --unicode-placeholder --stdin=no --place="$dim@0x0" ~/.cache/cache.jpg | sed '$d' | sed $'$s/$/\e[m/'

else
	lesspipe.sh "$1" | bat --color=always
fi
