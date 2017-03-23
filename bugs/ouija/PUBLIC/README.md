# Ouija@home

Ghosts, spirits, dead people. They are with us.

This application uses the latest breakthroughs in holistic cryptography to decipher messages that out-of-this-world beloved phantoms tries to communicate to us.

By default, the application tries to extract meaningful messages from `/dev/urandom` as it is nowadays the most efficient channel that spirits use to communicate with simple mortals.

If a media file that features a recently deceased person is given (photography, audio, video, animated gif) the software tries to gather remnant aura and transcript them into a meaning full message. Results may vary.

Disclaimer: the user need to be open minded and must truly believe in esoteric powers ; the software is only a tool that channel mystic energy and is not functional if bad energy is present. A nonbeliever is not expected to see any meaningful messages from the afterlife.

For a more efficient use, it is suggested to pipe the application in the command `strings(1)` to filter out spiritic noise.

## Examples

Without argument, it extracts meaningful messages from the afterlife trough `/dev/urandom`.

    $ bin/ouija | strings

Output:

~~~
tQ^/
!u:Xs
dl5Ns
dl5NsD
!n5Ts
Emily: hello!
4n1S
%u^q^&
Emily: hello!
%j;T
1u I
Emily: let's hit up!
1u I
1<'R
!i,70"
*<9X
!<'R
dn;H
Emily: y r u doing this?!?
(otM
0ytM
0ytM
7<$Q
(y&73+
Emily: y r u doing this?!?
!n^y
0y&7:&
Emily: y r u doing this?!?
Emily: y r u doing this?!?
-<0X
)~&XY*
!r^P
~~~

It is suggested to start the ouija application automatically. Just put the following line in your `/etc/rc.local` file and regularly check the `/var/log/ouija.log` file.

~~~
nice /path/to/ouija | strings -n 8 >> /var/log/ouija.log
~~~

With a media file of a recent decease person as argument, mystic aura is extracted (if any)

    $ bin/ouija emily_girlfriend.jpeg |  strings

~~~
/^:JS
%IY>
Ij)&C0
O"Cm
/:G'
@+7{C@
?OANT
E./<
+w\T
n9IA
+H*?
8\V:
 '8q
Jik#
I HATE YOU!
meOK
<{t[
L$]ZB9X*'v<
!go]
wCE 
I WILL KILL YOU!
)[Pr1
>Tau
99I[
'wNs
i*@m<
2P2j
x%km
YnG*
qIM;
\yU3U
PLEASE DIE!
7`)*
v$m`
mr_XG\
JrGNE
2qGf[Q
y1T{z
V}!=CP
YtuN
k+Q*
:qZ3VDG
@ES5$X,]
~~~
