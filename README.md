# Pocket4D

`Pocket4D` is a `flutter-mini-program`(FMP) solution for mobile apps.

1. [Pocket4D](#pocket4d)
   1. [Introduction](#introduction)
   2. [Project Structure](#project-structure)
   3. [Enviorments && Tools](#enviorments--tools)
   4. [Build and run](#build-and-run)
      1. [Env Requirement:](#env-requirement)
      2. [Materials](#materials)
      3. [Steps](#steps)
   5. [Documents](#documents)
2. [Teams](#teams)

## Introduction


## Project Structure

1. `framework `-- a javascript framework that runs the FMP bundle
2. `pocket4d` -- main project entry
3. `pocket4d/android` -- kotlin/java code
4. `pocket4d/ios` -- swift/oc code
5. `pocket4d/lib` -- dart code
6. `pocket4d/clang` -- clang ffi code
7. `pocket4d/rust` -- rust ffi code
8. `pocket4d/example` -- example app that runs in android/ios simulator or real device
9. `pocket4d/test` -- test code

## Enviorments && Tools

1. please install `dart` and `flutter` sdk first.
2. use `fvm` to manage different flutter version: see [https://github.com/leoafarias/fvm](https://github.com/leoafarias/fvm)
3. if you find emulator of AndroidStudio is too slow, please use Mumu emulator.
   1. install: [http://mumu.163.com/](http://mumu.163.com/)
   2. usage:
    ```bash
    adb connect 127.0.0.1:5555
    ```
4. usd `flutter doctor -v` to see if your flutter enviorment is installed correctly


## Build and run
### Env Requirement:
* [✓] Flutter (Channel stable, 1.20.3)
* [✓] Dart version 2.9.2
* [✓] Android toolchain
* [✓] Xcode 11.7

### Materials
* [✓] Pocket4d-cli
* [✓] Pocket4d-server

### Steps
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
   
 


## Documents



# Teams
