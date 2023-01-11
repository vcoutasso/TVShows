import UIKit

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont? {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else { return nil }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func bold() -> UIFont? {
        withTraits(traits: .traitBold)
    }
}
