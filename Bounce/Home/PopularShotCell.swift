import UIKit

class PopularShotCell: UICollectionViewCell {
    
    var shotId: Int = 0
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shotId = 0
        imageView.image = nil
        imageView.alpha = 0
    }
    
    // MARK: Views
    
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addDefaultShadow()
        return view
    }()
    
    lazy var details: PopularShotCellDetailsContainerView = {
        let owner = PopularShotCellDetailsContainerView()
        let view = PopularShotCellDetailsContainerView.viewFromNib(owner: owner) as! PopularShotCellDetailsContainerView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.alpha = 0
        return view
    }()
    
    lazy var imageContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor(red:0.94902, green:0.94902, blue:0.94902, alpha:1.00000)
        view.addSubview(self.imageView)
        return view
    }()
    
    func configureViews() {
        // config
        backgroundColor = UIColor.white
        backgroundView?.backgroundColor = backgroundColor
        
        // layout
        contentView.addSubview(containerView)
        containerView.addSubview(imageContainerView)
        containerView.addSubview(details)
        let views: [String : Any] = ["containerView" : containerView,
                                     "imageContainerView" : imageContainerView,
                                     "details" : details,
                                     "imageView" : imageView]
        let metrics: [String: Any] = ["inset": 15]
        
        // container
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-inset-[containerView]-inset-|",
                                                                  options: [], metrics: metrics, views: views))
        // detailcontainer
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[details]|",
                                                                    options: [], metrics: metrics, views: views))
        // imagecontainer
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageContainerView]|",
                                                                    options: [], metrics: metrics, views: views))
        imageContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|",
                                                                         options: [], metrics: metrics, views: views))
        imageContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|",
                                                                         options: [], metrics: metrics, views: views))
        // vertical
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|",
                                                                  options: [], metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageContainerView(==200)][details(==75)]|",
                                                                    options: [], metrics: metrics, views: views))
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return defaultContentViewLayoutSizeFitting(layoutAttributes)
    }
    
}
