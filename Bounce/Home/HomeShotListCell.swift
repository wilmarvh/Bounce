import UIKit
import NukeGifuPlugin

class HomeShotListCell: UICollectionViewCell {
    
    var imageContainerViewHeightConstraint: NSLayoutConstraint?
    
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
        imageView.imageView.image = nil
        gifLabelImageView.isHidden = true
    }
    
    // MARK: Views
    
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addDefaultShadow()
        return view
    }()
    
    lazy var details: HomeShotListCellDetailsContainerView = {
        let owner = HomeShotListCellDetailsContainerView()
        let view = HomeShotListCellDetailsContainerView.viewFromNib(owner: owner) as! HomeShotListCellDetailsContainerView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    lazy var imageView: AnimatedImageView = {
        let view = AnimatedImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.imageView.contentMode = view.contentMode
        view.clipsToBounds = true
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
        gifLabelImageView.tintColor = UIColor.white
        
        // layout
        contentView.addSubview(containerView)
        containerView.addSubview(imageContainerView)
        containerView.addSubview(details)
        let views: [String : Any] = ["containerView" : containerView,
                                     "imageContainerView" : imageContainerView,
                                     "details" : details,
                                     "gifLabelImageView" : gifLabelImageView,
                                     "imageView" : imageView]
        let metrics: [String: Any] = ["inset": 0]
        
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
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageContainerView][details(==50)]|", options: [], metrics: metrics, views: views))
        imageContainerViewHeightConstraint = NSLayoutConstraint(item: imageContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200)
        containerView.addConstraint(imageContainerViewHeightConstraint!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // https://stackoverflow.com/a/2509596/149591
        // ((Red value * 299) + (Green value * 587) + (Blue value * 114)) / 1000
        if gifLabelImageView.isHidden == false {
            if let image = imageView.imageView.image, let cgImage = image.cgImage {
                DispatchQueue.global(qos: .background).async { [weak self] in
                    let cropRect = CGRect(x: image.size.width - 50, y: 0, width: 50, height: 30)
                    if let topRightCorner = cgImage.cropping(to: cropRect) {
                        let croppedImage = UIImage(cgImage: topRightCorner)
                        croppedImage.areaAverage(completion: { averageColor in
                            if let components = averageColor.rgb() {
                                let result = ((components.red * 299) + (components.green * 587) + (components.blue * 114)) / 1000
                                if result > 125 {
                                    self?.gifLabelImageView.tintColor = UIColor.bounceBlack()
                                } else {
                                    self?.gifLabelImageView.tintColor = UIColor.white
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    func updateViews(`for` layout: UICollectionViewLayout) {
        details.isHidden = layout is HomeViewGridLayout
        containerView.addSmallShadow()
        
        if layout is HomeViewGridLayout {
            imageContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            imageContainerViewHeightConstraint?.constant = 140
            gifLabelImageView.isHidden = true
        } else {
            imageContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            imageContainerViewHeightConstraint?.constant = 200
            // gifLabelImageView.isHidden = true // don't change the value here, it's already being set in cellForRow in HomeViewController
            // it shouldn't be overwritten for the list layout
        }
    }
    
    override func willTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
        super.willTransition(from: oldLayout, to: newLayout)
        updateViews(for: newLayout)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return defaultContentViewLayoutSizeFitting(layoutAttributes)
    }
    
}
