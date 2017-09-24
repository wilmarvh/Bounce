import UIKit

class PopularShotCellDetailsContainerView: UIView, Nibloadable {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetContent()
        configureViews()
    }
    
    func resetContent() {
        profileImageView.image = nil
        titleLabel.text = nil
        profileLabel.text = nil
        likesLabel.text = nil
    }
    
    func configureViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.semibold)
        titleLabel.textColor = UIColor.black
        
        profileLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        profileLabel.textColor = UIColor(red: 164/255.0, green: 170/255.0, blue: 179/255.0, alpha: 1.0)
        
        likesLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        likesLabel.textColor = UIColor.mediumPink()
    }
    
}
