import UIKit
import NothingButNet

class HomeViewController: UICollectionViewController {
    
    var shots: [Shot] = [Shot]()
    
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
     
        configureNavigationBar()
        configureCollectionView()
        configureBarButtonItems()
        loadData()
    }
    
    // MARK: Configure view
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func configureCollectionView() {
        // cells and other
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(PopularShotCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView?.refreshControl = UIRefreshControl(frame: .zero)
        collectionView?.refreshControl?.tintColor = UIColor.mediumPink()
        collectionView?.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        // layout
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(15, 0, 0, 0)
            layout.estimatedItemSize = CGSize(width: view.frame.width, height: 275)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 20
            collectionView?.collectionViewLayout = layout
        }
    }
    
    func newMenuButton(size: CGFloat, imageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: size, height: size)
        button.setImage(UIImage(named: imageName), for: .normal)
        return button
    }
    
    func configureBarButtonItems() {
        let height: CGFloat = 32
        // left
        var button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 130))
        button.setTitle("Popular", for: .normal)
        button.backgroundColor = UIColor.grayButton()
        button.layer.cornerRadius = height / 2
        button.titleLabel?.font = UIFont.title3Font()
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(named: "dropdownArrow"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        // right
        var buttons = [UIButton]()
        // filter
        button = newMenuButton(size: height, imageName: "filter")
        button.addTarget(self, action: #selector(showFilter), for: .touchUpInside)
        buttons.append(button)
        // time
        button = newMenuButton(size: height, imageName: "timeFilter")
        button.addTarget(self, action: #selector(showTime), for: .touchUpInside)
        buttons.append(button)
        // layout
        button = newMenuButton(size: height, imageName: "layoutChange")
        button.addTarget(self, action: #selector(showLayout), for: .touchUpInside)
        buttons.append(button)
        // stackview
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addConstraint(NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        buttons.forEach({ stackView.addArrangedSubview($0) })
        stackView.backgroundColor = .yellow
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
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
    
    // MARK: Actions
    
    @objc func showMenu() {
        debugPrint("Show menu")
    }
    
    @objc func showFilter() {
        debugPrint("Show filter")
    }

    @objc func showTime() {
        debugPrint("Show time")
    }
    
    @objc func showLayout() {
        debugPrint("Show layout")
    }
    
    // MARK: ScrollView
    
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
    
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addDefaultShadow()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.title3Font()
        label.textColor = UIColor.bounceBlack()
        label.numberOfLines = 1
        return label
    }()
    
    lazy var detailContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0
        return imageView
    }()
    
    lazy var imageContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor(red:0.94902, green:0.94902, blue:0.94902, alpha:1.00000)
        view.addSubview(self.imageView)
        return view
    }()
    
    func configureViews() {
        // config
        backgroundColor = UIColor.white
        backgroundView?.backgroundColor = backgroundColor
        
        // layout
        contentView.addSubview(containerView)
        containerView.addSubview(detailContainerView)
        containerView.addSubview(imageContainerView)
        let views: [String : Any] = ["titleLabel" : titleLabel,
                                     "containerView" : containerView,
                                     "imageContainerView" : imageContainerView,
                                     "detailContainerView" : detailContainerView,
                                     "imageView" : imageView]
        let metrics: [String: Any] = ["inset": 15]
        
        // container
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-inset-[containerView]-inset-|",
                                                                  options: [], metrics: metrics, views: views))
        // detailcontainer
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[detailContainerView]|",
                                                                    options: [], metrics: metrics, views: views))
        // imagecontainer
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageContainerView]|",
                                                                  options: [], metrics: metrics, views: views))
        imageContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|",
                                                                  options: [], metrics: metrics, views: views))
        imageContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|",
                                                                  options: [], metrics: metrics, views: views))
        // vertical
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-inset-[containerView]|",
                                                                  options: [], metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[imageContainerView(==200)][detailContainerView(==75)]",
                                                                  options: [], metrics: metrics, views: views))
    }
    
}
