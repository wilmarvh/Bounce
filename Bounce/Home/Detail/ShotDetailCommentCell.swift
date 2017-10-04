import UIKit

class ShotDetailCommentCell: UICollectionViewCell, Nibloadable {
    
    static var cache: [Int: UICollectionViewLayoutAttributes] = [Int: UICollectionViewLayoutAttributes]()
    
    static let textContainerInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var leftProfileImageView: ProfileImageView!
    
    @IBOutlet weak var rightProfileImageView: ProfileImageView!

    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likesCountLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var commentId: Int = -1
    
    // MARK: Left/right author
    
    @IBOutlet weak var leftAuthor2: NSLayoutConstraint!
    @IBOutlet weak var leftAuthor1: NSLayoutConstraint!
    @IBOutlet weak var rightAuthor1: NSLayoutConstraint!
    @IBOutlet weak var rightAuthor2: NSLayoutConstraint!
    
    func setAuthorAlignment(left: Bool) {
        leftAuthor1.isActive = left
        leftAuthor2.isActive = left
        rightAuthor1.isActive = !left
        rightAuthor2.isActive = !left
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor(red:0.98039, green:0.98039, blue:0.98431, alpha:1.00000)
        backgroundView?.backgroundColor = backgroundColor
        container.backgroundColor = backgroundColor
        
        textView.backgroundColor = UIColor(red:0.93726, green:0.93726, blue:0.95686, alpha:1.00000)
        textView.textContainerInset = ShotDetailCommentCell.textContainerInsets
        textView.layer.cornerRadius = 25
        
        likeButton.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        leftProfileImageView.inset = 0
        rightProfileImageView.inset = 0
        
        configureViews()
    }
    
    func configureViews() {
        likeButton.tintColor = UIColor(red:0.78039, green:0.78039, blue:0.80000, alpha:1.00000)
        likesCountLabel.isHidden = true
        leftProfileImageView.isHidden = true
        rightProfileImageView.isHidden = true
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
                attributedText.removeAttribute(.underlineStyle, range: range)
                attributedText.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.mediumPink()], range: range)
                attributedText.addAttributes([NSAttributedStringKey.underlineColor: UIColor.mediumPink()], range: range)
            }
        })
        textView.attributedText = attributedText
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if let cacheEntry = ShotDetailCommentCell.cache[commentId] {
            return cacheEntry
        }
        let newAttributes = defaultContentViewLayoutSizeFitting(layoutAttributes)
        ShotDetailCommentCell.cache[commentId] = newAttributes
        return newAttributes
    }
    
}
