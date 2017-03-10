#!/bin/bash

# usage: infile outfile pinnumber
#set -e
#set -x

# Get the input file
input="$1"
# Get the output file
output="$2"
# Get the PIN (password in number)
pin="$3"

# Get a working temporary directory
tmp=`mktemp -d --tmpdir`
trap "rm -rf $tmp" EXIT
in="$tmp/in"
out="$tmp/out"

# By default, just output the input
cp -a "$input" "$out"

for i in `seq ${#pin} -1 0`; do
	# What method?
	method=${pin:$i:1}
	#echo $method
	# Process the previous output
	mv "$out" "$in"
	#file "$in"
	case "$method" in
		0)
			# Binary cloaked vaulting
			#
			# We create an .a archive with the input file named 'secret'
			# Take care that there is no metadata leak

			cd "$tmp"
			ar x in secret > /dev/null
			cd - > /dev/null
			mv "$tmp"/secret "$out"
			;;
		1)
			# Mystifying mathematical encryption
			#
			# We convert it into base64, nobody will guess it.
			#bug: openssl --baze64 "$in" "$out"
			base64 -d "$in" > "$out";;
		2)
			# Impenetrable covered concealment
			#
			# We uuencode with the input file named 'secret'
			# bug: mv "$in" secret; uuencode < "$in" > "$out"
			uudecode -o "$out" "$in";;
		3)
			# Diabolically unbreakable cypher
			#
			# A classic rot13
			# bug: tr s/[a-ZA-Z]/[N-ZA-Mn-za-m]/ "$in" "$out"
			tr A-Za-z N-ZA-Mn-za-m < "$in" > "$out";;
		4)
			# Futuristic low-level compression 
			#
			# We create a .Z compressed file (Lempel-Ziv coding)
			# bug (bad command): Zip "$in" "$out"
			uncompress.real -c < "$in" > "$out" || true;;
		5)
			# Literal secret hiding
			#
			# Data are enclosed in a plain "FLAG{}" (inside the brackets)
			#
			# bugs: > au lieu de >>
			tail -c+6 "$in" | head -c-1 > "$out";;
		6)
			# Invisible meta-information stenography
			#
			# We enclose the file into a exif tag of an innocent jpeg image.
			exiftool -a -b -comment "$in" | base64 -d > "$out";;
		7)
			# Intricate colorful smuggling
			#
			# This one is da bomb. We take the data and include it into a special ad-hoc
			# chunk of an innocent png image.
			# The trick is to have to correct metadata so the png is still valid.
			pngcheck -q "$in"
			rm "$in.0"* 2>/dev/null || true
			pngsplit --force --quiet "$in" > /dev/null
			tail -c+9 "$in.0005.ssSs" | head -c-4 > "$out"
			;;
		8)
			# Shuffle internal binary encoding
			#
			# We just invert each pair of byte
			#bug: dd --input "$in" --output "$out" --special swap-bytes
			dd conv=swab if="$in" of="$out" status=none
			;;
		9)
			# Unexpected international transliteration
			#
			# Here we assume the input is a plain Kod Obmena Informatsiey Ukranian (8 bit) file and we convert is to unicode UTF-16 little endian.
			# bug: TODO, maybe iconv. I'm not sure
			iconv -t KOI8U -f UTF-16LE < "$in" > "$out"
			;;
		*)
			# Do nothing
			cp "$in" "$out"
			;;
	esac
done

mv "$out" "$output"
rm -rf "$tmp" 2> /dev/null || true
