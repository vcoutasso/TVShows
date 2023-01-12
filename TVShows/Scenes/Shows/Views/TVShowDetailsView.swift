import UIKit

// MARK: - TVShowDetailsViewProtocol

@MainActor
protocol TVShowDetailsViewProtocol {
    var delegate: TVShowsListViewDelegate? { get set }
}

// MARK: - TVShowDetailsViewDelegate

@MainActor
protocol TVShowDetailsViewDelegate {
    func presentEpisodeDetails(_ episode: TVShowEpisode)
}

// MARK: - TVShowDetailsView

final class TVShowDetailsView: UIView, TVShowDetailsViewProtocol {
    // MARK: Lifecycle

    init(viewModel: TVShowDetailsViewModelProtocol, collectionAdapter: TVShowDetailsViewCollectionViewAdapterProtocol) {
        self.viewModel = viewModel
        self.collectionAdapter = collectionAdapter
        super.init(frame: .zero)
        setUpView()
        populateStretchyHeader()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    weak var delegate: TVShowsListViewDelegate?

    // MARK: Private

    private func setUpView() {
        backgroundColor = .systemBackground

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
        ])

    }

    private func populateStretchyHeader() {
        Task {
            await viewModel.fetchImage()
            if let imageData = viewModel.imageData {
                collectionAdapter.stretchyHeaderImage = UIImage(data: imageData)
                collectionView.reloadData()
            }
        }
    }

    private let viewModel: TVShowDetailsViewModelProtocol
    private let collectionAdapter: TVShowDetailsViewCollectionViewAdapterProtocol

    private func sectionProvider(for sectionIndex: Int) -> NSCollectionLayoutSection {
        switch collectionAdapter.sections[sectionIndex] {
            case .info:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 2, leading: 0, bottom: 10, trailing: 0)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.9))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 1)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [header]
                return section
            case .seasons:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 2, leading: 5, bottom: 2, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3), heightDimension: .fractionalHeight(0.2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [header]
                return section
        }
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            self?.sectionProvider(for: sectionIndex)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = collectionAdapter
        collectionView.dataSource = collectionAdapter

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TVShowDetailsInfoCollectionViewCell.self)
        collectionView.register(StretchyImageHeaderView.self, forSupplementaryKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(TVShowDetailsInfoSeasonHeaderView.self, forSupplementaryKind: UICollectionView.elementKindSectionHeader)

        return collectionView
    }()
}
