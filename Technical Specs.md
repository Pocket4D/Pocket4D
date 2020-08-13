# Technical Specs of Pocket 4D

1. [Technical Specs of Pocket 4D](#technical-specs-of-pocket-4d)
   1. [Poc-1](#poc-1)
      1. [Core Engine](#core-engine)
      2. [Framework && Complier](#framework--complier)
      3. [Test Server](#test-server)
      4. [Demo](#demo)
   2. [Poc-2](#poc-2)
      1. [Core Engine](#core-engine-1)
      2. [Framework && Complier](#framework--complier-1)
      3. [Blockchain](#blockchain)
      4. [Demo](#demo-1)
   3. [Poc-3 (TBD)](#poc-3-tbd)
      1. [Core Engine](#core-engine-2)
      2. [Dev Tools](#dev-tools)
      3. [Blockchain BetaNet](#blockchain-betanet)
      4. [Demo](#demo-2)
   4. [Poc-4 (TBD)](#poc-4-tbd)
      1. [`Flutter` Packages](#flutter-packages)
      2. [Dev Tools](#dev-tools-1)
      3. [Blockchain TestNet](#blockchain-testnet)
      4. [Web Portal](#web-portal)
      5. [Demo](#demo-3)

---

## Poc-1

### Core Engine
* Quickjs/JSCore implementation with `Flutter`'s MethodChannel
  1. Use Quickjs instead of V8 (Android)
  2. Use JSCore (iOS)
* Dart apis for Javascript's global
  1. `__native_eval` for eval script
  2. `__native_refresh` for handling refresh
  3. `Page`, `Component`, `config.json`
* `Flutter` widgets mapping for standard components for `mini-programs`
  1. Basic components:`Text`, `Image`, `View`,`Button`
  2. High-level components : `SingleChildScrollView`, 
  3. Basic css styles.
  4. Higher level css style mapping, eg. `Flex`
* Bundle downloader for http test server
  1. Basic downloader using Flutter plugin.
  2. Local storage and manager on Android/iOS
### Framework && Complier
* A DSL standard (Vue-like) for `mini-programs`
  1. Vue-like and similar to Wechat's definition, eg. `Page`, `App` and markups
  2. Higher level syntax like `for:`, `if:`.
* Observer of framework for javascript
  1. Observer classes for data binding and function calls
  2. setData implementation
* Complier cli
  1. A basic cli compile markup pages and javascript to json.
  2. A basic template file like `pages.tpl` for new project initialization.
### Test Server
* A test server with simple file storage
  1. Simple restful http server for demostrating functionalities.
  2. Simple file storage for `mini-programs` bundles.
* A http api for Flutter downloader
  1. Simple api for flutter downloader to request(use Static APP ID)
  2. Simple api for cli to upload bundles.
  3. File list api by id
### Demo
* A "TODO MVC" mini-program bundled to server
* A "Reddit" mini-program bundled to server
* A demo android app with a simple entry page for `mini-programs`

---

## Poc-2

### Core Engine
* Quickjs implementation using Dart FFI
  1. use Dart FFI instead of methodChannel.
  2. a refactor of javascript engine
* Dart apis refactoring
  1. sync and async calls implementation, to fully control the javascript engine.
  2. new apis implemented for latest features.
* `Flutter` widgets updates
  1. A lower level common widget for javascript (`js.createWidget`)
  2. More higher level widgets for javascript.
* `IPFS` client implementation for dart
  1. A `IPFS` client written in Dart or Rust.
  2. If written in Dart, call it directly.
  3. If written in Rust, use Dart FFI.
* Bundle downloader for `IPFS` endpoint
  1. Decided by feature above
* Crypto packages using Dart FFI for Rust
  1. Basic crypto packages written in Rust.
  2. Use Dart FFI to communicate with Rust.
* Provides crypto methods(Web3) to javascript global
  1. Basic Web3 object for javascript, use Eth or Polkadot's definition.
  2. RPC or http endpoint for Eth or Polkadot
* Provides network object for javascript global
  1. Use secure network functions in Dart.
  2. Provide network tools like `js.request` for security.
* Experimentally Embedding `WalletConnect`
  1. Embedding `WalletConnect` to plugin level.
  2. Use Native navigator and deeplink to connect `mini-program` and `WalletConnect`.
  3. Try sign with some wallet-app that use `WalletConnect`
  
### Framework && Complier
* Compatible DSL of `mini-programs` according to [`W3C` standard](https://w3c.github.io/miniapp/white-paper/)
* Framework refactor for new apis
* Complier refactor

### Blockchain
* A `Substrate` based Blockchain with `IPFS` module
### Demo

---

## Poc-3 (TBD)

### Core Engine
### Dev Tools
### Blockchain BetaNet
### Demo

---

## Poc-4 (TBD)

### `Flutter` Packages
### Dev Tools
### Blockchain TestNet
### Web Portal
### Demo