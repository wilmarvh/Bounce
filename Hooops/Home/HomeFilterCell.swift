import Foundation
import UIKit

class HomeFilterCell: UICollectionViewCell {
    static let width: CGFloat = 130
    static let height: CGFloat = 32
    
    // MARK:
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    // MARK: Views
    
    lazy var button: FilterButton = {
        let button = FilterButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = HomeFilterCell.height / 2
        button.backgroundColor = UIColor.grayButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.darkBlueGrey(), for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(.white, for: .selected)
        return button
    }()
    
    func configureViews() {
        contentView.addSubview(button)
        contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: HomeFilterCell.height))
        contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1.0, constant: 0))
    }
    
}

class FilterButton: UIButton {
    
    var action: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.hooopsGreen() : UIColor.grayButton()
        }
    }
    
    @objc func tapped() {
        if let action = action {
            action()
        }
    }
    
}
