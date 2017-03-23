#!/bin/bash

#                 UQAM ON STRIKE PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2017
# Alexandre Terrasa <@>,
# Jean Privat <@>,
# Philippe Pepos Petitclerc <@>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#                 UQAM ON STRIKE PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just do what the fuck you want to as long as you're on strike.
#
# aHR0cDovL2NzZ2FtZXMub3JnLzIwMTYvCg==

# usage: infile pinnumber outfile
set -e
#set -x

## TOP SECRET. IF YOU ARE NOT AUTHORIZED TO READ BELLOW.
# Or do whatever you want, I'm only a comment.

# Get the input file
input="$1"
# Get the PIN (password in number)
pin="$2"
# Get the output file
output="$3"

# Get a working temporary directory
tmp=`mktemp -d --tmpdir`
trap "rm -rf $tmp" EXIT
in="$tmp/in"
out="$tmp/out"

# By default, just output the input
cp -a "$input" "$out"

for i in `seq 0 ${#pin}`; do
	# What method?
	method=${pin:$i:1}
	# Process the previous output
	mv "$out" "$in"
	case "$method" in
		0)
			# Binary cloaked vaulting
			#
			# We create an .a archive with the input file named 'secret'
			# Take care that there is no metadata leak
			mv "$in" "$tmp"/secret
			cd "$tmp"
			ar out < secret
			cd - > /dev/null
			;;
		1)
			# Mystifying mathematical encryption
			#
			# We convert it into base64, nobody will guess it.
			openssl --baze64 "$in" "$out"
			;;
		2)
			# Impenetrable covered concealment
			#
			# We uuencode with the input file named 'secret'
			mv "$in" "$tmp/secret"
			uuencode < "$tmp/secret" > "$out"
			;;
		3)
			# Diabolically unbreakable cypher
			#
			# A classic rot13
			tr s/[a-ZA-Z]/[N-ZA-Mn-za-m]/ "$in" "$out"
			;;
		4)
			# Futuristic low-level compression
			#
			# We create a .Z compressed file (Lempel-Ziv coding)
			Zip "$in" "$out"
			;;
		5)
			# Literal secret hiding
			#
			# Data are enclosed in a plain "FLAG{}" (inside the brackets)
			echo -n "FLAG{" > "$out"
			cat "$in" > "$out"
			echo -n "}" > "$out"
			;;
		6)
			# Invisible meta-information stenography
			#
			# We enclose the file into a exif tag of an innocent jpeg image.
			base64 -id > "$out" <<'CEIL'
			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
			FllVf//Z
CEIL
			# To avoid issue, use the comment tag and encode data in base64
			base64 "$in" | exiftool --tag=comment "$out"
			;;
		7)
			# Intricate colorful smuggling
			#
			# This one is da bomb. We take the data and include it into a special ad-hoc
			# chunk of an innocent png image.
			# The trick is to have to correct metadata so the png is still valid.
			base64 -id > "$out" <<'NIAN'
			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

			                \`*-.
			                 )  _`-.
			                 .  : `. .
			                 : _   '  \
			                 ; *` _.   `*-._
			                 `-.-'          `-.
			                   ;       `       `.
			                   :.       .        \
			                   . \  .   :   .-'   .
		                           '  `+.;  ;  '      :
			                   :  ;  |    ;       ;-.
		                           ; ;   : :`-:     _.`* ;
			                .*' ,  .*' ; .*`- +'  `*'
				        `*-*   `*-*  `*-*'

			G8Ro9I7QNCx0qwtVI
			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
			n+frX/86AO9/

			\    /\
		         )  ( ')
			(  /  )
		         \(__)|

			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
			qNDaiAERhNYmjUZkLbImdam4sARBaCU06dFbTxCu3jtJ535Uw0nLFyEIQjLSFvWUobHRYbPAi4R7
			d7F6yM8jA/xl+acnwflpb4+8aogBEYTWxQE6YhxvgVGS71G4wHOEPeiruc4UMAmcSzh+FEaBf72C
			402u4FhrDjEggtC6XAG+QBg6W8soaOAi8DyhIUmyd+ICf4coXaGMGBChXViLm5hngN9othDC2kUM
			iKCIr3zjJBJeBmZINuPVhO6Sl1n+Wc0BRxOMLwhCHYgBWX1WK+zSEiYtLrehWZElbjr7I4Rlx5fL
			H1Hl3/+IMNktycaqAoaBZxOcKwhCgxEDkk7ywMOEm5FJFe9FQuWdYelIHVX+idtH408TyCQIgiAI
			giAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAI
			giAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAIgiAI
			aw+n2QIIQhO5CQiAfLMFEYRWRDdbAGFNMgAcLv+3Hn6tzvNvBjbUOYYgrFnEgAjNYDvwXmBbneNc
			qvP8/wa8XucYgiAIwiqSATaW/ysIgiAIgiAIgiAIgiAIgiAIjeD/BzMp18DHOo55
NIAN
			# Our chunk here
			# 1. the size (4 bytes, big endian)
			printf "%08x" `stat --printf="%s" "$in"` >> "$out"
			# 2. the tag (proprietary)
			printf "ssSs" > "$out.2"
			# 3. the data (as is)
			cat "$in" >> "$out.2"
			cat "$out.2" >> "$out"
			# 4. the checksum32 of tag+data (4 bytes, big endian)
			crc32 "$out.2" >> "$out"
			# Now the rest of the png file
			echo AAAAAElFTkSuQmCC | base64 -id >> "$out"
			;;
		8)
			# Shuffle internal binary encoding
			#
			# We just invert each pair of byte
			dd --quiet --input "$in" --output "$out" --special swap-bytes
			;;
		9)
			# Unexpected international transliteration
			#
			# Here we assume the input is a plain Kod Obmena Informatsiey Ukranian (8 bit) file and we convert is to unicode UTF-16 little endian.
			# TODO, maybe iconv. I'm not sure
			;;
		*)
			# Do nothing
			cp "$in" "$out"
			;;
	esac
done

# Finally, get the result and clean the tmp directory
mv "$out" "$output"
rm -rf "$tmp" 2> /dev/null || true
