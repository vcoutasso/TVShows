import Foundation

extension String {
    /// Returns a copy of the `String` stripping all non-alphabetic characters
    func alphabeticalOnly() -> String {
        self.replacingOccurrences(of: "[^A-za-z]+", with: "", options: [.regularExpression])
    }

    func strippingHTMLTags() -> String {
        self.replacingOccurrences(of: "<.*?>+", with: "", options: [.regularExpression])
    }
}
