import UIKit
import CoreData

class FavoriteViewController: UIViewController,
                              UITableViewDelegate,
                              UITableViewDataSource {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    var titleArray = [String]()
    var yearArray = [String]()
    var imdbIDArray = [String]()
    var posterArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleArray.removeAll()
        yearArray.removeAll()
        imdbIDArray.removeAll()
        posterArray.removeAll()
        getCoreData()
        //favoriteTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 159
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imdbIDArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTableView.dequeueReusableCell(withIdentifier: "customCell") as! SearchTableViewCell
        cell.addFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.imdbID = imdbIDArray[indexPath.row]
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.yearLabel.text = yearArray[indexPath.row]
        cell.cellImageView.imageFrom(url: URL(string: "\(posterArray[indexPath.row])")!)
        return cell
    }
    
    //MARK: Get Core Data
    func getCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        titleArray.append(title)
                    }
                    if let poster = result.value(forKey: "poster") as? String {
                        posterArray.append(poster)
                    }
                    if let year = result.value(forKey: "year") as? String {
                        yearArray.append(year)
                    }
                    if let imdbID = result.value(forKey: "imdbID") as? String {
                        imdbIDArray.append(imdbID)
                    }
                }
            }
        } catch {
            print("error")
        }
        favoriteTableView.reloadData()
    }
    
}
