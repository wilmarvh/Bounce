import UIKit

class HomeViewGridLayout: UICollectionViewFlowLayout {
    
    static let height: CGFloat = 140
    
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
        minimumInteritemSpacing = 10
        minimumLineSpacing = 15
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing) / 2
    }
    
    override var itemSize: CGSize {
        get {
            return CGSize(width: itemWidth(), height: HomeViewGridLayout.height)
        }
        set {
            self.itemSize = newValue
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}

