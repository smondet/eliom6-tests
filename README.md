Eliom Mobile Tests
==================


With packages `libmagickcore-dev`
(and maybe `libgraphicsmagick1-dev`)

    opam install ocsigen-start
    eliom-distillery -name zero -template os.pgocaml

To make the test work, get `sass`, and:

    docker run --name ocsi-postgres -p 5432:5432 \
        -e POSTGRES_PASSWORD=kpass -d postgres

`Makefile.options`:

```make
## The host database.
DB_HOST               := 127.0.0.1
## The port of the database server
DB_PORT               := 5432
## The database name for the project. By default, it's better if it is
## the project name (zero.sql already there).
DB_NAME               := zero
## The database user. By default, it will use the username of the current user.
DB_USER               := postgres
## The password to access the database. By default it's empty.
DB_PASSWORD           := kpass
```

all worked fine (without the `make db-init`):

```
make db-create
make db-schema
make test.byte
make test.opt
```

### NPM Madness

Useful with NPM:

```
npm config set color false
```

I read that
`sudo npm install -g npm` could solve the installations problems
it actually broke Ubuntu's `npm`:

```
 # npm install -g cordova
/usr/bin/env: ‘node’: No such file or directory
```

```
apt remove npm
apt autoremove # kick also all the dependencies out
```

didn't do it

tried also
[this](http://stackoverflow.com/questions/26320901/cannot-install-nodejs-usr-bin-env-node-no-such-file-or-directory#26320915)

```
ln -s /usr/bin/nodejs /usr/bin/node
```

`npm` on Ubuntu: disaster

```
docker pull node
docker run -it node bash
npm install -g cordova
```

It's better
cf. <https://hub.docker.com/r/library/node/>
but an old version of Debian
⇒
JRE version
[mismatch](http://stackoverflow.com/questions/10382929/how-to-fix-java-lang-unsupportedclassversionerror-unsupported-major-minor-versi).

### Andriod SDK

knowing how a package is called is actually
[not](https://code.google.com/p/android/issues/detail?id=229373)
that
simple:

```
 $  tools/bin/sdkmanager --list | grep 'Intel x86 Atom_64'
  system-images;a...;default;x86_64 | 9       | Intel x86 Atom_64 System Image    | system-images/a...default/x86_64/
  system-images;a...;default;x86_64 | 4            | Intel x86 Atom_64 System Image   
  system-images;a...gle_apis;x86_64 | 18           | Google APIs Intel x86 Atom_64 ...
  system-images;a...;default;x86_64 | 5            | Intel x86 Atom_64 System Image   
  system-images;a...gle_apis;x86_64 | 12           | Google APIs Intel x86 Atom_64 ...
  system-images;a...;default;x86_64 | 9            | Intel x86 Atom_64 System Image   
  system-images;a...gle_apis;x86_64 | 19           | Google APIs Intel x86 Atom_64 ...
  system-images;a...;default;x86_64 | 7            | Intel x86 Atom_64 System Image   
  system-images;a...gle_apis;x86_64 | 10           | Google APIs Intel x86 Atom_64 ...
  system-images;a...gle_apis;x86_64 | 3            | Google APIs Intel x86 Atom_64 ...
```

So,

* install from the GUI,
* notice that it created
  `system-images/android-23/default/x86_64`,
* guess package name (from truncated name `system-images...default;x86_64`):
 `system-images;android-23;default;x86_64`

should be Emulator-ready:

```
apt-get install -y qemu-kvm
sdkmanager 'system-images;android-23;default;x86_64'
```

