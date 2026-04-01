import Foundation

enum ScreenState<Value> {
    case idle
    case loading
    case success(Value)
    case error(String)
}
