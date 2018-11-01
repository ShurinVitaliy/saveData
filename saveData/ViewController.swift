//
//  ViewController.swift
//  saveData
//
//  Created by Admin on 01.11.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private var tableView: UITableView!
    private var viewForTableView: UIView!
    private var startGameButton: UIButton!
    var array: [NSManagedObject] = []
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLay")
        setUpConstraints()
        setUpConstraintsForTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        do {
            array = try managedContext.fetch(fetchRequest)
        } catch let err as NSError{
            print("failed to fetch items", err)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        viewForTableView = createViewForTableView()
        view.addSubview(viewForTableView)
        startGameButton = createStartGameButton()
        view.addSubview(startGameButton)
        tableView = createTableView()
        viewForTableView.addSubview(tableView)
    }
    
    private func createStartGameButton() -> UIButton {
        let gameButton = UIButton()
        gameButton.setTitle("добавить!", for: .normal)
        gameButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        gameButton.titleLabel?.textAlignment = .center
        gameButton.translatesAutoresizingMaskIntoConstraints = false
        gameButton.addTarget(self, action: #selector(addNewElement), for: UIControlEvents.touchUpInside)
        gameButton.backgroundColor = .darkGray
        return gameButton
    }
    
    @objc private func addNewElement(_ sender: UIButton) {
        let alertController = UIAlertController(title: "введите информацию", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.save((alertController.textFields?.first?.text)!)
            self.tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)

        print(array.count)
    }
    
    func save(_ itemName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        item.setValue(itemName, forKey: "itemName")
        
        do {
            try managedContext.save()
            array.append(item)
        } catch let err as NSError {
                print("error save", err)
            }
    }
    
    private func createViewForTableView() -> UIView {
        let viewForTableView = UIView()
        viewForTableView.backgroundColor = .white
        viewForTableView.translatesAutoresizingMaskIntoConstraints = false
        return viewForTableView
    }
    
    private func setUpConstraints() {
        
        viewForTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewForTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewForTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewForTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 8/9).isActive = true
        
        startGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        startGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        startGameButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        startGameButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/9).isActive = true
        
    }
    
    private func setUpConstraintsForTableView() {
        tableView.trailingAnchor.constraint(equalTo: viewForTableView.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: viewForTableView.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: viewForTableView.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: viewForTableView.bottomAnchor).isActive = true
    }
    
    private func createTableView() -> UITableView {
        let tableView = UITableView(frame: viewForTableView.bounds)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row].value(forKeyPath: "itemName") as? String
        
        return cell
    }
}

