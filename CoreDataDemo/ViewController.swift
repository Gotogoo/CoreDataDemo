//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Facheng Liang  on 13/01/2018.
//  Copyright © 2018 Facheng Liang . All rights reserved.
//

import UIKit
import CoreData

enum BookKey: String {
    case book = "book"
    case author = "author"
    case available = "available"
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var totalBooks: UILabel!
    var books: [NSManagedObject] = []
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
        updateTotalBooks()
        title = "My Books"
        tableView.register(UINib(nibName: "BookCell", bundle: Bundle(for: BookCell.self)), forCellReuseIdentifier: "BookCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        let bookSort = NSSortDescriptor(key: "book", ascending: true)
        request.sortDescriptors = [bookSort]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }

    @IBAction func clickAdd(_ sender: Any) {
        let addController = UIAlertController(title: "New Book", message: "Add A New Book And It's Author", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] (_) in
            self.save(addController)
            self.tableView.reloadData()
            self.updateTotalBooks()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        addController.addTextField { (textField) in
            textField.placeholder = "book"
        }
        addController.addTextField { (textField) in
            textField.placeholder = "author"
        }
        
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
        
        let newBook = NSManagedObject(entity: fetchedResultsController.fetchRequest.entity!, insertInto: fetchedResultsController.managedObjectContext)
        newBook.setValue(book, forKeyPath: BookKey.book.rawValue)
        newBook.setValue(author, forKeyPath: BookKey.author.rawValue)
        newBook.setValue(true, forKeyPath: BookKey.available.rawValue)
        
        do {
            try fetchedResultsController.managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateTotalBooks() {
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        totalBooks.text = "\(count) 本"
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        guard let object = fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        cell.configUI(data: object as! NSManagedObject)
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookDetailViewController") as! BookDetailViewController
        viewController.data = fetchedResultsController?.object(at: indexPath) as! NSManagedObject
        show(viewController, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

