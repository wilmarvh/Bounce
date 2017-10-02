import UIKit

class ShotDetailCommentCell: UICollectionViewCell, Nibloadable {
    
    static let textContainerInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var profileImage: ProfileImageView!

    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likesCountLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor(red:0.98039, green:0.98039, blue:0.98431, alpha:1.00000)
        
        textView.backgroundColor = UIColor(red:0.93726, green:0.93726, blue:0.95686, alpha:1.00000)
        textView.textContainerInset = ShotDetailCommentCell.textContainerInsets
        
        likeButton.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        profileImage.inset = 0
        
        configureViews()
    }
    
    func configureViews() {
        likeButton.tintColor = UIColor(red:0.78039, green:0.78039, blue:0.80000, alpha:1.00000)
        likesCountLabel.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureViews()
    }
    
    // MARK: Views

    func updateStringFormatting() {
        guard let a = textView.attributedText else { return }
        
        let attributedText = NSMutableAttributedString(attributedString: a)
        attributedText.enumerateAttribute(.link, in: attributedText.string.nsRange(from: nil), options: [], using: { value, range, stop in
            if let _ = value {
                attributedText.removeAttribute(.link, range: range)
                attributedText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.mediumPink()], range: range)
                attributedText.addAttributes([NSAttributedStringKey.underlineColor: UIColor.mediumPink()], range: range)
            }
        })
        textView.attributedText = attributedText
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.layer.cornerRadius = 25// min(textView.frame.height / 2, 30)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return defaultContentViewLayoutSizeFitting(layoutAttributes)
    }
    
}
