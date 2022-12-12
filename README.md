# REST API - Vapor, MongoDB

## Requirements
- [Vapor](https://github.com/vapor/vapor)
- Xcode Command Line Tools OR Xcode
- [MongoDB](https://www.mongodb.com/home) (Local or Atlas / Realm)

## Recommended Tools
- [Watchexec](https://github.com/watchexec/watchexec)

## Instructions (MacOS)
1. Type the following command so that you can run the server from the command line - `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer `
2. With `watchexec` installed, run the following command - `./run.sh` (you may need to give the script permissions with `chmod`). This will automatically rebuild and run your server every time you make any changes
3. Alternatively, open the project in Xcode and press the "play" button every time you need to rebuild with new changes 

You're all set! Visit your server at `127.0.0.1:8080`.

### Generate Private Key for JWT Signing
In this repository, run the command `ssh-keygen -t rsa -b 4096 -m PEM -f secret.key` to generate a private key for the JWT signing algorithm
