import UIKit
import NothingButNet
import NukeGifuPlugin
import Nuke

class ShotDetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var shot: Shot!
    
    var comments: [Comment]?
    
    var imageCell: ShotDetailImageCell!
    
    var statsCell: ShotDetailStatsCell!
    
    var textCell: ShotDetailTextCellCollectionViewCell!
    
    var tagCell: ShotDetailTagsCell!
    
    var commentsContainerCell: ShotDetailCommentsContainerCell!
    
    // MARK: Status bar

    var statusBarStyle: UIStatusBarStyle = .default
    
    var statusBarHidden: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureCloseButton()
        loadComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusBarHidden = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func updateCloseButtonTintColor(from imageView: UIImageView?) {
        // https://stackoverflow.com/a/2509596/149591
        // ((Red value * 299) + (Green value * 587) + (Blue value * 114)) / 1000
        guard let image = imageView?.image, let cgImage = image.cgImage else { return }
        DispatchQueue.global(qos: .background).async { [weak self] in
            let cropRect = CGRect(x: image.size.width - 50, y: 0, width: 50, height: 30)
            if let topRightCorner = cgImage.cropping(to: cropRect) {
                let croppedImage = UIImage(cgImage: topRightCorner)
                croppedImage.areaAverage(completion: { averageColor in
                    if let components = averageColor.rgb() {
                        let result = ((components.red * 299) + (components.green * 587) + (components.blue * 114)) / 1000
                        if result > 125 {
                            self?.closeButton.tintColor = UIColor.bounceBlack()
                            self?.statusBarStyle = .default
                        } else {
                            self?.closeButton.tintColor = UIColor.white
                            self?.statusBarStyle = .lightContent
                        }
                        self?.setNeedsStatusBarAppearanceUpdate()
                    }
                })
            }
        }
    }
    
    // MARK: Configure view
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "detailCloseButton"), for: .normal)
        button.tintColor = UIColor.grayButton()
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    func configureCollectionView() {
        // cells and other
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView?.register(ShotDetailImageCell.self, forCellWithReuseIdentifier: "ShotDetailImageCell")
        collectionView?.register(ShotDetailStatsCell.self, forCellWithReuseIdentifier: "ShotDetailStatsCell")
        collectionView?.register(ShotDetailTextCellCollectionViewCell.nib(), forCellWithReuseIdentifier: "ShotDetailTextCellCollectionViewCell")
        collectionView?.register(ShotDetailTagsCell.self, forCellWithReuseIdentifier: "ShotDetailTagsCell")
        collectionView?.register(ShotDetailCommentsContainerCell.self, forCellWithReuseIdentifier: "ShotDetailCommentsContainerCell")
        
        // layout
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(-UIApplication.shared.statusBarFrame.height, 0, 15, 0)
            layout.estimatedItemSize = CGSize(width: view.frame.width, height: 321)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            collectionView?.collectionViewLayout = layout
        }
    }
    
    func configureCloseButton() {
        let views = ["button" : closeButton]
        let metrics = ["topInset" : UIApplication.shared.statusBarFrame.height + 15]
        view.addSubview(closeButton)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[button(==44)]-15-|", options: [], metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topInset-[button(==44)]", options: [], metrics: metrics, views: views))
    }
    
    @objc func close() {
        performSegue(withIdentifier: "unwindToHomeFromShotDetail", sender: nil)
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allValus.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
            AnimatedImage.manager.loadImage(with: shot.hidpiImageURL(), into: imageCell.imageView, handler: { [weak self] result, cache in
                self?.imageCell?.imageView.handle(response: result, isFromMemoryCache: cache)
            })
        }
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
        if commentsContainerCell == nil {
            commentsContainerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShotDetailCommentsContainerCell", for: indexPath) as! ShotDetailCommentsContainerCell
            commentsContainerCell.shot = shot
            commentsCollectionViewController.willMove(toParentViewController: self)
            commentsContainerCell.collectionView = commentsCollectionViewController.collectionView
            commentsCollectionViewController.didMove(toParentViewController: self)
            commentsCollectionViewController.comments = self.comments ?? []
        }
        return commentsContainerCell
    }
    
    lazy var commentsCollectionViewController: ShotCommentsViewController = {
        // ugh to some of the worst hacks ever
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ShotCommentsViewController") as! ShotCommentsViewController
        return controller
    }()
    
    // MARK: Data
    
    func reload() {
        statsCell = nil
        tagCell = nil
        textCell = nil
        commentsContainerCell = nil
        collectionView?.reloadData()
    }
    
    func loadComments() {
        Comment.fetch(for: shot) { [weak self] comments, error in
            self?.commentsContainerCell = nil
            self?.comments = comments
            self?.reload()
//            self?.performSegue(withIdentifier: "showComments", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showComments", let controller = segue.destination as? ShotCommentsViewController {
            controller.comments = comments ?? []
        }
    }
    
}
