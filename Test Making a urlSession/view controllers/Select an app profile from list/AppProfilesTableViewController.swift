//
//  AppProfilesTableViewController.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/22/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit

class AppProfilesTableViewController: UITableViewController {
    
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

         var appFilterText: String {
             switch self {
             case .devices:
                return UserDefaultsHelper.appFilter + UserDefaultsHelper.app1KioskFilter
             case .students:
                return UserDefaultsHelper.appFilter
             }
         }
     }

    var itemsToDisplay: ItemsToDisplay = .students {
            didSet {
            print("Set items to display")
                // navigationItem.title = itemsToDisplay.barTitle
            }
        }
    
    
    
    var itemsToDisply: String = ""
    
    let allProfiles = ["Profile-CTG-first", "Profile-CTG-second", "Profile-CTG-third", "Profile-Kiosk-first", "Profile-Kiosk-second", "Profile-Kiosk-third", "Profile-Kiosk-fourth", "Profile-Kiosk-fifth"]
    
    var ctgProfiles = [Profile]()
    var kioskProfiles = [Profile]()
    var profileArray = [[Profile]]()
    var kiosk1Profiles = [Profile]()

    var navBarSegmentedControl = UISegmentedControl()

    var profiles:    [Profile] = []
    var expanded:    Bool = false
    var rowSelected: Int?
    var fullStringPrefixCtg = ""
    var fullStringPrefixKiosk = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        navBarSegmentedControl = UISegmentedControl(items: ["Category", "Kiosk"])
        navBarSegmentedControl.sizeToFit()
        navBarSegmentedControl.tintColor = UIColor(red:0.99, green:0.00, blue:0.25, alpha:1.00)
        navBarSegmentedControl.selectedSegmentIndex = 0
        navBarSegmentedControl.addTarget(self, action: #selector(AppProfilesTableViewController.segmentedValueChanged(_:)), for: .valueChanged)
        // segment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "ProximaNova-Light", size: 15)!], for: .normal)
        
        
        print(navBarSegmentedControl.selectedSegmentIndex)

        GetDataApi.getProfileListResponse { (xyz) in
            DispatchQueue.main.async {
                guard let profilesResponse = xyz as? ProfilesResponse
                    else {fatalError("could not convert it to Profiles")}
                self.profiles =
                    profilesResponse.profiles.filter{$0.name.hasPrefix(self.itemsToDisplay.appFilterText) }
                self.profiles.sort()
                    // profilesResponse.profiles.filter{$0.name.hasPrefix("Profile-App") }
                
                switch self.itemsToDisplay {
                    
                case .students:
                    self.navigationItem.titleView = self.navBarSegmentedControl
                    
                    self.fullStringPrefixCtg = self.itemsToDisplay.appFilterText + UserDefaultsHelper.appCtgFilter
                    self.ctgProfiles = self.profiles.filter {$0.name.contains(self.fullStringPrefixCtg) }
                    
                    self.fullStringPrefixKiosk = self.itemsToDisplay.appFilterText + UserDefaultsHelper.appKioskFilter
                    self.kioskProfiles = self.profiles.filter {$0.name.contains(self.fullStringPrefixKiosk) }
                    
                    self.profileArray.append(self.ctgProfiles)
                    self.profileArray.append(self.kioskProfiles)
                    
                    self.tableView.reloadData()
                    print(self.profiles[1].name)
                    
                    
                    //                if let rownumber = self.profiles.firstIndex(where: { (item) -> Bool in
                    //                    item.name == self.profileForTheDayArray[self.dayOfWeekSegment.selectedSegmentIndex]
                    //                }) {
                    //                    self.tableView.selectRow(at: IndexPath(row: rownumber, section: 0), animated: true, scrollPosition: .none)
                    //                    let profileSelected = self.profiles[rownumber]
                    //                    self.profileDescription.text = profileSelected.description
                //                }
                case .devices:
                    print("we are in devices")
                    self.kiosk1Profiles = self.profiles
                    self.profileArray.append(self.kiosk1Profiles)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
        rowSelected = nil
//        tableView.beginUpdates()
//        tableView.endUpdates()

        tableView.reloadData()
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        if rowSelected == nil {
            return
        }
        
        switch itemsToDisplay {
        case .students:
            performSegue(withIdentifier: "backToStudentAppProfile", sender: nil)
        case .devices:
            performSegue(withIdentifier: "backToDeviceList", sender: nil)
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        print(navBarSegmentedControl.selectedSegmentIndex)
        if profileArray.count == 0 {
            return 0
        } else {
            return profileArray[navBarSegmentedControl.selectedSegmentIndex].count
        }
//        switch navBarSegmentedControl.selectedSegmentIndex {
//        case 0:
//            return ctgProfiles.count
//        case 1:
//            return kioskProfiles.count
//        default:
//            return 0
//        }

        // return profiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        
        let prf = profileArray[navBarSegmentedControl.selectedSegmentIndex][indexPath.row]
        
        switch self.itemsToDisplay {
            
        case .students:
            switch navBarSegmentedControl.selectedSegmentIndex {
            case 0:
                cell.setup(appProfileModel: prf, hideThisString: fullStringPrefixCtg)
            case 1:
                cell.setup(appProfileModel: prf, hideThisString: fullStringPrefixKiosk)
            default:
                break
            }
            
        case .devices:
            cell.setup(appProfileModel: prf, hideThisString: itemsToDisplay.appFilterText)
        }

        
//        cell.setup(appProfileModel: prf, hideThisString: itemsToDisplay.appFilterText)

        
//        switch navBarSegmentedControl.selectedSegmentIndex {
//        case 0:
//            let profile = ctgProfiles[indexPath.row]
//            cell.setup(appProfileModel: profile)
//       case 1:
//            let profile = kioskProfiles[indexPath.row]
//            cell.setup(appProfileModel: profile)
//        default:
//            break
//        }


        
//        let profile = profiles[indexPath.row]
//        cell.setup(appProfileModel: profile)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
             switch cell.accessoryType {
             case .none:
                 cell.accessoryType = .checkmark
                 expanded = true
                 print("set to checked")
                rowSelected = indexPath.row
             case .checkmark:
                 cell.accessoryType = .none
                 expanded = false
                 print("set to none")
                rowSelected = nil
             default:
                 break
             }
         }
         
         // rowSelected = indexPath.row
         // expanded.toggle()
         
         tableView.beginUpdates()
         tableView.endUpdates()

     }
     
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.row == rowSelected {
             switch expanded {
             case true:
                return UITableView.automaticDimension
             case false:
                 return 62.0
             }
         } else {
             return 62.0
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


 
