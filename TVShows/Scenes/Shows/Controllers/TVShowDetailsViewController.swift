import UIKit

/// Controller for displaying details about a particular show
final class TVShowDetailsViewController: UIViewController {
    // MARK: Lifecycle

    init(detailsView: UIView & TVShowDetailsViewProtocol) {
        self.detailsView = detailsView
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    

    // MARK: Private

    private func setUpView() {
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(detailsView)

        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backgroundColor = .clear

        view.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: view.topAnchor),
            detailsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private let detailsView: UIView & TVShowDetailsViewProtocol
}
