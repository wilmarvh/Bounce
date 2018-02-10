import Foundation
import UIKit

enum Icons {
    case white
    case pink
    
    static let allIcons = [Icons.white, Icons.pink]
    
    func title() -> String {
        switch self {
        case .white:
            return "White Men Can't Jump"
        case .pink:
            return "Pink Panther"
        }
    }
    
    func imageName() -> String {
        switch self {
        case .white:
            return "WhiteIcon"
        case .pink:
            return "PinkIcon"
        }
    }
    
    func alternateIconName() -> String {
        switch self {
        case .white:
            return "White"
        case .pink:
            return "Pink"
        }
    }
    
    func setAsAlternateIcon() {
        var name: String = alternateIconName()
        UIApplication.shared.setAlternateIconName(name) { error in
            debugPrint(error as Any)
        }
    }
}

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        navigationController?.navigationBar.tintColor = UIColor.hooopsGreen()
        addBarButtonItems()
    }
    
    func addBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
    }
    
    @objc func close() {
        performSegue(withIdentifier: "unwindToHomeFromSettings", sender: nil)
    }
    
    // MARK: UITableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Icons.allIcons.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let icon = Icons.allIcons[indexPath.row]
        let imageName = icon.imageName()
        cell.textLabel?.text = icon.title()
        cell.imageView?.image = UIImage(named: imageName)
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        cell.imageView?.layer.cornerRadius = 10
        cell.imageView?.clipsToBounds = true
        cell.tintColor = navigationController?.navigationBar.tintColor
        cell.accessoryType = .none
        cell.selectionStyle = .none
        if UIApplication.shared.alternateIconName == icon.alternateIconName() {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "App Icon"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let icon = Icons.allIcons[indexPath.row]
        icon.setAsAlternateIcon()
        tableView.reloadData()
    }
    
}
