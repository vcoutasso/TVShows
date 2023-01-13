import UIKit

// MARK: - AuthenticationViewController

final class AuthenticationViewController: UIViewController, Coordinated {
    typealias Flow = AuthenticationFlow

    // MARK: Internal

    private(set) var coordinator: (any FlowCoordinator<AuthenticationFlow>)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }

}
