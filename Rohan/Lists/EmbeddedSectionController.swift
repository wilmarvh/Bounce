import UIKit
import IGListKit

final class SingleListSectionController: ListSectionController {
    
    override init() {
        super.init()
//        inset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let height = collectionContext?.containerSize.height ?? 0
        return CGSize(width: 180, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: UICollectionViewCell.self, for: self, at: index)
        cell?.backgroundColor = UIColor(red: 237/255.0, green: 73/255.0, blue: 86/255.0, alpha: 1)
        return cell!
    }
    
    override func didUpdate(to object: Any) {
        //
    }
    
}

