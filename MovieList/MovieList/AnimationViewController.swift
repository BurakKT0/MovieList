import UIKit

class AnimationViewController: UIViewController {
    
    @IBOutlet weak var animationImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationImageView.alpha = 0.0
        animationStart()
    }
    
    func animationStart() {
        UIView.animate(withDuration: 1.0, animations: {
            self.animationImageView.alpha = 1.0
        }) { [] (finished) in
            self.performSegue(withIdentifier: "toMovieViewController", sender: nil)
        }
    }
    
}
