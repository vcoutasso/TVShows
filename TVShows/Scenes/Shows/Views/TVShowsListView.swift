import UIKit

// MARK: - TVShowsListViewProtocol

@MainActor
protocol TVShowsListViewProtocol {
    var delegate: TVShowsListViewDelegate? { get set }

    /// Filters show with the `query` parameter
    func searchShows(with query: String)
    /// Clears previous queries and displays unfiltered cached data
    func clearFilters()
}

// MARK: - TVShowsListViewDelegate

@MainActor
protocol TVShowsListViewDelegate: AnyObject {
    func presentShowDetails(_ show: TVShow)
}

// MARK: - TVShowsListView

/// Displays collection of shows
final class TVShowsListView: UIView, TVShowsListViewProtocol {
    // MARK: Lifecycle

    init(viewModel: TVShowsListViewModelProtocol & TVShowListViewCollectionViewAdapterDelegate, collectionAdapter: TVShowListViewCollectionViewAdapterProtocol) {
        self.viewModel = viewModel
        self.collectionAdapter = collectionAdapter
        super.init(frame: .zero)

        collectionAdapter.delegate = viewModel
        Task {
            await viewModel.setDelegate(self)
        }

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

    // MARK: Internal

    weak var delegate: TVShowsListViewDelegate?

    func searchShows(with query: String) {
        Task {
            await viewModel.searchShows(with: query)
        }
    }

    func clearFilters() {
        Task {
            await viewModel.cancelSearch()
            collectionView.reloadData()
        }
    }

    enum Constants {
        static let horizontalInset: CGFloat = 20
        static let padding: CGFloat = 10
    }

    // MARK: Private

    private func setUpView() {
        backgroundColor = .systemBackground
        addSubviews(collectionView, loadingSpinner)
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
    private let collectionAdapter: TVShowListViewCollectionViewAdapterProtocol

    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true

        return spinner
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.horizontalInset, bottom: 0, right: Constants.horizontalInset)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = collectionAdapter
        collectionView.dataSource = collectionAdapter
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

    func didFetchFilteredShows() {
        collectionView.reloadData()
    }

    func didSelectCell(for show: TVShow) {
        delegate?.presentShowDetails(show)
    }
}
