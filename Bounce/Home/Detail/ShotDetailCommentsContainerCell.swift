import UIKit
import NothingButNet
import SwiftRichString

class ShotDetailCommentsContainerCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var shot: Shot!
    
    var comments: [Comment] = [Comment]() {
        didSet {
            collectionView.reloadData()
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
    
    // MARK: View
    
    lazy var container: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.98039, green:0.98039, blue:0.98431, alpha:1.00000)
        return view
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: self.frame.width, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = self.container.backgroundColor
        collectionView.backgroundView?.backgroundColor = self.container.backgroundColor
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "CommentCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.register(ShotDetailCommentCell.nib(), forCellWithReuseIdentifier: "ShotDetailCommentCell")
        return collectionView
    }()
    
    func configureViews() {
        contentView.addSubview(container)
        container.addSubview(collectionView)
        
        let views = [
            "container": container,
            "collectionView": collectionView
        ]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]|", options: [], metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: views))
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.removeAllBorderLayers()
        contentView.layer.addTopBorder(inset: 0)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = collectionView.collectionViewLayout.collectionViewContentSize.height
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
    // MARK: CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShotDetailCommentCell", for: indexPath) as! ShotDetailCommentCell
        let comment = comments[indexPath.row]
        cell.textView.attributedText = comment.combinedDescription()
        cell.updateStringFormatting()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = comments[indexPath.row].combinedDescription()
        let insets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let width = collectionView.frame.width - insets.left - insets.right
        let size = TextSize.size(text, width: width)
        let height = size.height + ShotDetailCommentCell.textContainerInsets.top + ShotDetailCommentCell.textContainerInsets.bottom
        return CGSize(width: size.width, height: height)
    }
}

extension Comment {
    
    func combinedDescription() -> NSAttributedString {
        let text = body.trimmingCharacters(in: .whitespacesAndNewlines)
        if let data = text.data(using: .utf8) {
            let attributedString = NSMutableAttributedString()
            
            // username
            let userStyle = Style("user", {
                let font = UIFont.systemFont(ofSize: 15, weight: .regular)
                $0.font = FontAttribute(font.fontName, size: Float(font.pointSize))
                $0.kern = Float(-0.4)
                $0.color = UIColor(red: 143/255.0, green: 142/255.0, blue: 148/255.0, alpha: 1.0)
            })
            attributedString.append(string: user.username + "\n", style: userStyle)
            
            let attributedComment = try! NSMutableAttributedString(data: data,
                                                                options: [.documentType: NSAttributedString.DocumentType.html,
                                                                          .characterEncoding: String.Encoding.utf8.rawValue],
                                                                documentAttributes: nil).trailingNewlineChopped()
            // comment body
            let commentStyle = Style("comment", {
                let font = UIFont.systemFont(ofSize: 17, weight: .regular)
                $0.font = FontAttribute(font.fontName, size: Float(font.pointSize))
                $0.kern = Float(-0.4)
                $0.color = .black
            })
            _ = attributedComment.add(style: commentStyle)
            attributedString.append(attributedComment)
            
            return attributedString
        }
        return NSAttributedString()
    }
    
}


fileprivate class CommentCell: UICollectionViewCell {
    
    // MARK: Lifecycles
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureViews()
    }
    
    // MARK: Views
    
    static let font: UIFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    
    lazy var container: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = CommentCell.font
        label.textAlignment = .left
        label.textColor = UIColor.mediumPink()
        return label
    }()
    
    func configureViews() {
        contentView.addSubview(container)
        container.addSubview(label)
        
        let views = [
            "container": container,
            "label": label
        ]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]|", options: [], metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: views))
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return defaultContentViewLayoutSizeFitting(layoutAttributes)
    }
}
