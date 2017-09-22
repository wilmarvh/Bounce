import UIKit
import NothingButNet

class HomeViewController: UICollectionViewController {
    
    var shots: [Shot] = [Shot]()
    
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
     
        title = "Bounce"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor(red:0.85490, green:0.34902, blue:0.53333, alpha:1.00000)
        navigationController?.navigationBar.tintColor = UIColor(red:0.85490, green:0.34902, blue:0.53333, alpha:1.00000)
        configureCollectionView()
        loadData()
    }
    
    // MARK: Configure view
    
    func configureCollectionView() {
        // cells
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        // layout
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: view.frame.width, height: 250)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor(red:0.20000, green:0.20000, blue:0.20000, alpha:1.00000)
        cell.backgroundView?.backgroundColor = cell.backgroundColor
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        let shot = shots[indexPath.row] as Shot
        let label = UILabel(frame: cell.contentView.bounds)
        label.text = shot.title
        label.textAlignment = .center
        label.font = UIFont.title1Font()
        label.textColor = .white
        label.numberOfLines = 0
        cell.contentView.addSubview(label)
        return cell
    }
    
    // MARK: Data
    
    func loadData() {
        NothingBut.Net.fetchPopularShots { [unowned self] shots, error in
            self.shots = shots ?? []
            self.collectionView?.reloadData()
        }
    }

}

