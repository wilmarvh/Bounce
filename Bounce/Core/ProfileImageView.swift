import UIKit
import Nuke

class ProfileImageView: UIView, Nuke.Target {
    
    var inset: CGFloat = 3 {
        didSet {
            configureViews()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    // MARK: Lifecycle
    
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
        
        imageView.removeFromSuperview()
        addSubview(imageView)
        imageView.clipsToBounds = true
        
        let views = ["imageView" : imageView]
        let metrics = ["inset" : inset]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(inset)-[imageView]-(inset)-|", options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(inset)-[imageView]-(inset)-|", options: [], metrics: metrics, views: views))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    // MARK: Nuke
    
    func handle(response: Result<Image>, isFromMemoryCache: Bool) {
        imageView.image = response.value ?? UIImage(named: "profile")
    }
    
}
