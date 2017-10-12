import UIKit
import NothingButNet

enum HomeList: String {
    case popular = "Popular"
    case teams = "Teams"
    case playoffs = "Playoffs"
    case debuts = "Debuts"
    case rebounds = "Rebounds"
    case gifs = "GIFs"
    case attachments = "Attachments"
    
    static func allNames() -> [String] {
        return [HomeList.popular.rawValue,
                HomeList.teams.rawValue,
                HomeList.playoffs.rawValue,
                HomeList.debuts.rawValue,
                HomeList.rebounds.rawValue,
                HomeList.gifs.rawValue,
                HomeList.attachments.rawValue
        ]
    }
    
    func asList() -> Shot.List {
        switch self {
        case .popular:
            return .popular
        case .teams:
            return .teams
        case .playoffs:
            return .playoffs
        case .debuts:
            return .debuts
        case .rebounds:
            return .rebounds
        case .gifs:
            return .animated
        case .attachments:
            return .attachments
        }
    }
}

enum HomeSort: String {
    case popular = "Popular"
    case recent = "Recent"
    case mostViewed = "Most Viewed"
    case mostCommented = "Most Commented"
    
    static func allNames() -> [String] {
        return [HomeSort.popular.rawValue,
                HomeSort.recent.rawValue,
                HomeSort.mostViewed.rawValue,
                HomeSort.mostCommented.rawValue
        ]
    }
    
    func asSort() -> Shot.Sort {
        switch self {
        case .popular:
            return .popular
        case .recent:
            return .recent
        case .mostViewed:
            return .views
        case .mostCommented:
            return .comments
        }
    }
}


class HomeFilterViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var filterSelected: (HomeList) -> Void = { _ in
        debugPrint("Thing was selected")
    }
    
    var selectedList: HomeList = .popular
    
    var selectedSort: HomeSort = .popular
    
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
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 15
            collectionView?.collectionViewLayout = layout
        }
    }
    
    // MARK: UICollectionView DataSource / Delegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return HomeList.allNames().count
        } else if section == 1 {
            return HomeSort.allNames().count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: HomeFilterCell.width, height: HomeFilterCell.height)
        } else if indexPath.section == 1 {
            if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
                let width = collectionView.frame.width - layout.sectionInset.left - layout.sectionInset.right
                return CGSize(width: width, height: HomeFilterCell.height)
            }
        }
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeFilterCell
        
        // filter
        if indexPath.section == 0 {
            let item = HomeList.allNames()[indexPath.row]
            cell.button.setTitle(item, for: .normal)
            cell.button.isHighlighted = selectedList.rawValue == item
            cell.button.action = { [weak self] in
                let item = HomeList.allNames()[indexPath.row]
                if let filter = HomeList(rawValue: item) {
                    self?.selectedList = filter
                    self?.collectionView?.reloadData()
                    _ = self?.popoverPresentationController?.delegate?.popoverPresentationControllerShouldDismissPopover!((self?.popoverPresentationController)!)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
        // sort
        else if indexPath.section == 1 {
            let item = HomeSort.allNames()[indexPath.row]
            cell.button.setTitle(item, for: .normal)
            cell.button.isHighlighted = selectedSort.rawValue == item
            cell.button.action = { [weak self] in
                let item = HomeSort.allNames()[indexPath.row]
                if let sort = HomeSort(rawValue: item) {
                    self?.selectedSort = sort
                    self?.collectionView?.reloadData()
                    _ = self?.popoverPresentationController?.delegate?.popoverPresentationControllerShouldDismissPopover!((self?.popoverPresentationController)!)
                    self?.dismiss(animated: true, completion: nil)
                }
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
        contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1.0, constant: 0))
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
