import Foundation

enum AppLogger {
    static func error(_ message: String) {
        #if DEBUG
        print("[ERROR] \(message)")
        print(message)
        #endif

        // could send to crash reporting later
    }
}
