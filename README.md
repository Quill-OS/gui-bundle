To create a bundle:

1. launch `download.sh`

2. crosscompile things in build ( If you are using qtcreator, disable shadow builds )

3. Execute: `sudo GITDIR=${PWD} ./release.sh private.pem your_bundle`
Where `private.pem is your developer private key
