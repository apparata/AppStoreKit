//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

internal extension String {
    
    var isEmptyOrWhitespace: Bool {
        return isEmpty ? true : trimmingCharacters(in: .whitespaces) == ""
    }
    
    var isNotEmptyOrWhitespace: Bool {
        return !isEmptyOrWhitespace
    }
    
}

public class CSV {
    
    private let columnCount: Int
    public let headers: [String]
    public let keyedRows: [[String: String]]
    public let rows: [[String]]
    
    public init(string: String, separator: String = ",", headers: [String]? = nil) {
        var parsedLines = CSV.records(from: string.replacingOccurrences(of: "\r\n", with: "\n")).map { CSV.cells(fromRow: $0, separator: separator) }
        self.headers = headers ?? parsedLines.removeFirst()
        rows = parsedLines
        columnCount = self.headers.count
        
        let tempHeaders = self.headers
        keyedRows = rows.map { field -> [String: String] in
            var row = [String: String]()
            for (index, value) in field.enumerated() where value.isNotEmptyOrWhitespace {
                row[tempHeaders[index]] = value
            }
            return row
        }
    }
    
    public convenience init(string: String, headers: [String]?) {
        self.init(string: string, separator: ",", headers: headers)
    }
        
    internal static func cells(fromRow rowString: String, separator: String = ",") -> [String] {
        return CSV.split(string: rowString, separator: separator).map { element in
            if let first = element.first, let last = element.last, first == "\"" && last == "\"" {
                let start = element.index(element.startIndex, offsetBy: 1)
                let end = element.index(element.endIndex, offsetBy: -1)
                let range = start ..< end
                return String(element[range])
            }
            return element
        }
    }
    
    internal static func records(from string: String) -> [String] {
        return CSV.split(string: string, separator: "\n").filter { $0.isNotEmptyOrWhitespace }
    }
    
    private static func split(string: String, separator: String) -> [String] {
        
        func oddNumberOfQuotes(string: String) -> Bool {
            return string.components(separatedBy: "\"").count % 2 == 0
        }
        
        let initial = string.components(separatedBy: separator)
        var merged = [String]()
        for newString in initial {
            guard let record = merged.last, oddNumberOfQuotes(string: record) == true else {
                merged.append(newString)
                continue
            }
            merged.removeLast()
            let lastElement = record + separator + newString
            merged.append(lastElement)
        }
        return merged
    }
    
}
