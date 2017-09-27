import UIKit
import NothingButNet
import PINRemoteImage

class HomeViewController: UICollectionViewController, UIPopoverPresentationControllerDelegate {
    
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
        collectionView?.register(HomeShotCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView?.refreshControl = UIRefreshControl(frame: .zero)
        collectionView?.refreshControl?.tintColor = UIColor.mediumPink()
        collectionView?.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        // layout
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(15, 0, 15, 0)
            layout.estimatedItemSize = CGSize(width: view.frame.width, height: 275)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 25
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeShotCell
        let shot = shots[indexPath.row] as Shot
        cell.details.titleLabel.text = shot.team?.name ?? shot.user.username
        cell.details.profileImageView.imageView.image = UIImage(named: "tabProfile")
        cell.details.likesLabel.text = "\(shot.likes_count)"
        cell.gifLabelImageView.isHidden = !shot.animated
        cell.imageView.alpha = 0
        cell.imageView.pin_setImage(from: shot.imageURL(), completion: { [weak cell] result in
            UIViewPropertyAnimator(duration: 0.2, curve: .easeIn, animations: {
                cell?.imageView.alpha = 1
            }).startAnimation()
        })
        cell.details.profileImageView.imageView.pin_setImage(from: shot.profileImageURL())
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shot = shots[indexPath.row]
        performSegue(withIdentifier: "showShotDetail", sender: shot)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showShotDetail", let controller = segue.destination as? ShotDetailViewController {
            controller.shot = sender as? Shot
        }
    }
    
    // MARK: Data
    
    @objc func refresh() {
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
    
    @IBAction public func unwindToHomeFromShotDetail(segue: UIStoryboardSegue) {
        debugPrint("unwindToHomeFromShotDetail")
    }
    
    @objc func showMenu() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "HomeFilterViewController") as? HomeFilterViewController {
            controller.modalPresentationStyle = .popover
            controller.collectionView?.reloadData()
            if let popoverController = controller.popoverPresentationController {
                popoverController.backgroundColor = .white
                popoverController.permittedArrowDirections = [.up]
                popoverController.barButtonItem = navigationItem.leftBarButtonItem
                popoverController.delegate = self
                controller.preferredContentSize = CGSize(width: 315, height: 223)
            }
            self.present(controller, animated: true, completion: nil)
        }
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
    
    // MARK: Popover delegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        let overlay = UIView(frame: tabBarController?.view.bounds ?? view.bounds)
        overlay.backgroundColor = .black
        overlay.alpha = 0.3
        overlay.tag = 123
        tabBarController?.view.addSubview(overlay)
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        tabBarController?.view.subviews.filter({ $0.tag == 123 }).forEach({ $0.removeFromSuperview() })
    }
    
}
