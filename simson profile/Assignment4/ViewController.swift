//
//  ViewController.swift
//  Assignment4
//
//  Created by BALREDDY GOVINDUGARI on 11/29/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var textview1: UITextView!
    @IBOutlet weak var lbl1: UILabel!
    
    var givenname=""
    var discription=""
    var imageview = ""
    var str="https://duckduckgo.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        let name=self.givenname
        self.lbl1.text=name
        self.textview1.text=discription
        let imgId=self.imageview
        
        str = str + imgId
        //setImg(str: str)
        if imgId != ""{
            if let imageUrl = URL(string: str) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let error = error {
                        print("Error fetching image: \(error.localizedDescription)")
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.image1.image = image
                        }
                    }
                }.resume()
            }
        }
        
        else{
            self.image1.image=UIImage(named: "simson.jpeg")
        }
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
}

