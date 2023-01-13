import UIKit

extension UITableView {
    func register<T: ReusableView>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: ReusableView>(_: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T
    }
}
