import UIKit

@MainActor
protocol TVShowsListViewProtocol {
    /// Filters show with the `query` parameter
    func searchShows(with query: String)
    /// Clears previous queries and displays unfiltered cached data
    func clearFilters()
}

/// Displays collection of shows
final class TVShowsListView: UIView, TVShowsListViewProtocol {
    // MARK: Lifecycle

    init(viewModel: TVShowsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        viewModel.delegate = self

        setUpView()

        Task {
            await viewModel.fetchInitialPage()
            displayInitialShows()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func searchShows(with query: String) {
        Task {
            await viewModel.searchShows(with: query)
        }
    }

    func clearFilters() {
        viewModel.cancelSearch()
        collectionView.reloadData()
    }

    // MARK: Private

    private func setUpView() {
        backgroundColor = .systemBackground
        addSubviews(loadingSpinner, collectionView)
        addConstraints()
        loadingSpinner.startAnimating()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            loadingSpinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingSpinner.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            loadingSpinner.heightAnchor.constraint(equalTo: loadingSpinner.widthAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }

    private func displayInitialShows() {
        loadingSpinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }

    private let viewModel: TVShowsListViewModelProtocol

    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true

        return spinner
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        collectionView.isHidden = true
        collectionView.alpha = 0

        collectionView.register(TVShowsListCollectionViewCell.self)
        collectionView.register(LoadingCollectionViewFooter.self, forSupplementaryKind: UICollectionView.elementKindSectionFooter)

        return collectionView
    }()
}

extension TVShowsListView: TVShowsListViewModelDelegate {
    func didFetchNextPage(with indexPathsToAdd: [IndexPath]) {
        collectionView.insertItems(at: indexPathsToAdd)
    }

    func didSearchShows() {
        collectionView.reloadData()
    }
}
