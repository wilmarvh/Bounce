import UIKit

class HomeShotCell: UICollectionViewCell {
    
    var shotId: Int = 0
    
    var profileId: Int = 0
    
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
        profileId = 0
        imageView.image = nil
        imageView.alpha = 0
        gifLabelImageView.isHidden = true
    }
    
    // MARK: Views
    
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addDefaultShadow()
        return view
    }()
    
    lazy var details: HomeShotCellDetailsContainerView = {
        let owner = HomeShotCellDetailsContainerView()
        let view = HomeShotCellDetailsContainerView.viewFromNib(owner: owner) as! HomeShotCellDetailsContainerView
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
    
    lazy var gifLabelImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "gif")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40))
        view.isHidden = true
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
        view.addSubview(self.gifLabelImageView)
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
                                     "gifLabelImageView" : gifLabelImageView,
                                     "imageView" : imageView]
        let metrics: [String: Any] = ["inset": 15]
        
        // container
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-inset-[containerView]-inset-|", options: [], metrics: metrics, views: views))
        // detailcontainer
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[details]|", options: [], metrics: metrics, views: views))
        // imagecontainer
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageContainerView]|", options: [], metrics: metrics, views: views))
        imageContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: [], metrics: metrics, views: views))
        imageContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: [], metrics: metrics, views: views))
        imageContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[gifLabelImageView]-10-|", options: [], metrics: metrics, views: views))
        imageContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[gifLabelImageView]", options: [], metrics: metrics, views: views))
        // vertical
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageContainerView(==200)][details(==75)]|", options: [], metrics: metrics, views: views))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // https://stackoverflow.com/a/2509596/149591
        // ((Red value * 299) + (Green value * 587) + (Blue value * 114)) / 1000
        if gifLabelImageView.isHidden == false {
            if let image = imageView.image, let cgImage = image.cgImage {
                let cropRect = CGRect(x: image.size.width - 50, y: 0, width: 50, height: 30)
                if let topRightCorner = cgImage.cropping(to: cropRect) {
                    let croppedImage = UIImage(cgImage: topRightCorner)
                    let averageColor = croppedImage.areaAverage()
                    if let components = averageColor.rgb() {
                        let result = ((components.red * 299) + (components.green * 587) + (components.blue * 114)) / 1000
                        if result > 125 {
                            gifLabelImageView.tintColor = UIColor.bounceBlack()
                        } else {
                            gifLabelImageView.tintColor = UIColor.white
                        }
                    }
                }
            }
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return defaultContentViewLayoutSizeFitting(layoutAttributes)
    }
    
}
