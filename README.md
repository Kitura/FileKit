<p align="center">
    <a href="http://kitura.dev/">
        <img src="https://raw.githubusercontent.com/Kitura/Kitura/master/Sources/Kitura/resources/kitura-bird.svg?sanitize=true" height="100" alt="Kitura">
    </a>
</p>

<p align="center">
    <a href="https://kitura.github.io/FileKit/index.html">
    <img src="https://img.shields.io/badge/apidoc-FileKit-1FBCE4.svg?style=flat" alt="APIDoc">
    </a>
    <a href="https://travis-ci.org/Kitura/FileKit">
    <img src="https://travis-ci.org/Kitura/FileKit.svg?branch=master" alt="Build Status - Master">
    </a>
    <img src="https://img.shields.io/badge/os-macOS-green.svg?style=flat" alt="macOS">
    <img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux">
    <img src="https://img.shields.io/badge/license-Apache2-blue.svg?style=flat" alt="Apache 2">
    <a href="http://swift-at-ibm-slack.mybluemix.net/">
    <img src="http://swift-at-ibm-slack.mybluemix.net/badge.svg" alt="Slack Status">
    </a>
</p>

# FileKit

Resolves commonly used paths, including the project, executable and working directories.

## Version
The latest release of `FileKit` (0.x.x) runs on Swift 4.0 and newer, on both macOS and Ubuntu Linux.

## Usage

### Add dependencies

Add `FileKit` to the dependencies within your application's `Package.swift` file. Substitute `"x.x.x"` with the latest `FileKit` [release](https://github.com/Kitura/FileKit/releases).

```swift
.package(url: "https://github.com/Kitura/FileKit.git", from: "x.x.x")
```
Add `FileKit` to your target's dependencies:

```Swift
.target(name: "example", dependencies: ["FileKit"]),
```

#### Import package

```swift
import FileKit
```

You will also need to import the `Foundation` package if you're handling URLs:

```swift
import Foundation
```

## Supported Paths

#### Path to Executable Folder

Points to the folder containing the project executable.

For example, when running an executable called `MySwiftProject` within Xcode the executable folder string would be "/Users/username/MySwiftProject/.build/debug", when running the same project from the command line this would be "/Users/username/MySwiftProject/.build/x86_64-apple-macosx10.10/debug".

```swift
  /// Executable Folder String
  let stringUrl = FileKit.executableFolder

  /// Executable Folder URL
  let urlObject = FileKit.executableFolderURL

  /// Executable File
  let urlObject = FileKit.executableURL
```

Note, the `executableURL` will be different when running inside Xcode versus running from the command line.
For example, when running an executable called `MySwiftProject`:
- Running on the command line - `file:///Users/username/MySwiftProject/.build/x86_64-apple-macosx10.10/debug/MySwiftProject`
- Running within Xcode - `file:///Users/username/Library/Developer/Xcode/DerivedData/MySwiftProject-fjgfjmxrlbhzkhfmxdgeipylyeay/Build/Products/Debug/MySwiftProject`.

#### Path to Project Folder

Points to the directory containing the `Package.swift` of the project (as determined by traversing up the directory structure starting at the directory containing the executable), or if no `Package.swift` is found then the directory containing the executable.

```swift
  /// Absolute path to the project's root folder
  let stringUrl = FileKit.projectFolder

  /// URL to the project's root folder
  let urlObject = FileKit.projectFolderURL
```

#### Path to Working Directory

Provides the standardized working directory, while accounting for environmental changes. When running in Xcode, this returns the directory containing the `Package.swift` of the project, while outside Xcode it returns the current working directory.

```swift
  /// Absolute path to the present working directory
  let stringUrl = FileKit.workingDirectory

  /// URL to the project's root folder
  let urlObject = FileKit.workingDirectoryURL
```

#### Native Swift File Utilities

Note. As this is native Swift functionality you can use this without importing FileKit.

```swift
  /// URL pointing to the current source file when it was compiled.
  let stringUrl = URL(fileURLWithPath: #file)
```

## API documentation

For more information visit our [API reference](http://kitura.github.io/FileKit/).

## Community

We love to talk server-side Swift, and Kitura. Join our [Slack](http://swift-at-ibm-slack.mybluemix.net/) to meet the team!

## License

This library is licensed under Apache 2.0. Full license text is available in [LICENSE](https://github.com/Kitura/FileKit/blob/master/LICENSE).
