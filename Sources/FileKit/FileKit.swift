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

/// Utility providing path resolution and execution environment information
public class FileKit {

    // MARK: Absolute Path Resolution

    /// Absolute path to the executable's folder
    public static let executableFolder: String = executableFolderURL.path

    /// Absolute path to the project's root folder
    public static let projectFolder: String = projectFolderURL.path

    /// Absolute path to the present working directory (PWD)
    public static let workingDirectory: String = workingDirectoryURL.path

    // MARK: Absolute URL Path Resolution

    /// Provides the standardized working directory accounting for environmental changes.
    /// When running in Xcode, this returns the directory containing the Package.swift of the project
    /// while outside returns the current working directory
    public static let workingDirectoryURL: URL = { () -> URL in
        guard isRanInsideXcode || isRanFromXCTest, let url = projectHeadIterator(executableFolderURL) else {
            return URL(fileURLWithPath: "")
        }

        Log.debug("Running from Xcode or XCTest. Using project folder as pwd folder.")

        return url

    }().standardized

    /// This URL points to the executable
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

    /// Directory containing the executable of the project, or, if run from inside Xcode,
    /// the /.build/debug folder in the project's root folder.
    public static let executableFolderURL: URL = { () -> URL in
        if isRanInsideXcode || isRanFromXCTest {
            // Get URL to /debug manually
            let sourceFile = sourceFileURL.path

            if let range = sourceFile.range(of: "/checkouts/") {
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

    /// Directory containing the Package.swift of the project (as determined by traversing
    /// up the directory structure starting at the directory containing the executable), or
    /// if no Package.swift is found then the directory containing the executable
    public static let projectFolderURL: URL = { () -> URL in
      guard let url = projectHeadIterator(executableFolderURL) else {
        Log.warning("No Package.swift found. Using executable folder as project folder.")
        return executableFolderURL
      }

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

            if fileManager.fileExists(atPath: packageFilePath) {
                return startingDir
            }
        } while startingDir.path != "/"

        return nil
    }
}
