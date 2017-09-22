import UIKit
import NothingButNet

class HomeViewController: UICollectionViewController {
    
    var shots: [Shot] = [Shot]()
    
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
     
        title = "Bounce"
        configureNavigationBar()
        configureCollectionView()
        loadData()
    }
    
    // MARK: Configure view
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = navigationController?.navigationBar.barTintColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.dribbblePink()]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.dribbblePink()]
    }
    
    func configureCollectionView() {
        // cells and other
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(PopularShotCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView?.refreshControl = UIRefreshControl(frame: .zero)
        collectionView?.refreshControl?.tintColor = UIColor.dribbblePink()
        collectionView?.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        // layout
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0)
            layout.itemSize = CGSize(width: view.frame.width, height: 275)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 20
            collectionView?.collectionViewLayout = layout
        }
    }
    
    // MARK: UICollectionView DataSource / Delegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shots.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PopularShotCell
        let shot = shots[indexPath.row] as Shot
        cell.shotId = shot.id
        cell.titleLabel.text = shot.title
        Shot.loadHiDPIImage(for: shot) { [weak cell] shotId, image in
            guard cell?.shotId == shotId else {
                return
            }
            cell?.imageView.alpha = 0
            cell?.imageView.image = image
            UIViewPropertyAnimator(duration: 0.3, curve: .easeIn, animations: {
                cell?.imageView.alpha = 1
            }).startAnimation()
        }
        return cell
    }
    
    // MARK: Data
    
    @objc func refresh() {
        shots = []
        collectionView?.reloadData()
        loadData()
    }
    
    func loadData() {
        Shot.fetchPopularShots { [unowned self] shots, error in
            self.shots = shots ?? []
            self.collectionView?.reloadData()
            self.collectionView?.refreshControl?.endRefreshing()
        }
    }

}


class PopularShotCell: UICollectionViewCell {
    
    var shotId: Int = 0
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shotId = 0
        titleLabel.text = nil
        imageView.image = nil
        imageView.alpha = 0
    }
    
    // MARK: Views
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.title3Font()
        label.textColor = UIColor.bounceBlack()
        label.numberOfLines = 1
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0
        return imageView
    }()
    
    lazy var placeholderView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.bounceBlack().cgColor
        view.layer.borderWidth = 1 / UIScreen.main.scale
        view.backgroundColor = UIColor(red:0.94902, green:0.94902, blue:0.94902, alpha:1.00000)
        return view
    }()
    
    func configureViews() {
        // config
        backgroundColor = UIColor.white
        backgroundView?.backgroundColor = backgroundColor
        
        // layout
        contentView.addSubview(titleLabel)
        contentView.addSubview(placeholderView)
        placeholderView.addSubview(imageView)
        let views: [String : Any] = ["titleLabel" : titleLabel,
                                     "placeholderView" : placeholderView,
                                     "imageView" : imageView]
        let metrics: [String: Any] = ["titleLabelInset": 23,
                                      "imageViewInset": 20]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(titleLabelInset)-[titleLabel]-(titleLabelInset)-|",
                                                                  options: [], metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(imageViewInset)-[placeholderView]-(imageViewInset)-|",
                                                                  options: [], metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel]-[placeholderView]-|",
                                                                  options: [], metrics: metrics, views: views))
        placeholderView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|",
                                                                  options: [], metrics: metrics, views: views))
        placeholderView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|",
                                                                  options: [], metrics: metrics, views: views))
    }
    
}
