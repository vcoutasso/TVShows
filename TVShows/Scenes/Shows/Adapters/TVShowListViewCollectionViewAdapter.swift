import UIKit

// MARK: - TVShowListViewCollectionViewAdapterProtocol

@MainActor
protocol TVShowListViewCollectionViewAdapterProtocol: AnyObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var delegate: TVShowListViewCollectionViewAdapterDelegate? { get set }
}

// MARK: - TVShowListViewCollectionViewAdapterDelegate

@MainActor
protocol TVShowListViewCollectionViewAdapterDelegate: AnyObject {
    var displayedCellViewModels: [TVShowsListCollectionViewCellViewModelProtocol] { get }
    var shouldDisplayLoadingFooter: Bool { get }

    func didSelectCell(at indexPath: IndexPath)
    func didScrollPastCurrentContent()
}

// MARK: - TVShowListViewCollectionViewAdapter

final class TVShowListViewCollectionViewAdapter: NSObject, TVShowListViewCollectionViewAdapterProtocol {
    // MARK: Internal

    weak var delegate: TVShowListViewCollectionViewAdapterDelegate?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        delegate?.displayedCellViewModels.count ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(TVShowsListCollectionViewCell.self, for: indexPath),
              let viewModel = delegate?.displayedCellViewModels[indexPath.row]
        else {
            preconditionFailure("Unsupported cell/viewModel")
        }
        cell.configure(with: viewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let delegate, delegate.shouldDisplayLoadingFooter else { return .zero }

        return CGSize(width: collectionView.frame.width, height: LoadingCollectionViewFooter.LayoutMetrics.spinnerHeight)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(LoadingCollectionViewFooter.self, ofKind: kind, for: indexPath) else {
            preconditionFailure("Unsupported supplementary view kind")
        }
        footer.startAnimating()
        return footer
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let unavailableSpace = 2 * TVShowsListView.Constants.horizontalInset + TVShowsListView.Constants.padding
        let width = (UIScreen.main.bounds.width - unavailableSpace) / 2
        return CGSize(width: width, height: width * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelectCell(at: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - (scrollView.visibleSize.height * 1.1)) {
            delegate?.didScrollPastCurrentContent()
        }
    }
}
