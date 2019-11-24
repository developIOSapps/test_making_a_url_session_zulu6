//
//  AppProfilesTableViewController.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/22/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit

class AppProfilesTableViewController: UITableViewController {

    var profiles:    [Profile] = []
    var expanded:    Bool = false
    var rowSelected: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetDataApi.getProfileListResponse { (xyz) in
            DispatchQueue.main.async {
                guard let profilesResponse = xyz as? ProfilesResponse
                    else {fatalError("could not convert it to Profiles")}
                self.profiles =
                    profilesResponse.profiles.filter{$0.name.hasPrefix("Profile-App ") }
                
                self.tableView.reloadData()
                print(self.profiles[1].name)
                
                
//                if let rownumber = self.profiles.firstIndex(where: { (item) -> Bool in
//                    item.name == self.profileForTheDayArray[self.dayOfWeekSegment.selectedSegmentIndex]
//                }) {
//                    self.tableView.selectRow(at: IndexPath(row: rownumber, section: 0), animated: true, scrollPosition: .none)
//                    let profileSelected = self.profiles[rownumber]
//                    self.profileDescription.text = profileSelected.description
//                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return profiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        
        let profile = profiles[indexPath.row]
        cell.setup(appProfileModel: profile)
//         cell.textLabel?.text = profile.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
             switch cell.accessoryType {
             case .none:
                 cell.accessoryType = .checkmark
                 expanded = true
                 print("set to checked")
             case .checkmark:
                 cell.accessoryType = .none
                 expanded = false
                 print("set to none")
             default:
                 break
             }
         }
         
         rowSelected = indexPath.row
         // expanded.toggle()
         
         tableView.beginUpdates()
         tableView.endUpdates()

     }
     
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.row == rowSelected {
             switch expanded {
             case true:
                 return 108.0
             case false:
                 return 44.0
             }
         } else {
             return 44.0
         }
     }

     override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
         if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
             cell.accessoryType = .none
         }
     }

}

extension AppProfilesTableViewController {
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let rowSelected = rowSelected, let cell = tableView.cellForRow(at: IndexPath(row: rowSelected, section: 0)) else {return false}
        
        // don't perform segue unless it is checked
        return cell.accessoryType == .checkmark
    }
    
}


 
