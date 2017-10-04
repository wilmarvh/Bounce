import UIKit

enum HomeFilterType: String {
    case popular = "Popular"
    case recent = "Recent"
    case teams = "Teams"
    case playoffs = "Playoffs"
    case debuts = "Debuts"
    case rebounds = "Rebounds"
    case gifs = "GIFs"
    case attachments = "Attachments"
    
    static func allNames() -> [String] {
        return [HomeFilterType.popular.rawValue,
                HomeFilterType.recent.rawValue,
                HomeFilterType.teams.rawValue,
                HomeFilterType.playoffs.rawValue,
                HomeFilterType.debuts.rawValue,
                HomeFilterType.rebounds.rawValue,
                HomeFilterType.gifs.rawValue,
                HomeFilterType.attachments.rawValue
        ]
    }
}

class HomeFilterViewController: UICollectionViewController {
    
    var filterSelected: (HomeFilterType) -> Void = { _ in
        debugPrint("Thing was selected")
    }
    
    var selectedFilter: HomeFilterType = .popular
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    // MARK: Configure view
    
    func configureCollectionView() {
        // cells and other
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(HomeFilterCell.self, forCellWithReuseIdentifier: "Cell")
        
        // layout
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(25, 20, 25, 20)
            layout.itemSize = CGSize(width: HomeFilterCell.width, height: HomeFilterCell.height)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 15
            collectionView?.collectionViewLayout = layout
        }
    }
    
    // MARK: UICollectionView DataSource / Delegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeFilterType.allNames().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeFilterCell
        let item = HomeFilterType.allNames()[indexPath.row]
        cell.button.setTitle(item, for: .normal)
        cell.button.isHighlighted = selectedFilter.rawValue == item
        cell.button.action = { [weak self] in
            let item = HomeFilterType.allNames()[indexPath.row]
            if let filter = HomeFilterType(rawValue: item) {
                self?.selectedFilter = filter
                self?.collectionView?.reloadData()
                self?.popoverPresentationController?.delegate?.popoverPresentationControllerShouldDismissPopover!((self?.popoverPresentationController)!)
                self?.dismiss(animated: true, completion: nil)
            }
        }
        return cell
    }
}

class HomeFilterCell: UICollectionViewCell {
    fileprivate static let width: CGFloat = 130
    fileprivate static let height: CGFloat = 32
    
    // MARK:
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    // MARK: Views
    
    lazy fileprivate var button: FilterButton = {
        let button = FilterButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = HomeFilterCell.height / 2
        button.backgroundColor = UIColor.grayButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(.white, for: .selected)
        return button
    }()
    
    func configureViews() {
        contentView.addSubview(button)
        contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: HomeFilterCell.height))
        contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: HomeFilterCell.width))
    }
    
}

fileprivate class FilterButton: UIButton {
    
    var action: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.mediumPink() : UIColor.grayButton()
        }
    }
    
    @objc func tapped() {
        if let action = action {
            action()
        }
    }
    
}
