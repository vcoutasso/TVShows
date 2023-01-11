import UIKit

extension UICollectionView {
    func register<T: ReusableView>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: ReusableView>(_: T.Type, forSupplementaryKind kind: String) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: ReusableView>(_: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
    }

    func dequeueReusableSupplementaryView<T>(_: T.Type, ofKind kind: String, for indexPath: IndexPath) -> T? where T: UICollectionReusableView & ReusableView {
        dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
    }
}
