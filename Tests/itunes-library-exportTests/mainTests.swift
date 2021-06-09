import XCTest

import class Foundation.Bundle

final class MainTests: XCTestCase {
    func testHelp() throws {
        let expected = """
        USAGE: itunes-library-export [--format <format>]

        OPTIONS:
          -f, --format <format>   The output format. (default: xml)
          -o, --output <path>     The output path. (default: stdout)
          -h, --help              Show help information.


        """

        let (exitstatus, actual) = try itunes_library_export(["--help"])
        XCTAssertEqual(0, exitstatus)
        XCTAssertEqual(actual, expected)
    }

    func testBinaryPropertyListFormat() throws {
        let (exitstatus, _) = try itunes_library_export(["--format", "plist"])
        XCTAssertEqual(0, exitstatus)
    }

    func testXMLPropertyListFormat() throws {
        let (exitstatus, _) = try itunes_library_export(["--format", "xml"])
        XCTAssertEqual(0, exitstatus)
    }

    func testJSONFormat() throws {
        let (exitstatus, _) = try itunes_library_export(["--format", "json"])
        XCTAssertEqual(0, exitstatus)
    }

    func testShortFormat() throws {
        let (exitstatus, _) = try itunes_library_export(["-f", "json"])
        XCTAssertEqual(0, exitstatus)
    }

    func testBadFormat() throws {
        let expected = """
        Error: The value 'bad' is invalid for '--format <format>'
        Help:  --format <format>  The output format.
        Usage: itunes-library-export [--format <format>]
          See 'itunes-library-export --help' for more information.

        """
        let (exitstatus, actual) = try itunes_library_export(["--format", "bad"])
        XCTAssertNotEqual(0, exitstatus)
        XCTAssertEqual(actual, expected)
    }

    func testUnknownFlag() throws {
        let expected = """
        Error: Unknown option '-v'
        Usage: itunes-library-export [--format <format>]
          See 'itunes-library-export --help' for more information.

        """
        let (exitstatus, actual) = try itunes_library_export(["-v"])
        XCTAssertNotEqual(0, exitstatus)
        XCTAssertEqual(actual, expected)
    }

    func testUnknownOption() throws {
        let expected = """
        Error: Unknown option '--answer'
        Usage: itunes-library-export [--format <format>]
          See 'itunes-library-export --help' for more information.

        """
        let (exitstatus, actual) = try itunes_library_export(["--answer", "42"])
        XCTAssertNotEqual(0, exitstatus)
        XCTAssertEqual(actual, expected)
    }

    func itunes_library_export(_ arguments: [String] = []) throws -> (Int32, String) {
        let fooBinary = productsDirectory.appendingPathComponent("itunes-library-export")

        let process = Process()
        process.executableURL = fooBinary
        process.arguments = arguments

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        try process.run()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""

        process.waitUntilExit()

        return (process.terminationStatus, output)
    }

    var productsDirectory: URL {
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
    }
}
