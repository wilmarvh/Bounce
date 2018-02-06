import Foundation
import UIKit

public protocol Nibloadable: class {
    static func nib() -> UINib
}

extension Nibloadable where Self: UIView {
    
    public static func nib() -> UINib {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: String(describing: self), bundle: bundle)
        return nib
    }
    
    public static func viewFromNib(owner: Any?) -> UIView? {
        let bundle = Bundle(for: self)
        let views = bundle.loadNibNamed(String(describing: self), owner: owner, options: nil)
        guard let view = views?.first as? UIView else {
            return nil
        }
        return view
    }
    
    public static func bundle() -> Bundle {
        return Bundle(for: self)
    }
}

