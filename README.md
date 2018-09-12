# FileKit

> Utility for resolving common paths

[![Build Status - Master](https://travis-ci.org/IBM-Swift/FileKit.svg?branch=master)](https://travis-ci.org/IBM-Swift/FileKit)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)
![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)

## Version Info
The latest release of `FileKit` (v0.x.x) runs on Swift 4.0 and newer, on both macOS and Ubuntu Linux

## Installation

### Via Swift Package Manager

Add `FileKit` to your `Package.swift`:

#### Swift 3

```swift

let package = Package(
    name: "FileKit",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/FileKit.git", majorVersion: 1, minor: 7)
    ]
)
```

#### Swift 4

```swift

let package = Package(
  name: "FileKit",
  dependencies: [
    .package(url: "https://github.com/IBM-Swift/FileKit.git", .upToNextMajor(from: "0.0.0"))
  ]
)

```

## Supported Paths

#### Path to Executable Folder

Points to the project executable folder

```swift
  /// Executable Folder String
  let stringUrl = FileKit.executableFolder

  /// Executable Folder URL
  let urlObject = FileKit.executableFolderURL

  /// Executable File
  let urlObject = FileKit.executableURL

```

#### Path to Project Folder

Points to the directory containing the Package.swift of the project (as determined by traversing up the directory structure starting at the directory containing the executable), or if no Package.swift is found then the directory containing the executable

```swift
  /// Absolute path to the project's root folder
  let stringUrl = FileKit.projectFolder

  /// URL to the project's root folder
  let urlObject = FileKit.projectFolderURL

```

#### Path to Working Directory

Provides the standardized working directory, while accounting for environmental changes. When running in Xcode, this returns the directory containing the Package.swift of the project while outside returns the current working directory

```swift
  /// Absolute path to the present working directory
  let stringUrl = FileKit.workingDirectory

  /// URL to the project's root folder
  let urlObject = FileKit.workingDirectoryURL

```

#### Built-in Swift File Utilities

```swift
  /// URL pointing to current file
  let stringUrl = URL(fileURLWithPath: #file)

```
