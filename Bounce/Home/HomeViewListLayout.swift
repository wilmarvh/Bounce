import UIKit

class HomeViewListLayout: UICollectionViewFlowLayout {
    
    static let height: CGFloat = 250
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init() {
        super.init()
        configure()
    }
    
    func configure() {
        scrollDirection = .vertical
        sectionInset = UIEdgeInsetsMake(15, 15, 15, 15)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 25
    }
    
    func itemWidth() -> CGFloat {
        return collectionView!.frame.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing
    }
    
    override var itemSize: CGSize {
        get {
            return CGSize(width: itemWidth(), height: HomeViewListLayout.height)
        }
        set {
            self.itemSize = newValue
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}
