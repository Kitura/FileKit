# FileResolver

> Utility for resolving paths and execution environments

[![Build Status - Master](https://travis-ci.org/IBM-Swift/FileResolver.svg?branch=master)](https://travis-ci.org/IBM-Swift/FileResolver)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)
![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)

## Version Info
The latest release of `FileResolver` (v0.x.x) runs on Swift 4.0 and newer, on both macOS and Ubuntu Linux

## Installation

### Via Swift Package Manager

Add `FileResolver` to your `Package.swift`:

```swift

let package = Package(
  name: "<package-name>",
  dependencies: [
    // Swift 4
    .package(url: "https://github.com/IBM-Swift/FileResolver.git", .upToNextMajor(from: "0.0.0"))
  ]
)

```

## Usage

#### Execution Environment
```swift
/*
  Indicates whether a program is ran from inside Xcode
  (i.e. the executable's path contains /DerivedData)
*/
let bool = FileResolver.isRanInsideXcode

/*
  Indicates whether a code is executed from within XCTestCase
  (i.e. the executable is XCTest)
*/
let bool = FileResolver.isRanFromXCTest
```

#### Path Resolution
```swift

/// Absolute path to the executable's folder
let stringUrl = FileResolver.executableFolder

/// Absolute path to the project's root folder
let stringUrl = FileResolver.projectFolder

/// Absolute path to the present working directory (PWD)
let stringUrl = FileResolver.presentWorkingDirectory

// To get the path of your own source file use the built in functionality
let stringUrl = URL(fileURLWithPath: #file)
```

```swift
/*
  Directory containing the Package.swift of the project
  when run through Xcode or XCTest. Otherwise, returns
  the current working directory
*/
let urlObject = FileResolver.presentWorkingDirectoryURL

/*
  URL pointing to the executable
*/
let urlObject = FileResolver.executableURL

/*
  Directory containing the executable of the project.
  If run from inside Xcode, the .build/debug folder
  in the project's root folder.
*/
let urlObject = FileResolver.executableFolderURL

/*
  Directory containing the Package.swift of the project
  (as determined by traversing up the directory structure
  starting at the directory containing the executable),
  or if no Package.swift is found then the directory
  containing the executable
*/
let urlObject = FileResolver.projectFolderURL
```
