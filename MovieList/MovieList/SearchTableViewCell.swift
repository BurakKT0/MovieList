import UIKit
import CoreData

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var addFavoriteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    var imdbID = String()
    var posterURL = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = cellView.frame.height / 16
        addFavoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    //MARK: Button Clicked
    @IBAction func addFavoriteClicked(_ sender: Any) {
        if addFavoriteButton.currentImage == UIImage(systemName: "star") {
            addFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            saveCoreData()
        } else {
            addFavoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            deleteCoreData()
        }
    }
    
    //MARK: Set Selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    //MARK: Save Core Data
    func saveCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let favoriteMovie = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: context)
        favoriteMovie.setValue(titleLabel.text, forKey: "title")
        favoriteMovie.setValue(imdbID, forKey: "imdbID")
        favoriteMovie.setValue(posterURL, forKey: "poster")
        favoriteMovie.setValue(yearLabel.text, forKey: "year")
        do {
            try context.save()
        } catch {
            print("Data is not Save!")
        }
    }
    
    //MARK: Delete Core Data
    @objc func deleteCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        fetchRequest.predicate = NSPredicate(format: "imdbID = %@", imdbID)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let imdbID = result.value(forKey: "imdbID") as? String {
                        if imdbID == imdbID {
                            context.delete(result)
                        }
                        do {
                            try context.save()
                        } catch {
                            print("error")
                        }
                        break
                    }
                }
            }
        } catch {
            print("error")
        }
    }
    
}
