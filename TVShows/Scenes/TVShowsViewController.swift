import UIKit

/// Controller to display and list TV Shows
final class TVShowsViewController: UIViewController {

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    // MARK: Private

    private lazy var showsListView = {
        let view = TVShowsListView(viewModel: TVShowsListViewModel())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func setUpView() {
        title = "TV Shows"

        view.addSubview(showsListView)
        view.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            showsListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            showsListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            showsListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            showsListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }
}

