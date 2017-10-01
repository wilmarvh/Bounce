import UIKit

class ShotDetailCommentCell: UICollectionViewCell, Nibloadable {
    
    static let textContainerInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundView?.backgroundColor = .cyan
        backgroundColor = UIColor(red:0.98039, green:0.98039, blue:0.98431, alpha:1.00000)
        
        textView.backgroundColor = UIColor(red:0.93726, green:0.93726, blue:0.95686, alpha:1.00000)
        textView.textContainerInset = ShotDetailCommentCell.textContainerInsets
    }
    
    // MARK: Views

    @IBOutlet weak var textView: UITextView!
    
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
        
        textView.layer.cornerRadius = min(textView.frame.height / 2, 30)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return defaultContentViewLayoutSizeFitting(layoutAttributes)
    }
    
}
