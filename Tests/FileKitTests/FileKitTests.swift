import XCTest
import Foundation
@testable import FileKit

class FileKitTests: XCTestCase {

    static var allTests = [
        ("testExecutablePathResolution", testExecutablePathResolution),
        ("testProjectPathResolution", testProjectPathResolution),
        ("testWorkingDirectoryPathResolution", testWorkingDirectoryPathResolution),
    ]

    func testExecutablePathResolution() {
        let executableURL = FileKit.executableURL
        let executableFolder = FileKit.executableFolder
        let executableFolderURL = FileKit.executableFolderURL

        XCTAssertEqual(executableFolderURL.path, executableFolder)
        #if os(Linux)
          XCTAssertEqual(executableFolderURL.pathComponents.suffix(4), ["FileKit", ".build", "x86_64-unknown-linux", "debug" ])
          XCTAssertEqual(executableFolderURL.lastPathComponent, "debug")
          XCTAssertEqual(executableURL.pathComponents.suffix(2), ["debug", "FileKitPackageTests.xctest"])
        #else
          XCTAssertEqual(executableFolderURL.lastPathComponent, "Agents")
          XCTAssertEqual(executableURL.pathComponents.suffix(2), ["Agents", "xctest"])
        #endif
    }

    func testProjectPathResolution() {
      let projectFolder = FileKit.projectFolder
      let projectFolderURL = FileKit.projectFolderURL

      XCTAssertEqual(projectFolderURL.path, projectFolder)

      #if os(Linux)
        XCTAssertEqual(projectFolderURL.lastPathComponent, "FileKit")
      #else
        XCTAssertEqual(projectFolderURL.lastPathComponent, "Agents")
      #endif
    }

    func testWorkingDirectoryPathResolution() {
      let workingDirectory = FileKit.workingDirectory
      let workingDirectoryURL = FileKit.workingDirectoryURL

      XCTAssertEqual(workingDirectoryURL.path, workingDirectory)

      #if os(Linux)
        XCTAssertEqual(workingDirectoryURL.lastPathComponent, "FileKit")
      #else
        let expectedPath = URL(fileURLWithPath: "").path == "/private/tmp" ? "tmp" : "FileKit"
        XCTAssertEqual(workingDirectoryURL.lastPathComponent, expectedPath)
      #endif

    }
}
