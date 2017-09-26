import UIKit
import NothingButNet

class ShotDetailViewController: UICollectionViewController {
    
    var shot: Shot!
    
    var statusBarStyle: UIStatusBarStyle = .default
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureCloseButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    func updateCloseButtonTintColor(from imageView: UIImageView?) {
        // https://stackoverflow.com/a/2509596/149591
        // ((Red value * 299) + (Green value * 587) + (Blue value * 114)) / 1000
        guard let image = imageView?.image, let cgImage = image.cgImage else { return }
        let cropRect = CGRect(x: image.size.width - 50, y: 0, width: 50, height: 30)
        if let topRightCorner = cgImage.cropping(to: cropRect) {
            let croppedImage = UIImage(cgImage: topRightCorner)
            let averageColor = croppedImage.areaAverage()
            if let components = averageColor.rgb() {
                let result = ((components.red * 299) + (components.green * 587) + (components.blue * 114)) / 1000
                if result > 125 {
                    closeButton.tintColor = UIColor.bounceBlack()
                    statusBarStyle = .default
                } else {
                    closeButton.tintColor = UIColor.white
                    statusBarStyle = .lightContent
                }
                setNeedsStatusBarAppearanceUpdate()
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
        
        // layout
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(-UIApplication.shared.statusBarFrame.height, 0, 15, 0)
            layout.estimatedItemSize = CGSize(width: view.frame.width, height: 311)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            collectionView?.collectionViewLayout = layout
        }
    }
    
    func configureCloseButton() {
        let views = ["button" : closeButton]
        let metrics = ["topInset" : UIApplication.shared.statusBarFrame.height + 15]
        view.addSubview(closeButton)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[button(==29)]-15-|", options: [], metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topInset-[button(==29)]", options: [], metrics: metrics, views: views))
    }
    
    @objc func close() {
        performSegue(withIdentifier: "unwindToHomeFromShotDetail", sender: nil)
    }
    
    // MARK: UICollectionView DataSource / Delegate
    
    enum DetailSection: Int {
        case image = 0
        case stats = 1
        case text = 2
        case comments = 3
        
        static let allValus: [DetailSection] = [.image, .stats, .text, .comments]
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DetailSection.allValus.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = DetailSection(rawValue: indexPath.section)!
        switch section {
        case .image:
            return configureImageCell(collectionView, cellForItemAt: indexPath)
        case .stats:
            return configureStatsCell(collectionView, cellForItemAt: indexPath)
        case .text:
            return configureTextCell(collectionView, cellForItemAt: indexPath)
        case .comments:
            return configureCommentsCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func configureImageCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShotDetailImageCell", for: indexPath) as! ShotDetailImageCell
        cell.shotId = shot.id
        cell.imageView.image = shot.anyImageFromCache()
        Shot.loadImage(for: shot) { [weak cell, weak self] shotId, image in
            guard cell?.shotId == shotId else { return }
            cell?.imageView.image = image
            cell?.imageView.alpha = 1
            self?.updateCloseButtonTintColor(from: cell?.imageView)
        }
        return cell
    }
    
    func configureStatsCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShotDetailStatsCell", for: indexPath) as! ShotDetailStatsCell
        cell.likesLabel.text = Localization.integerFormatter.string(from: NSNumber(integerLiteral: shot.likes_count))
        cell.commentsLabel.text = Localization.integerFormatter.string(from: NSNumber(integerLiteral: shot.comments_count))
        cell.viewsLabel.text = Localization.integerFormatter.string(from: NSNumber(integerLiteral: shot.views_count))
        cell.bucketsLabel.text = Localization.integerFormatter.string(from: NSNumber(integerLiteral: shot.buckets_count))
        return cell
    }
    
    func configureTextCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShotDetailTextCellCollectionViewCell", for: indexPath) as! ShotDetailTextCellCollectionViewCell
        cell.profileId = shot.id
        cell.titleLabel.text = shot.title
        cell.profileButton.setTitle(shot.team?.name ?? shot.user.username, for: .normal)
        cell.dateLabel.text = "on " + Localization.shortFullFormatter.string(from: shot.created_at)
        cell.setDescriptionText(shot.description)
        Shot.loadProfileImage(for: shot) { [weak cell] shotId, image in
            guard cell?.profileId == shotId else { return }
            cell?.profileImageView.imageView.image = image
        }
        return cell
    }
    
    func configureCommentsCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = .magenta
        return cell
    }
    
}
