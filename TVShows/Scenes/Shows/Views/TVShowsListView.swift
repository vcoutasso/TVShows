import UIKit

// MARK: - TVShowsListViewProtocol

@MainActor
protocol TVShowsListViewProtocol: AnyObject {
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

    init(viewModel: TVShowsListViewModelProtocol & TVShowListViewCollectionViewAdapterDelegate,
         collectionView: UICollectionView,
         collectionAdapter: TVShowListViewCollectionViewAdapterProtocol
    ) {
        self.viewModel = viewModel
        self.collectionView = collectionView
        self.collectionAdapter = collectionAdapter
        super.init(frame: .zero)

        collectionAdapter.delegate = viewModel
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

    // MARK: Internal

    weak var delegate: TVShowsListViewDelegate?

    func searchShows(with query: String) {
        Task {
            await viewModel.searchShows(with: query)
        }
    }

    func clearFilters() {
        viewModel.cancelSearch()
        collectionView.reloadData()
    }

    enum Constants {
        static let horizontalInset: CGFloat = 20
        static let padding: CGFloat = 10
    }

    // MARK: Private

    private func setUpView() {
        backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, loadingSpinner)
        addConstraints()
        loadingSpinner.startAnimating()
        setUpCollectionView()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            loadingSpinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            loadingSpinner.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            loadingSpinner.heightAnchor.constraint(equalTo: loadingSpinner.widthAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }

    private func setUpCollectionView() {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let isPortrait = self.frame.height > self.frame.width
            let itemSize: NSCollectionLayoutSize = isPortrait ? .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)) : .init(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
            let groupHeight: NSCollectionLayoutDimension = isPortrait ? .fractionalHeight(1.0 / 3) : .fractionalHeight(1.0 / 2)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight), subitems: [item])
            group.contentInsets = .init(top: 0, leading: Constants.horizontalInset, bottom: 0, trailing: Constants.horizontalInset)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        collectionView.collectionViewLayout = layout
        collectionView.delegate = collectionAdapter
        collectionView.dataSource = collectionAdapter
        collectionView.isHidden = true
        collectionView.alpha = 0

        collectionView.register(TVShowsListCollectionViewCell.self)
        collectionView.register(LoadingCollectionViewFooter.self, forSupplementaryKind: UICollectionView.elementKindSectionFooter)
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

    private let collectionView: UICollectionView
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
