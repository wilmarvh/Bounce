import UIKit
import NothingButNet
import SwiftRichString
import Nuke

class ShotCommentsViewController: UICollectionViewController {
    
    // MARK: Properties
    
    var comments: [Comment] = [Comment]() {
        didSet {
            collectionView?.reloadData()
            debugPrint("contentSize: \(NSStringFromCGSize(collectionView?.contentSize ?? .zero))")
            debugPrint("collectionViewContentSize: \(NSStringFromCGSize(collectionView?.collectionViewLayout.collectionViewContentSize ?? .zero))")
        }
    }
    
    var commentDescriptions: [Int: NSAttributedString] = [Int: NSAttributedString]()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Views
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let width = view.frame.width - layout.sectionInset.left - layout.sectionInset.right
        layout.estimatedItemSize = CGSize(width: width, height: 150)
        layout.minimumLineSpacing = 35
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        return layout
    }()
    
    func configureCollectionView() {
        collectionView?.isScrollEnabled = true
        collectionView?.backgroundColor = UIColor(red:0.98039, green:0.98039, blue:0.98431, alpha:1.00000)
        collectionView?.backgroundView?.backgroundColor = collectionView?.backgroundColor
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView?.register(ShotDetailCommentCell.nib(), forCellWithReuseIdentifier: "ShotDetailCommentCell")
        collectionView?.collectionViewLayout = self.layout
    }
    
    // MARK: CollectionView
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShotDetailCommentCell", for: indexPath) as! ShotDetailCommentCell
        let comment = comments[indexPath.row]
        cell.textView.attributedText = combinedDescription(at: indexPath)
        cell.likesCountLabel.text = Localization.integerFormatter.string(from: NSNumber(integerLiteral: comment.likes_count))
        if comment.likes_count > 0 {
            cell.likesCountLabel.isHidden = false
            cell.likeButton.tintColor = UIColor.hooopsGreen()
        }
        cell.dateLabel.text = Localization.relativeTimeFormatter.string(from: comment.created_at)
        cell.dateLabel.text = comment.created_at.timeAgoSinceNow
        cell.updateStringFormatting()
        Nuke.loadImage(with: comment.user.avatarURL, into: cell.leftProfileImageView.imageView)
        return cell
    }
    
    func combinedDescription(at indexPath: IndexPath) -> NSAttributedString {
        let comment = comments[indexPath.row]
        if let combinedDescription = commentDescriptions[comment.id] {
            return combinedDescription
        }
        let combinedDescription = comment.combinedDescription()
        commentDescriptions[comment.id] = combinedDescription
        return combinedDescription
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
                $0.backColor = UIColor(red:0.93726, green:0.93726, blue:0.95686, alpha:1.00000)
            })
            attributedString.append(string: user.username + "\n", style: userStyle)
            
            if let attributedComment = try? NSMutableAttributedString(data: data,
                                                                      options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                .characterEncoding: String.Encoding.utf8.rawValue],
                                                                      documentAttributes: nil).trailingNewlineChopped() {
                // comment body
                let commentStyle = Style("comment", {
                    let font = UIFont.systemFont(ofSize: 17, weight: .regular)
                    $0.font = FontAttribute(font.fontName, size: Float(font.pointSize))
                    $0.kern = Float(-0.4)
                    $0.color = UIColor.darkBlueGrey()
                    $0.backColor = UIColor(red:0.93726, green:0.93726, blue:0.95686, alpha:1.00000)
                })
                _ = attributedComment.add(style: commentStyle)
                attributedString.append(attributedComment)
            }
            return attributedString
        }
        return NSAttributedString()
    }
    
}
