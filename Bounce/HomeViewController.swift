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
        navigationController?.navigationBar.barTintColor = UIColor.dribbblePink()
        navigationController?.navigationBar.tintColor = navigationController?.navigationBar.barTintColor
    }
    
    func configureCollectionView() {
        // cells and other
        collectionView?.backgroundColor = UIColor.bounceBlack()
        collectionView?.register(PopularShotCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView?.refreshControl = UIRefreshControl(frame: .zero)
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
        cell.titleLabel.text = shot.title
        Shot.loadNormalImage(for: shot) { [weak cell] image in
            cell?.imageView.image = image
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
        titleLabel.text = nil
        imageView.image = nil
    }
    
    // MARK: Views
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.title3Font()
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    func configureViews() {
        // config
        backgroundColor = UIColor.bounceBlack()
        backgroundView?.backgroundColor = backgroundColor
        
        // layout
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        let views: [String : Any] = ["titleLabel" : titleLabel,
                                     "imageView" : imageView]
        let metrics: [String: Any] = ["titleLabelInset": 23,
                                      "imageViewInset": 20]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(titleLabelInset)-[titleLabel]-(titleLabelInset)-|",
                                                                  options: [], metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(imageViewInset)-[imageView]-(imageViewInset)-|",
                                                                  options: [], metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel]-[imageView]-|",
                                                                  options: [], metrics: metrics, views: views))
    }
    
}
