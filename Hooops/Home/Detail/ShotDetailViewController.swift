import UIKit
import DeckTransition
import NothingButNet
import NukeGifuPlugin
import Nuke

class ShotDetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var shot: Shot!
    
    var comments: [Comment]?
    
    var commentDescriptions: [Int: NSAttributedString] = [Int: NSAttributedString]()
    
    var imageCell: ShotDetailImageCell!
    
    var statsCell: ShotDetailStatsCell!
    
    var textCell: ShotDetailTextCellCollectionViewCell!
    
    var tagCell: ShotDetailTagsCell!
    
    // MARK: Status bar

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        loadComments()
    }
    
    // MARK: Configure view
    
    func configureCollectionView() {
        // cells and other
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ShotDetailImageCell.self, forCellWithReuseIdentifier: "ShotDetailImageCell")
        collectionView?.register(ShotDetailStatsCell.self, forCellWithReuseIdentifier: "ShotDetailStatsCell")
        collectionView?.register(ShotDetailTextCellCollectionViewCell.nib(), forCellWithReuseIdentifier: "ShotDetailTextCellCollectionViewCell")
        collectionView?.register(ShotDetailTagsCell.self, forCellWithReuseIdentifier: "ShotDetailTagsCell")
        collectionView?.register(ShotDetailCommentCell.nib(), forCellWithReuseIdentifier: "ShotDetailCommentCell")
        
        // layout
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: collectionView?.frame.width ?? view.frame.width, height: 321)
            collectionView?.collectionViewLayout = layout
        }
    }
    
    // MARK: UICollectionView DataSource / Delegate
    
    private enum Section: Int {
        case image = 0
        case stats = 1
        case text = 2
        case tags = 3
        case comments = 4
        
        static let allValus: [Section] = [.image, .stats, .text, .tags, .comments]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = Section(rawValue: section)!
        switch section {
        case .image:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        case .stats:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        case .text:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        case .tags:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        case .comments:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allValus.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Section(rawValue: section)! == .comments {
            return comments?.count ?? 0
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .image:
            return configureImageCell(collectionView, cellForItemAt: indexPath)
        case .stats:
            return configureStatsCell(collectionView, cellForItemAt: indexPath)
        case .text:
            return configureTextCell(collectionView, cellForItemAt: indexPath)
        case .tags:
            return configureTagsCell(collectionView, cellForItemAt: indexPath)
        case .comments:
            return configureCommentsCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func configureImageCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if imageCell == nil {
            imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShotDetailImageCell", for: indexPath) as! ShotDetailImageCell
        }
        imageCell.imageView.prepareForReuse()
        AnimatedImage.manager.loadImage(with: shot.hidpiImageURL(), into: imageCell.imageView, handler: { [weak self] result, cache in
            self?.imageCell?.imageView.handle(response: result, isFromMemoryCache: cache)
        })
        return imageCell
    }
    
    func configureStatsCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if statsCell == nil {
            statsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShotDetailStatsCell", for: indexPath) as! ShotDetailStatsCell
            statsCell.likesLabel.text = Localization.integerFormatter.string(from: NSNumber(integerLiteral: shot.likes_count))
            statsCell.commentsLabel.text = Localization.integerFormatter.string(from: NSNumber(integerLiteral: shot.comments_count))
            statsCell.viewsLabel.text = Localization.integerFormatter.string(from: NSNumber(integerLiteral: shot.views_count))
            statsCell.bucketsLabel.text = Localization.integerFormatter.string(from: NSNumber(integerLiteral: shot.buckets_count))
        }
        return statsCell
    }
    
    func configureTextCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if textCell == nil {
            textCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShotDetailTextCellCollectionViewCell", for: indexPath) as! ShotDetailTextCellCollectionViewCell
            textCell.profileId = shot.id
            textCell.titleLabel.text = shot.title
            textCell.profileButton.setTitle(shot.team?.name ?? shot.user.username, for: .normal)
            textCell.dateLabel.text = "on " + Localization.shortFullFormatter.string(from: shot.created_at)
            textCell.setDescriptionText(shot.description)
            Nuke.loadImage(with: shot.profileImageURL(), into: textCell.profileImageView)
        }
        return textCell
    }
    
    func configureTagsCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if tagCell == nil {
            tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShotDetailTagsCell", for: indexPath) as! ShotDetailTagsCell
            tagCell.tags = shot.tags
        }
        return tagCell
    }
    
    func configureCommentsCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShotDetailCommentCell", for: indexPath) as! ShotDetailCommentCell
        if let comment = comments?[indexPath.row] {
            cell.commentId = comment.id
            cell.textView.attributedText = combinedDescription(at: indexPath)
            cell.likesCountLabel.text = Localization.integerFormatter.string(from: NSNumber(integerLiteral: comment.likes_count))
            if comment.likes_count > 0 {
                cell.likesCountLabel.isHidden = false
            }
//            cell.dateLabel.text = Localization.relativeTimeFormatter.string(from: comment.created_at)
            cell.dateLabel.text = comment.created_at.shortTimeAgoSinceNow + " ago"
            cell.updateStringFormatting()
            let imageView = shot.user.id == comment.user.id ? cell.rightProfileImageView.imageView : cell.leftProfileImageView.imageView
            Nuke.loadImage(with: comment.user.avatarURL, into: imageView)
            cell.leftProfileImageView.isHidden = comment.user.id == shot.user.id
            cell.rightProfileImageView.isHidden = comment.user.id != shot.user.id
            cell.setAuthorAlignment(left: comment.user.id != shot.user.id)
        }
        return cell
    }
    
    func combinedDescription(at indexPath: IndexPath) -> NSAttributedString {
        if let comment = comments?[indexPath.row] {
            if let combinedDescription = commentDescriptions[comment.id] {
                return combinedDescription
            }
            let combinedDescription = comment.combinedDescription()
            commentDescriptions[comment.id] = combinedDescription
            return combinedDescription
        }
        return NSAttributedString()
    }
    
    // MARK: Data
    
    func reload() {
        statsCell = nil
        tagCell = nil
        textCell = nil
        collectionView?.reloadData()
    }
    
    func loadComments() {
        Comment.fetch(for: shot) { [weak self] comments, error in
            self?.comments = comments
            self?.reload()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showComments", let controller = segue.destination as? ShotCommentsViewController {
            controller.comments = comments ?? []
        }
    }
    
    // MARK: ScrollView
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isEqual(collectionView) else {
            return
        }
        
        if let delegate = transitioningDelegate as? DeckTransitioningDelegate {
            if scrollView.contentOffset.y > 0 {
                // Normal behaviour if the `scrollView` isn't scrolled to the top
                scrollView.bounces = true
                delegate.isDismissEnabled = false
            } else {
                if scrollView.isDecelerating {
                    // If the `scrollView` is scrolled to the top but is decelerating
                    // that means a swipe has been performed. The view and
                    // scrollviewʼs subviews are both translated in response to this.
                    view.transform = CGAffineTransform(translationX: 0, y: -scrollView.contentOffset.y)
                    scrollView.subviews.forEach {
                        $0.transform = CGAffineTransform(translationX: 0, y: scrollView.contentOffset.y)
                    }
                } else {
                    // If the user has panned to the top, the scrollview doesnʼt bounce and
                    // the dismiss gesture is enabled.
                    scrollView.bounces = false
                    delegate.isDismissEnabled = true
                }
            }
        }
    }
    
}
