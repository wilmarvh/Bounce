import UIKit

class HomeShotCellDetailsContainerView: UIView, Nibloadable {
    
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likesImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetContent()
        configureViews()
    }
    
    func resetContent() {
        profileImageView.imageView.image = nil
        titleLabel.text = nil
        likesLabel.text = nil
    }
    
    func configureViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.semibold)
        titleLabel.textColor = UIColor.black
        
        likesLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        likesLabel.textColor = UIColor.mediumPink()
    }
    
}
