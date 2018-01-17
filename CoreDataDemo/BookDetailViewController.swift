//
//  BookDetailViewController.swift
//  CoreDataDemo
//
//  Created by Facheng Liang  on 14/01/2018.
//  Copyright © 2018 Facheng Liang . All rights reserved.
//

import UIKit
import CoreData

class BookDetailViewController: UIViewController {

    @IBOutlet weak var book: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var available: UILabel!
    
    var data: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Book Detail"

        book.text = data.value(forKey: BookKey.book.rawValue) as? String
        author.text = data.value(forKey: BookKey.author.rawValue) as? String
        available.text = data.value(forKey: BookKey.available.rawValue) as! Bool ? "Available" : "Not Available"
    }

    @IBAction func changeBookState(_ sender: Any) {
        let newAvailable = !(data.value(forKey: BookKey.available.rawValue) as! Bool)
        data.setValue(newAvailable, forKey: BookKey.available.rawValue)
        do {
            try data.managedObjectContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        available.text = newAvailable ? "Available" : "Not Available"
    }

}
