import UIKit

// MARK: - FavoriteTVShowsViewController

final class FavoriteTVShowsViewController: UIViewController {
    // MARK: Lifecycle

    init(listView: UIView & FavoriteShowsListViewProtocol) {
        self.listView = listView
        super.init(nibName: nil, bundle: nil)
        setUpView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listView.reloadFavoritesList()
    }

    // MARK: Private

    private func setUpView() {
        title = "Favorites"

        navigationItem.largeTitleDisplayMode = .always

        view.backgroundColor = .systemBackground
        view.addSubview(listView)

        listView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: view.topAnchor),
            listView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            listView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            listView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }

    private let listView: UIView & FavoriteShowsListViewProtocol
}
