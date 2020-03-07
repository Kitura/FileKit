/*
 * Copyright IBM Corporation 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import LoggerAPI

/// Resolves commonly used paths, including the project, executable and working directories.
public class FileKit {

    // MARK: Path to Executable Folder

    /// The absolute path to the folder containing the project executable.
    ///
    /// For example, when running an executable called `MySwiftProject` within Xcode this would be "/Users/username/MySwiftProject/.build/debug", when running the same project from the command line this would be "/Users/username/MySwiftProject/.build/x86_64-apple-macosx10.10/debug".
    /// ### Usage Example: ###
    /// ```swift
    /// let urlString = FileKit.executableFolder
    /// ```
    public static let executableFolder: String = executableFolderURL.path

    /// URL that points to the directory containing the project executable, or, if run from inside Xcode,
    /// the `/.build/debug` folder in the project's root folder.
    ///
    /// For example when running an executable called `MySwiftProject` within Xcode this would be
    /// `file:///Users/username/MySwiftProject/.build/debug/`.
    /// ### Usage Example: ###
    /// ```swift
    /// let urlObject = FileKit.executableFolderURL
    /// ```
    public static let executableFolderURL: URL = { () -> URL in
        if isRanInsideXcode || isRanFromXCTest {
            // Get URL to /debug manually
            let sourceFile = sourceFileURL.path

            if let range = sourceFile.range(of: "/SourcePackages/checkouts/") {
                // If Package.swift is opened in XCode source code is downloaded in
                // /<deriveddata-path>/SourcePackages/checkouts.
                return URL(fileURLWithPath: sourceFile[..<range.lowerBound] + "/Build/Products/Debug")
            } else if let range = sourceFile.range(of: "/checkouts/") {
                // In Swift 4.0 and newer, package source code is downloaded to /<build-path>/checkouts
                return URL(fileURLWithPath: sourceFile[..<range.lowerBound] + "/debug")
            } else if let range = sourceFile.range(of: "/Packages/") {
                // Editable packages in Swift 4.0, package source code is downloaded to /Packages
                // Since we don't know /<build-path>, assume /.build instead
                return URL(fileURLWithPath: sourceFile[..<range.lowerBound] + "/.build/debug")
            }

            Log.warning("Cannot infer /.build/debug folder location from source code structure. Using executable folder as determined from inside Xcode.")
        }

        return executableURL.appendingPathComponent("..")
        }().standardized

    // MARK: Executable

    /// URL that points to the executable.
    ///
    /// For example, when running an executable called `MySwiftProject` from the command line
    /// this would be:
    ///
    /// `file:///Users/username/MySwiftProject/.build/x86_64-apple-macosx10.10/debug/MySwiftProject`.
    ///
    /// When running within Xcode it would be:
    ///
    /// `file:///Users/username/Library/Developer/Xcode/DerivedData/MySwiftProject-fjgfjmxrlbhzkhfmxdgeipylyeay/Build/Products/Debug/MySwiftProject`.
    ///
    /// ### Usage Example: ###
    /// ```swift
    /// let urlObject = FileKit.executableURL
    /// ```
    public static let executableURL: URL = { () -> URL in
        #if os(Linux)
        // Bundle is not available on Linux yet
        // Get path to executable via /proc/self/exe
        // https://unix.stackexchange.com/questions/333225/which-process-is-proc-self-for
        return URL(fileURLWithPath: "/proc/self/exe")
        #else
        // Bundle is available on Darwin
        return (Bundle.main.executableURL ?? URL(fileURLWithPath: CommandLine.arguments[0]))
        #endif
    }().resolvingSymlinksInPath()

    // MARK: Path to Project Folder

    /// Absolute path to the directory containing the `Package.swift` of the project (as determined by
    /// traversing up the directory structure starting at the directory containing the executable), or
    /// if no `Package.swift` is found then the directory containing the executable.
    ///
    /// For example, when running an executable called `MySwiftProject` this would be something like:
    /// `/Users/username/MySwiftProject`.
    ///
    /// ### Usage Example: ###
    /// ```swift
    /// let urlString = FileKit.projectFolder
    /// ```
    public static let projectFolder: String = projectFolderURL.path

    /// URL that points to the directory containing the `Package.swift` of the project (as determined
    /// by traversing up the directory structure starting at the directory containing the executable),
    /// or if no `Package.swift` is found then the directory containing the executable.
    ///
    /// For example, when running an executable called `MySwiftProject` this would be something like:
    /// `file:///Users/username/MySwiftProject/`.
    ///
    /// ### Usage Example: ###
    /// ```swift
    /// let urlObject = FileKit.projectFolderURL
    /// ```
    public static let projectFolderURL: URL = { () -> URL in
        guard let url = projectHeadIterator(executableFolderURL) else {
            Log.warning("No Package.swift found. Using executable folder as project folder.")
            return executableFolderURL
        }

        return url

    }().standardized

    // MARK: Path to Working Directory

    /// Provides the standardized working directory accounting for environmental changes.
    /// When running in Xcode, this returns the directory containing the `Package.swift` of the project,
    /// while outside Xcode it returns the current working directory.
    /// ### Usage Example: ###
    /// ```swift
    /// let urlString = FileKit.workingDirectory
    /// ```
    public static let workingDirectory: String = workingDirectoryURL.path

    /// URL that points to the standardized working directory accounting for environmental changes.
    /// When running in Xcode, this returns the directory containing the `Package.swift` of the project,
    /// while outside Xcode it returns the current working directory.
    /// ### Usage Example: ###
    /// ```swift
    /// let urlObject = FileKit.workingDirectoryURL
    /// ```
    public static let workingDirectoryURL: URL = { () -> URL in
        guard isRanInsideXcode || isRanFromXCTest, let url = projectHeadIterator(executableFolderURL) else {
            return URL(fileURLWithPath: "")
        }

        Log.debug("Running from Xcode or XCTest. Using project folder as pwd folder.")

        return url

    }().standardized

}

// Environment Information
private extension FileKit {

  /// Indicates whether a code is executed from within XCTestCase (i.e. the executable is XCTest)
  private static let isRanFromXCTest: Bool = executableURL.path.hasSuffix("/xctest")

  /// Indicates whether a program is ran from inside Xcode
  /// (i.e. the executable's path contains /DerivedData)
  private static let isRanInsideXcode: Bool = executableURL.path.range(of: "/DerivedData/") != nil

}

/// FileKit extension defining private helper methods
private extension FileKit {

    /// URL pointing to this source file
    private static let sourceFileURL: URL = URL(fileURLWithPath: #file)

    /// Takes a starting directory and iterates down the tree to find package.swift (the root directory)
    private static let projectHeadIterator = { (startingDir: URL) -> URL? in
        let fileManager = FileManager()
        var startingDir = startingDir.appendingPathComponent("dummy")

        repeat {
            startingDir.appendPathComponent("..")
            startingDir.standardize()
            let packageFilePath = startingDir.appendingPathComponent("Package.swift").path
            let infoFilePath = startingDir.appendingPathComponent("info.plist").path

            if fileManager.fileExists(atPath: packageFilePath) {
                return startingDir
            }
            if fileManager.fileExists(atPath: infoFilePath),
               let contents = fileManager.contents(atPath: infoFilePath),
               let plist = try? PropertyListSerialization.propertyList(from: contents, options: [], format: nil) as? [String: Any],
               let workspacePath = plist["WorkspacePath"] as? String {
                return URL(fileURLWithPath: workspacePath, isDirectory: true)
            }
        } while startingDir.path != "/"

        return nil
    }
}
