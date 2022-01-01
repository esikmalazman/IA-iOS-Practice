/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Alamofire

final class MainTableViewController: UITableViewController {
  
  //MARK: - Outlets
  @IBOutlet weak var searchBar: UISearchBar!
  //MARK: - Variables
  // Store collection of films return from server
  var items = [Displayable]()
  // Store selected film
  var selectedItem : Displayable?
  //MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    fetchFilms()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
    let item = items[indexPath.row]
    cell.textLabel?.text = item.titleLabelText
    cell.detailTextLabel?.text = item.subtitleLabelText
    return cell
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    // Take film from selected row and store into property
    selectedItem = items[indexPath.row]
    return indexPath
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destinationVC = segue.destination as? DetailViewController else {
      return
    }
    // Set selected film by user as data to display at next vc
    destinationVC.data = selectedItem
  }
}

// MARK: - UISearchBarDelegate
extension MainTableViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
  }
}


//MARK: - Alamofire methods
extension MainTableViewController {
  func fetchFilms() {
    // 1 - Accept endpoint of data, can accept other more parameters, but for now we just send URL and use default parameter
    //    let request = AF.request("https://swapi.dev/api/films")
    //2 - Take response that get from request and print the data
    //    request.responseJSON { [weak self] data in
    //      print(data)
    //    }
    // 3 - Convert the data receive to data model instead of convert the response to JSON
    //    request.responseDecodable(of: Films.self) { data in
    //      guard let films = data.value else {return}
    //      print(films.all[0].title)
    //    }
    
    // 4 - Use method chaining by AF, works by connecting response of one method as input to another with single line of code
    AF.request("https://swapi.dev/api/films")
      .validate() // Validate response, ensure the response return HTTP status from range 200-299
      .responseDecodable(of: Films.self) { [weak self] response in
        guard let films = response.value else {return}
        print(films.all.first?.title ?? "nil")
        self?.items = films.all
        self?.tableView.reloadData()
      }
  }
}
