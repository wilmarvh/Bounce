import UIKit
import Foundation

class ShotDetailTextCellCollectionViewCell: UICollectionViewCell, Nibloadable {
    
    var profileId: Int = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        
        byLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        byLabel.textColor = UIColor(red:0.56078, green:0.55686, blue:0.57647, alpha:1.00000)
        dateLabel.font = byLabel.font
        dateLabel.textColor = byLabel.textColor
        
        profileButton.setTitleColor(UIColor.mediumPink(), for: .normal)
        profileButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        descriptionLabel.textColor = UIColor(red:0.41569, green:0.41177, blue:0.43529, alpha:1.00000)
        descriptionLabel.textAlignment = .left
    }
    
    func setDescriptionText(_ string: String?) {
        if let string = string, let data = string.data(using: .utf8) {
            do {
                let text = try NSAttributedString(data: data,
                                                  options: [.documentType: NSAttributedString.DocumentType.html,
                                                                        .characterEncoding: String.Encoding.utf8.rawValue],
                                                  documentAttributes: nil).string
                descriptionLabel.text = text
            } catch {
                descriptionLabel.text = string
            }
        }
    }
    
    // MARK: Height
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return defaultContentViewLayoutSizeFitting(layoutAttributes)
    }
    
}
