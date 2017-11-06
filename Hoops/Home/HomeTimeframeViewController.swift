import UIKit
import NothingButNet

enum HomeTimeframe: String {
    case now = "Now"
    case week = "Week"
    case year = "Year"
    case month = "Month"
    case ever = "Ever"
    
    static func allNames() -> [String] {
        return [HomeTimeframe.now.rawValue,
                HomeTimeframe.week.rawValue,
                HomeTimeframe.month.rawValue,
                HomeTimeframe.year.rawValue,
                HomeTimeframe.ever.rawValue
        ]
    }
    
    func asTimeframe() -> Shot.Timeframe {
        switch self {
        case .now:
            return .now
        case .week:
            return .week
        case .month:
            return .month
        case .year:
            return .year
        case .ever:
            return .ever
        }
    }
}


class HomeTimeframeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var selectedTimeframe: HomeTimeframe = .now
    
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
        return HomeTimeframe.allNames().count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HomeFilterCell.width, height: HomeFilterCell.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeFilterCell
        
        let item = HomeTimeframe.allNames()[indexPath.row]
        cell.button.setTitle(item, for: .normal)
        cell.button.isHighlighted = selectedTimeframe.rawValue == item
        cell.button.action = { [weak self] in
            let item = HomeTimeframe.allNames()[indexPath.row]
            if let sort = HomeTimeframe(rawValue: item) {
                self?.selectedTimeframe = sort
                self?.collectionView?.reloadData()
                _ = self?.popoverPresentationController?.delegate?.popoverPresentationControllerShouldDismissPopover!((self?.popoverPresentationController)!)
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
        return cell
    }
}
