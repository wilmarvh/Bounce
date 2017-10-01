import UIKit

class ShotDetailStatsCell: UICollectionViewCell {
    
    var inset: CGFloat {
        return round(contentView.frame.width * 0.09)
    }
    
    // MARK: Lifecycles
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    // MARK: Views
    
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(self.imagesStackView)
        view.addSubview(self.likesLabel)
        view.addSubview(self.commentsLabel)
        view.addSubview(self.viewsLabel)
        view.addSubview(self.bucketsLabel)
        return view
    }()
    
    func newImageView(_ imageName: String) -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: imageName)
        return imageView
    }
    
    lazy var imagesStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillEqually
        view.spacing = round((self.contentView.frame.width - (inset * 2) - (25 * 4)) / 3) // 25 * 4 is 25 width for each image (4 images)
        view.addArrangedSubview(self.newImageView("detailLikes"))
        view.addArrangedSubview(self.newImageView("detailComments"))
        view.addArrangedSubview(self.newImageView("detailViews"))
        view.addArrangedSubview(self.newImageView("detailBuckets"))
        return view
    }()
    
    func newLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(red:0.78039, green:0.78039, blue:0.80392, alpha:1.00000)
        return label
    }
    
    lazy var likesLabel: UILabel = {
        let label = self.newLabel()
        return label
    }()
    
    lazy var commentsLabel: UILabel = {
        let label = self.newLabel()
        return label
    }()
    
    lazy var viewsLabel: UILabel = {
        let label = self.newLabel()
        return label
    }()
    
    lazy var bucketsLabel: UILabel = {
        let label = self.newLabel()
        return label
    }()
    
    func configureViews() {
        contentView.addSubview(containerView)
        let views = ["containerView" : containerView,
                     "imagesStackView" : imagesStackView
        ]
        let metrics = ["inset" : inset
        ]
        
        //
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [], metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-inset-[imagesStackView]-inset-|", options: [], metrics: metrics, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[imagesStackView(==25)]", options: [], metrics: metrics, views: views))
        // likeslabel
        containerView.addConstraint(NSLayoutConstraint(item: likesLabel, attribute: .centerX, relatedBy: .equal, toItem: imagesStackView.arrangedSubviews[0], attribute: .centerX, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: likesLabel, attribute: .top, relatedBy: .equal, toItem: imagesStackView.arrangedSubviews[0], attribute: .bottom, multiplier: 1.0, constant: 5))
        containerView.addConstraint(NSLayoutConstraint(item: likesLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
        // commentslabel
        containerView.addConstraint(NSLayoutConstraint(item: commentsLabel, attribute: .centerX, relatedBy: .equal, toItem: imagesStackView.arrangedSubviews[1], attribute: .centerX, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: commentsLabel, attribute: .top, relatedBy: .equal, toItem: imagesStackView.arrangedSubviews[1], attribute: .bottom, multiplier: 1.0, constant: 5))
        containerView.addConstraint(NSLayoutConstraint(item: commentsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
        // viewslabel
        containerView.addConstraint(NSLayoutConstraint(item: viewsLabel, attribute: .centerX, relatedBy: .equal, toItem: imagesStackView.arrangedSubviews[2], attribute: .centerX, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: viewsLabel, attribute: .top, relatedBy: .equal, toItem: imagesStackView.arrangedSubviews[2], attribute: .bottom, multiplier: 1.0, constant: 5))
        containerView.addConstraint(NSLayoutConstraint(item: viewsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
        // bucketslabel
        containerView.addConstraint(NSLayoutConstraint(item: bucketsLabel, attribute: .centerX, relatedBy: .equal, toItem: imagesStackView.arrangedSubviews[3], attribute: .centerX, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: bucketsLabel, attribute: .top, relatedBy: .equal, toItem: imagesStackView.arrangedSubviews[3], attribute: .bottom, multiplier: 1.0, constant: 5))
        containerView.addConstraint(NSLayoutConstraint(item: bucketsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = 80
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
}

