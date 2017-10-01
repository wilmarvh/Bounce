import UIKit
import Foundation
import SwiftRichString

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
        titleLabel.text = nil
        
        byLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        byLabel.textColor = UIColor(red:0.56078, green:0.55686, blue:0.57647, alpha:1.00000)
        dateLabel.font = byLabel.font
        dateLabel.textColor = byLabel.textColor
        dateLabel.text = nil
        
        profileButton.setTitleColor(UIColor.mediumPink(), for: .normal)
        profileButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        profileButton.setTitle(nil, for: .normal)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        descriptionLabel.textColor = UIColor(red:0.41569, green:0.41177, blue:0.43529, alpha:1.00000)
        descriptionLabel.textAlignment = .left
        descriptionLabel.text = nil
    }
    
    func setDescriptionText(_ string: String?) {
        if let string = string, let data = string.data(using: .utf8) {
            do {
                let attributedText = try NSMutableAttributedString(data: data,
                                                            options: [.documentType: NSAttributedString.DocumentType.html,
                                                                      .characterEncoding: String.Encoding.utf8.rawValue],
                                                            documentAttributes: nil)
                let style_normal = Style("normal", {
                    $0.font = FontAttribute(descriptionLabel.font.fontName, size: Float(descriptionLabel.font.pointSize))
                    $0.kern = Float(-0.4)
                    $0.color = descriptionLabel.textColor
                })
                _ = attributedText.add(style: style_normal)
                attributedText.enumerateAttribute(.link, in: attributedText.string.nsRange(from: nil), options: [], using: { value, range, stop in
                    if let _ = value {
                        attributedText.removeAttribute(.link, range: range)
                        attributedText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.mediumPink()], range: range)
                        attributedText.addAttributes([NSAttributedStringKey.underlineColor: UIColor.mediumPink()], range: range)
                    }
                })
                descriptionLabel.attributedText = attributedText
            } catch {
                descriptionLabel.text = string
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.removeAllBorderLayers()
        contentView.layer.addTopBorder(inset: 0)
    }
    
    // MARK: Height
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return defaultContentViewLayoutSizeFitting(layoutAttributes)
    }
    
}
