import XCTest
import Foundation
@testable import FileResolver

class FileResolverTests: XCTestCase {

    static var allTests = [
        ("testExecutablePathResolution", testExecutablePathResolution),
        ("testProjectPathResolution", testProjectPathResolution),
        ("testPresentWorkingDirectoryPathResolution", testPresentWorkingDirectoryPathResolution),
    ]

    func testExecutablePathResolution() {
        let executableURL = FileResolver.executableURL
        let executableFolder = FileResolver.executableFolder
        let executableFolderURL = FileResolver.executableFolderURL

        XCTAssertEqual(executableFolderURL.path, executableFolder)

        #if os(Linux)
          XCTAssertEqual(executableFolderURL.path, "/FileResolver/.build/x86_64-unknown-linux/debug")
          XCTAssertEqual(executableFolderURL.lastPathComponent, "debug")
          XCTAssertEqual(executableURL.pathComponents.suffix(2), ["debug", "FileResolverPackageTests.xctest"])
        #else
          XCTAssertEqual(executableFolderURL.lastPathComponent, "Agents")
          XCTAssertEqual(executableURL.pathComponents.suffix(2), ["Agents", "xctest"])
        #endif
    }

    func testProjectPathResolution() {
      let projectFolder = FileResolver.projectFolder
      let projectFolderURL = FileResolver.projectFolderURL

      XCTAssertEqual(projectFolderURL.path, projectFolder)

      #if os(Linux)
        XCTAssertEqual(projectFolderURL.path, "/FileResolver")
      #else
        XCTAssertEqual(projectFolderURL.lastPathComponent, "Agents")
      #endif
    }

    func testPresentWorkingDirectoryPathResolution() {
      let presentWorkingDirectory = FileResolver.presentWorkingDirectory
      let presentWorkingDirectoryURL = FileResolver.presentWorkingDirectoryURL

      XCTAssertEqual(presentWorkingDirectoryURL.path, presentWorkingDirectory)

      #if os(Linux)
        XCTAssertEqual(presentWorkingDirectoryURL.path, "/FileResolver")
      #else
        let expectedPath = FileResolver.isRanInsideXcode ? "/private/tmp" : "/Users/AaronLiberatore/Documents/FileResolver"
        XCTAssertEqual(presentWorkingDirectoryURL.path, expectedPath)
      #endif

    }
}
