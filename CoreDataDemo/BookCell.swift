//
//  BookCell.swift
//  CoreDataDemo
//
//  Created by Facheng Liang  on 14/01/2018.
//  Copyright © 2018 Facheng Liang . All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var book: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var available: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configUI(data: MyBook) {
        book.text = data.book
        author.text = data.author
        available.text = data.available ? "Available" : "Not Available"
    }
}
