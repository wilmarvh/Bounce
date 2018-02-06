import UIKit
import NothingButNet

enum HomeSort: String {
    case popular = "Popular"
    case recent = "Recent"
    case mostViewed = "Most Viewed"
    case mostCommented = "Most Commented"
    
    static func allNames() -> [String] {
        return [HomeSort.popular.rawValue,
                HomeSort.recent.rawValue,
                HomeSort.mostViewed.rawValue,
                HomeSort.mostCommented.rawValue
        ]
    }
    
    func asSort() -> Shot.Sort {
        switch self {
        case .popular:
            return .popular
        case .recent:
            return .recent
        case .mostViewed:
            return .views
        case .mostCommented:
            return .comments
        }
    }
}


class HomeSortViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var selectedSort: HomeSort = .popular
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    // MARK: Configure view
    
    func configureCollectionView() {
        // cells and other
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(HomeFilterCell.self, forCellWithReuseIdentifier: "Cell")
        
        // layout
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(25, 20, 25, 20)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 15
            collectionView?.collectionViewLayout = layout
        }
    }
    
    // MARK: UICollectionView DataSource / Delegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeSort.allNames().count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let width = collectionView.frame.width - layout.sectionInset.left - layout.sectionInset.right
            return CGSize(width: width, height: HomeFilterCell.height)
        }
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeFilterCell
        
        let item = HomeSort.allNames()[indexPath.row]
        cell.button.setTitle(item, for: .normal)
        cell.button.isHighlighted = selectedSort.rawValue == item
        cell.button.action = { [weak self] in
            let item = HomeSort.allNames()[indexPath.row]
            if let sort = HomeSort(rawValue: item) {
                self?.selectedSort = sort
                self?.collectionView?.reloadData()
                _ = self?.popoverPresentationController?.delegate?.popoverPresentationControllerShouldDismissPopover!((self?.popoverPresentationController)!)
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
        return cell
    }
}
