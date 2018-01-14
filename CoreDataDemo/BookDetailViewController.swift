//
//  BookDetailViewController.swift
//  CoreDataDemo
//
//  Created by Facheng Liang  on 14/01/2018.
//  Copyright © 2018 Facheng Liang . All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    @IBOutlet weak var book: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var available: UILabel!
    
    var data: MyBook!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Book Detail"

        book.text = data.book
        author.text = data.author
        available.text = data.available ? "Available" : "Not Available"
    }

    @IBAction func changeBookState(_ sender: Any) {
    }

}
