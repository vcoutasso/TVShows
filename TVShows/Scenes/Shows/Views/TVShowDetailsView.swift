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

    init(viewModel: TVShowDetailsViewModelProtocol & TVShowDetailsViewCollectionViewAdapterDelegate, collectionAdapter: TVShowDetailsViewCollectionViewAdapterProtocol) {
        self.viewModel = viewModel
        self.collectionAdapter = collectionAdapter
        super.init(frame: .zero)
        collectionAdapter.delegate = viewModel
        setUpView()
        requestData()
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

    private func requestData() {
        Task {
            async let _ = await viewModel.fetchEpisodes()
            async let _ = await viewModel.fetchImage()
            if let imageData = viewModel.imageData {
                collectionAdapter.stretchyHeaderImage = UIImage(data: imageData)
            }
            if let episodes = viewModel.episodes {
                collectionAdapter.updateSectionsWithEpisodes(episodes)
            }
            collectionView.reloadData()
        }
    }

    private let viewModel: TVShowDetailsViewModelProtocol
    private let collectionAdapter: TVShowDetailsViewCollectionViewAdapterProtocol

    private func sectionProvider(for sectionIndex: Int) -> NSCollectionLayoutSection {
        switch collectionAdapter.sections[sectionIndex] {
            case .info:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 2, leading: 0, bottom: 0, trailing: 0)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.9))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 1)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]
                return section
            case .season:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 16))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 12))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                header.extendsBoundary = false
                header.contentInsets = .init(top: 20, leading: 0, bottom: 10, trailing: 0)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
                section.orthogonalScrollingBehavior = .none
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

        collectionView.register(TVShowDetailsInfoCollectionViewCell.self)
        collectionView.register(TVShowDetailsEpisodeNameCollectionViewCell.self)
        collectionView.register(StretchyImageHeaderView.self, forSupplementaryKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(TVShowDetailsInfoSeasonHeaderView.self, forSupplementaryKind: UICollectionView.elementKindSectionHeader)

        return collectionView
    }()
}
