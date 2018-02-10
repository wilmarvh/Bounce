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
    
    func buttonWidth() -> CGFloat {
        switch self {
        case .popular:
            return 130
        case .teams:
            return 115
        case .playoffs:
            return 140
        case .debuts:
            return 125
        case .rebounds:
            return 165
        case .gifs:
            return 90
        case .attachments:
            return 200
        }
    }
}

class HomeListTypeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var selectedList: HomeList = .popular
    
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
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeList.allNames().count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HomeFilterCell.width, height: HomeFilterCell.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeFilterCell
        
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
        
        return cell
    }
}
