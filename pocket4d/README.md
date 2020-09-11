# pocket4d

## Env Requirement:
* [✓] Flutter (Channel stable, 1.20.3)
* [✓] Dart version 2.9.2
* [✓] Android toolchain
* [✓] Xcode 11.7

## Materials
* [✓] Pocket4d-cli
* [✓] Pocket4d-server

## Quick Start
1. Build and Run `Pocket4d-server`
    * git clone
    ```bash
        git clone https://github.com/FireStack-Lab/pocket4D-server 
    ```
    * create a folder name `bundled`, build and run the `./pocket4d-server`
    
    
    ```bash
    cd pocket4d-server && mkdir bundled && sh ./build.sh && ./pocket4d-server
    ```
    --- 

2. Edit `html` `css` and build with `Pocket4d-cli`
    * git clone `pocket4d-cli`
        ```bash
           git clone https://github.com/FireStack-Lab/Pocket4D-cli 
        ```
    * open `src` folder start edit `*.html`,`*.css` and `*.config`, remember to edit `app.config`, with pages config
    * build bundle json
        ```bash
        yarn build
        ```
     * goto `pocket4d-cli/dist`, and upload the json, for example
        ```bash
        curl -F bundled=@app.json localhost:3001/api/v1/bundled/app
        ```
    --- 
3.  go to `pocket4d/pocket4d/example`, and run
    ```bash
    flutter run
    ```
   
 
