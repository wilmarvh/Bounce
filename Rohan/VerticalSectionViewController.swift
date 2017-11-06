import UIKit
import IGListKit

final class VerticalSectionController: ListSectionController, ListAdapterDataSource {
    
    private var number: Int?
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 100)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: VerticalEmbeddedCollectionViewCell.self,
                                                                for: self,
                                                                at: index) as? VerticalEmbeddedCollectionViewCell else {
                                                                    fatalError()
        }
        adapter.collectionView = cell.collectionView
        return cell
    }
    
    override func didUpdate(to object: Any) {
        number = object as? Int
    }
    
    // MARK: ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let number = number else { return [] }
        return (0..<number).map { $0 as ListDiffable }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return SingleListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}


