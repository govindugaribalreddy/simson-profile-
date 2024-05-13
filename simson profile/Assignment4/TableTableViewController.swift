//
//  TableTableViewController.swift
//  Assignment4
//
//  Created by BALREDDY GOVINDUGARI on 11/29/23.
//

import UIKit

class TableTableViewController: UITableViewController  {
    
    @IBOutlet var tableView1: UITableView!
    
    
    var details=[ToDO]()
    let session = URLSession.shared
    var str1 = "https://api.duckduckgo.com/?q=simpsons+characters&format=json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        link()
        tableView.register(CoustomcellTableViewCell.self, forCellReuseIdentifier: "CoustomcellTableViewCell")
    }
    
    func link(){
        
        let url = URL(string: str1)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let relatedTopics = json?["RelatedTopics"] as? [[String: Any]] {
                    self?.parseCharacters(from: relatedTopics)
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
            
        }
        task.resume()
    }
    
    func parseCharacters(from topics: [[String: Any]]) {
        for topic in topics {
            if let name = topic["Text"] as? String,
               let description = topic["Text"] as? String {
                var imageURL: URL?
                if let iconURLString = topic["Icon"] as? [String: String],
                   let urlString = iconURLString["URL"] {
                    imageURL = URL(string: urlString)
                }
                let character = ToDO(name: name, discription: description, imageURL: imageURL)
                //print(character)
                details.append(character)
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return details.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CoustomcellTableViewCell
        cell.lbl1?.text=details[indexPath.row].name
        let array = cell.textLabel?.text?.components(separatedBy: CharacterSet(charactersIn: "-"))
        cell.textLabel?.text=array?[0]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       50
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "titletoview",
        let indexPath = tableView.indexPathForSelectedRow {
         let selectedData = details[indexPath.row]
         let arr = selectedData.discription.components(separatedBy: "-")
         if let destinationVC = segue.destination as? ViewController  {
             destinationVC.discription=arr[1]
             destinationVC.givenname=arr[0]
             destinationVC.imageview=selectedData.imageURL?.absoluteString ?? ""
             //print(selectedData.imageURL)
         }
     }
    }
}
