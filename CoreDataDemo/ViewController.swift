//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Facheng Liang  on 13/01/2018.
//  Copyright © 2018 Facheng Liang . All rights reserved.
//

import UIKit
import CoreData

struct MyBook {
    let book: String
    let author: String
    let available: Bool
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var totalBooks: UILabel!
    var books: [MyBook] = [MyBook(book: "book", author: "author", available: true)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOverView()
        title = "My Books"
        
        tableView.register(UINib(nibName: "BookCell", bundle: Bundle(for: BookCell.self)), forCellReuseIdentifier: "BookCell")
    }

    @IBAction func clickAdd(_ sender: Any) {
        let addController = UIAlertController(title: "New Book", message: "Add A New Book And It's Author", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] (_) in
            self.save(addController)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        addController.addTextField(configurationHandler: nil)
        addController.addTextField(configurationHandler: nil)
        
        addController.addAction(saveAction)
        addController.addAction(cancelAction)
        present(addController, animated: true)
    }
    
    func save(_ alert: UIAlertController) {
        guard let bookTextField = alert.textFields?.first,
            let book = bookTextField.text else{
                return
        }
        guard let authorTextField = alert.textFields?[1],
            let author = authorTextField.text else{
                return
        }
        
        let newBook = MyBook(book: book, author: author, available: true)
        books.append(newBook)
        tableView.reloadData()
        updateOverView()
    }
    
    func updateOverView() {
        totalBooks.text = "\(books.count) 本"
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        cell.configUI(data: books[indexPath.row])
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookDetailViewController") as! BookDetailViewController
        viewController.data = books[indexPath.row]
        show(viewController, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

