# Termux packages for pacman - official support
[More about the repository](https://github.com/termux/termux-packages/blob/master/README.md)

### Code for connecting repository:
main:
<!--```
[main]
Server = https://service.termux-pacman.dev/main/$arch
```-->
```
[main]
Server = https://s3.amazonaws.com/termux-pacman.us/main/$arch
```
x11:
<!--```
[x11]
Server = https://service.termux-pacman.dev/x11/$arch
```-->
```
[x11]
Server = https://s3.amazonaws.com/termux-pacman.us/x11/$arch
```
root:
<!--```
[rott]
Server = https://service.termux-pacman.dev/root/$arch
```-->
```
[root]
Server = https://s3.amazonaws.com/termux-pacman.us/root/$arch
```

### Other information:
 - Android support: 7+
 - Architecture support: all (aarch64, arm, x86_64, i686)
 - Security level: not complete (db and only a few packages are protected by signature)
 - Signature: termux-pacman organization gpg key
 - Storage: aws s3 (US)
 - Mirrors: does not exist
 - Root repository: https://github.com/termux/termux-packages
 - Organization maintaining the root repository: [termux](https://github.com/termux)
