import Darwin
import Foundation
import iTunesLibrary

let commandName = "itunes-library-export"

enum Format: String {
  case plist
  case json
  case xml
}

var format: Format = .xml
var outputURL = URL(fileURLWithPath: "/dev/stdout")

for (index, argument) in CommandLine.arguments.enumerated() {
  guard argument.hasPrefix("-") else { continue }

  switch argument {
  case "-h", "--help":
    let message = """
      USAGE: \(commandName) [--format <format>]

      OPTIONS:
        -f, --format <format>   The output format. (default: xml)
        -o, --output <path>     The output path. (default: stdout)
        -h, --help              Show help information.

      """
    print(message)
    exit(0)
  case "-f", "--format":
    let rawValue = CommandLine.arguments[index + 1]
    if let value = Format(rawValue: rawValue) {
      format = value
    } else {
      let message = """
        Error: The value '\(rawValue)' is invalid for '--format <format>'
        Help:  --format <format>  The output format.
        Usage: \(commandName) [--format <format>]
          See '\(commandName) --help' for more information.

        """
      fputs(message, stderr)
      exit(1)
    }
  case "-o", "--output":
    outputURL = URL(fileURLWithPath: CommandLine.arguments[index + 1])
  default:
    let message = """
      Error: Unknown option '\(argument)'
      Usage: \(commandName) [--format <format>]
        See '\(commandName) --help' for more information.

      """
    fputs(message, stderr)
    exit(1)
  }
}

let library = try ITLibrary(apiVersion: "1.1")
var data: Data

switch format {
case .plist:
  let encoder = PropertyListEncoder()
  encoder.outputFormat = .binary
  usePlistCodingKeys = true
  data = try encoder.encode(library)
case .xml:
  let encoder = PropertyListEncoder()
  encoder.outputFormat = .xml
  usePlistCodingKeys = true
  data = try encoder.encode(library)
case .json:
  let encoder = JSONEncoder()
  encoder.dateEncodingStrategy = .iso8601
  data = try encoder.encode(library)
}

if outputURL.path == "/dev/stdout" {
  FileHandle.standardOutput.write(data)
} else {
  try data.write(to: outputURL)
}
