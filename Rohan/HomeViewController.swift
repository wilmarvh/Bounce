import UIKit
import IGListKit

class HomeViewController: UICollectionViewController, ListAdapterDataSource {
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    enum Sections: Int {
        case lists = 0
        case designers = 1
        case popular = 2
    }
    
    let data: [Any] = [
        Sections.lists.rawValue,
//        Sections.designers.rawValue,
//        Sections.popular.rawValue,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    // MARK: ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data as! [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let section = Sections(rawValue: object as! Int)!
        switch section {
        case .lists:
            return ListsSectionController()
        case .designers:
            return VerticalSectionController()
        case .popular:
            return VerticalSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
