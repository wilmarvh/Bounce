import UIKit

class ProfileImageView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    // MARK: Views
    
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func configureViews() {
        layer.borderColor = UIColor.grayButton().cgColor
        layer.borderWidth = 1
        
        addSubview(imageView)
        imageView.clipsToBounds = true
        
        let views = ["imageView" : imageView]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-3-[imageView]-3-|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[imageView]-3-|", options: [], metrics: nil, views: views))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
}
