//
//  Logging.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

// Structure holding logs formateter. Used to prevent formatter every time when logging used
struct DprintDateFormatter {
    private static var _formatter: DateFormatter? = nil
    static var formatter: DateFormatter {
        get {
            if _formatter == nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
                _formatter = dateFormatter
            }
            return _formatter!
        }
    }
}

/// Set of possible logs categories
enum LogCategory: String {
    case networking = "🚀 >NET>"
    case db = "🛢 >DB>"
    case error = "⛔️ >ERROR>"
    case others = ""
}

/**
 List of logs categories allowed to display
 
 Empty if all logs are enabled. Used in Debug mode only
 */
var allowedDprintCategories: [LogCategory] = []

/**
 Writes the textual representations of the given items into the standard output and also write to file
 - Parameters:
    - category: A logs category, used to add prefix to log string
    - items: A list of elements to be added to logs string
    - separator: A string to print between each item. The default value is a `newline` (`"\n"`)
    - terminator: The string to print after all items have been printed. The default is a `newline` ("\n")
    - limit: Maximum length of printed string (symbols amount)
 */
func dprint(category: LogCategory = .others,_ items: Any..., separator: String = "\n", terminator: String = "\n", limit: Int? = nil, async: Bool = true) {
    #if DEBUG
        guard allowedDprintCategories.isEmpty || allowedDprintCategories.contains(category) else { return }
        let output = items.map { "\($0)" }.joined(separator: separator)
        let logCategory: String = (category == .others) ? "" : "\(category.rawValue) : "
        var debugInfo: String = "\(logCategory)" + output
        if let limit = limit, debugInfo.count > limit {
            let suffix = "..."
            debugInfo = String(debugInfo.prefix(limit - suffix.count)) + suffix
        }
        if async {
            DispatchQueue.global(qos: .default).async {
                print(debugInfo)
            }
        } else {
            print(debugInfo)
        }
    #endif
}
