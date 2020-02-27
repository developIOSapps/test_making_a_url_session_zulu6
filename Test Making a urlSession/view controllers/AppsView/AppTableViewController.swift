//
//  TableViewController.swift
//  Template Categories
//
//  Created by Steven Hertz on 2/7/20.
//  Copyright © 2020 DevelopItSolutions. All rights reserved.
//

import UIKit

class AppTableViewController: UITableViewController {

    enum ItemsToDisplay {
        
        case students
        case devices
        
        var barTitle: String {
            switch self {
            case .devices:
                return "Devices"
            case .students:
                return "Students"
            }
        }
        
        var ctgFilterText: String {
            return UserDefaultsHelper.appFilter + UserDefaultsHelper.appCtgFilter + " "
        }
        var appFilterText: String {
            switch self {
            case .devices:
                return UserDefaultsHelper.appFilter + UserDefaultsHelper.app1KioskFilter + " "
            case .students:
                return UserDefaultsHelper.appFilter + UserDefaultsHelper.appKioskFilter + " "
            }
        }
        var segueIdentifierString : String {
            switch self {
            case .devices:
                return "fromAppsListbackToDeviceListWithSeque"
            case .students:
                return "fromAppsListBackToStudentAppProfileWithSeque"
            default: break

            }
            return "he"
        }
    }

    var itemsToDisplay: ItemsToDisplay = .students {
            didSet {
            print("Set items to display")
                // navigationItem.title = itemsToDisplay.barTitle
            }
        }
    
    

    
   
    var appCategoryStore: AppCategoryStore!
    var appStore: AppStore!
    
    lazy var appsByCatg = Array(repeating: Array<App>(), count: appCategoryStore.categories.count)
    var catgToDisplay = 3  // arbitrary starting point
    
    var selectedProfile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        //navigationItem.title = "David's Monday Setup - Select App or Category"
        //navigationItem.prompt =  "Select App or Category"
        
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
        
        headerCell.setup(with: appCategoryStore.appCategories[catgToDisplay], studentOrDevice: itemsToDisplay)
        headerCell.delegate = self
        headerCell.tbldelegate = self
        return headerCell
    }
    

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        switch itemsToDisplay {
        case .students:
            return 180
        case .devices:
            return 140
       }
     }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("the row was clicked")
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

extension AppTableViewController: AppTableViewDelegate {
    
    /// Called From Header Cell
    func cellHeaderButtonTapped(cell: HeaderTableViewCell) {
        print("The category to display is \(itemsToDisplay.ctgFilterText + appCategoryStore.appCategories[catgToDisplay].name)")
        selectedProfile = itemsToDisplay.ctgFilterText + appCategoryStore.appCategories[catgToDisplay].name
        performSegue(withIdentifier: "fromAppsListBackToStudentAppProfileWithSeque", sender: self)
    }
    
    /// called from app cell
    func cellRowButtonTapped(cell: AppTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { fatalError("Failed getting the indexpax of the cell")}
        // print(appsByCatg[catgToDisplay][indexPath.row].name)
        print(itemsToDisplay.appFilterText + appsByCatg[catgToDisplay][indexPath.row].name)
        selectedProfile = itemsToDisplay.appFilterText + appsByCatg[catgToDisplay][indexPath.row].name
        performSegue(withIdentifier: itemsToDisplay.segueIdentifierString, sender: self)
//        print(UserDefaultsHelper.appCtgFilter)
//        print(UserDefaultsHelper.appKioskFilter)
//        print(UserDefaultsHelper.app1KioskFilter)
    }
    
}

extension AppTableViewController: GestureRecognizerDelegate {
    
    func proccesTap(tap: UITapGestureRecognizer) {
        
        let nbrOfItems = appCategoryStore.appCategories.count
        // reset if at end so I could add 1
        if !(catgToDisplay < nbrOfItems - 1)  {
            catgToDisplay = -1
        }
        
        // increment
        catgToDisplay += 1
        
        // reload
        tableView.reloadSections(IndexSet(0..<1), with: .left)
        tableView.reloadData()
        
    }
    
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

}
