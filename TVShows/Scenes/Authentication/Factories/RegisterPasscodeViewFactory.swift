import Foundation

// MARK: - RegisterPasscodeViewFactory

enum RegisterPasscodeViewFactory {
    static func `default`() -> RegisterPasscodeView {
        .init(frame: .zero)
    }
}
