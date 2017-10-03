import UIKit
import NothingButNet
import SwiftRichString
import Nuke

class ShotDetailCommentsContainerCell: UICollectionViewCell {
    
    var shot: Shot!
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: View
    
    lazy var container: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.98039, green:0.98039, blue:0.98431, alpha:1.00000)
        return view
    }()
    
    var collectionView: UICollectionView! {
        didSet {
            configureViews()
        }
    }
    
    func configureViews() {
        contentView.backgroundColor = container.backgroundColor
        backgroundView?.backgroundColor = container.backgroundColor
        contentView.addSubview(container)
        container.addSubview(collectionView)
        
        let views = [
            "container": container,
            "collectionView": collectionView
        ]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]|", options: [], metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: views))
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.removeAllBorderLayers()
        contentView.layer.addTopBorder(inset: 0)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = collectionView.collectionViewLayout.collectionViewContentSize.height
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }

}
