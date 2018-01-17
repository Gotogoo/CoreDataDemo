//
//  BookCell.swift
//  CoreDataDemo
//
//  Created by Facheng Liang  on 14/01/2018.
//  Copyright © 2018 Facheng Liang . All rights reserved.
//

import UIKit
import CoreData

class BookCell: UITableViewCell {

    @IBOutlet weak var book: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var available: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configUI(data: NSManagedObject) {
        book.text = data.value(forKey: BookKey.book.rawValue) as? String
        author.text = data.value(forKey: BookKey.author.rawValue) as? String
        available.text = data.value(forKey: BookKey.available.rawValue) as! Bool ? "Available" : "Not Available"
    }
}
