import UIKit
import CoreData

class SearchViewController: UIViewController,
                            UITableViewDelegate,
                            UITableViewDataSource,
                            UISearchResultsUpdating {
    
    @IBOutlet weak var searchTableView: UITableView!
    let searchController = UISearchController()
    var titleArray = [String]()
    var yearArray = [String]()
    var imdbIDArray = [String]()
    var posterArray = [String]()
    var rowValue = Int()
    var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    //MARK: Hide Keyboard
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imdbIDArray.count
    }
    
    //MARK: Check Favorite and Add Star
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        rowValue = indexPath.row
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "customCell") as! SearchTableViewCell
        getCoreData()
        if isFavorite {
            cell.addFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            cell.addFavoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        cell.imdbID = imdbIDArray[indexPath.row]
        cell.posterURL = posterArray[indexPath.row]
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.yearLabel.text = yearArray[indexPath.row]
        cell.cellImageView.imageFrom(url: URL(string: "\(posterArray[indexPath.row])")!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 159
    }
    
    //MARK: Update Search Results
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        getRespons(movieTitle: text)
    }
    
    //MARK: Get Respons
    func getRespons(movieTitle: String) {
        titleArray.removeAll()
        yearArray.removeAll()
        imdbIDArray.removeAll()
        posterArray.removeAll()
        guard let url = URL(string: "http://www.omdbapi.com?apikey=5cb5226b&s=\(movieTitle)&plot=full") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let searchArray = json["Search"] as? [[String: Any]] {
                            for item in searchArray {
                                if let title = item["Title"] as? String {
                                    self.titleArray.append(title)
                                }
                                if let year = item["Year"] as? String {
                                    self.yearArray.append(year)
                                }
                                if let imdbID = item["imdbID"] as? String {
                                    self.imdbIDArray.append(imdbID)
                                }
                                if let poster = item["Poster"] as? String {
                                    self.posterArray.append(poster)
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.searchTableView.reloadData()
                        }
                    }
                } catch {
                    print("JSON Parsing Error: \(error.localizedDescription)")
                }
            }
        }.resume()
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
                    if let imdbID = result.value(forKey: "imdbID") as? String {
                        if imdbIDArray[rowValue] == imdbID {
                            isFavorite = true
                            break
                        } else {
                            isFavorite = false
                        }
                    }
                }
            }
        } catch {
            print("error")
        }
    }
    
}
