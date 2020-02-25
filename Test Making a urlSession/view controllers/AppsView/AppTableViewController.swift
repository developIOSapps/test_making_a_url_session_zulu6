//
//  TableViewController.swift
//  Template Categories
//
//  Created by Steven Hertz on 2/7/20.
//  Copyright © 2020 DevelopItSolutions. All rights reserved.
//

import UIKit

class AppTableViewController: UITableViewController, GestureRecognizerDelegate, AppTableViewDelegate {
    
    func cellHeaderButtonTapped(cell: HeaderTableViewCell) {
        let ip = tableView.indexPath(for: cell)
        print("i am the delegate")
        print(ip?.row, "row")
        print(ip?.section, "header")
        print("The category to display is \(catgToDisplay)")
    }
    
    
    func cellRowButtonTapped(cell: AppTableViewCell) {
        let ip = tableView.indexPath(for: cell)
        print("i am the delegate")
        print(ip?.row)
    }
    
    
    var appCategoryStore: AppCategoryStore!
    var appStore: AppStore!
    
    lazy var appsByCatg = Array(repeating: Array<App>(), count: appCategoryStore.categories.count)
    var catgToDisplay = 3  // arbitrary starting point
    
    @objc func proccesSwipe(with swipeGestureRecognizer: UISwipeGestureRecognizer){

        let nbrOfItems = appCategoryStore.appCategories.count
        switch swipeGestureRecognizer.direction {
        case .left:
            
            // reset if at end so I could add 1
            if !(catgToDisplay < nbrOfItems - 1)  {
                catgToDisplay = -1
            }
            
            // increment
            catgToDisplay += 1
            
            // reload
            tableView.reloadSections(IndexSet(0..<1), with: .left)
            tableView.reloadData()
            
        case .right:
            
            // reset if at end so I could add 1
            if !(catgToDisplay > 0)  {
                catgToDisplay = nbrOfItems
            }
            
            // decrement
            catgToDisplay -= 1
            
            // reload
            tableView.reloadSections(IndexSet(0..<1), with: .right)
            tableView.reloadData()

        default:
            break
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "David's Monday Setup - Select App or Category"
        navigationItem.prompt =  "Select App or Category"
        
        appCategoryStore = AppCategoryStore()
        appStore = AppStore()
        
        appStore.apps.forEach { appsByCatg[$0.key].append($0) }
        
        tableView.rowHeight = 168
    }

    // MARK: - Table view data source

    @objc func bb()  {
        print("hello")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appsByCatg[catgToDisplay].count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AppTableViewCell

        // Configure the cell...
        // cell.textLabel?.text = categories[indexPath.row]
        
        let app = appsByCatg[catgToDisplay][indexPath.row]
        
        cell.title.text = app.name
        cell.subtitle.text = app.description
        cell.iconImage.image = UIImage(named: app.name.replacingOccurrences(of: "/", with: ""))
        cell.delegate = self
        
        
        return cell
    }


    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        print("Im am in header proc and the catgcode is \(catgToDisplay)")
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "header") as? HeaderTableViewCell else {fatalError("Unable to allocate a header cell")}
        
        headerCell.setup(with: appCategoryStore.appCategories[catgToDisplay])
        headerCell.delegate = self
        headerCell.tbldelegate = self
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 180
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
     //   guard let appVC = segue.destination as? AppViewController  else {
     //       fatalError("expected AppViewController")
       // }
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
       // appVC.appCategory = appStore.apps[indexPath.row]
        
    }


}
