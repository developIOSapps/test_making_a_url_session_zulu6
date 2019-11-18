//
//  StudentProfileViewController.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/15/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit

class StudentProfileViewController: UIViewController {
    
    var student : User!
    
    @IBOutlet weak var firstName:           UILabel!
    @IBOutlet weak var LastName:            UILabel!
    @IBOutlet weak var profilesTableView:   UITableView!
    @IBOutlet weak var profileDescription:  UILabel!
    @IBOutlet weak var dayOfWeekSegment:    UISegmentedControl!
    

    var notesDelegate:          NotesDelegate?
    var setAlready:             Bool = false
    var profiles:               [Profile] = []
    var profileForTheDayArray   = Array(repeating: String(), count: 5)
    var segmentMovingFrom       = 0
    // var indexPathDictionary: [String: IndexPath] = [:]
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilesTableView.dataSource = self
        profilesTableView.delegate = self
        
        firstName.text = student.firstName
        LastName.text = student.lastName
        
        dayOfWeekSegment.selectedSegmentIndex = 0
        
        GetDataApi.getProfileListResponse { (xyz) in
            DispatchQueue.main.async {
                guard let profilesResponse = xyz as? ProfilesResponse
                    else {fatalError("could not convert it to Profiles")}
                let profls = profilesResponse.profiles.first
                self.profiles =
                    profilesResponse.profiles.filter{$0.name.hasPrefix("Profile-App ") }
                
                self.profilesTableView.reloadData()
                
                self.processStudentNotes()
                
                if let rownumber = self.profiles.firstIndex(where: { (item) -> Bool in
                    item.name == self.profileForTheDayArray[self.dayOfWeekSegment.selectedSegmentIndex]
                }) {
                    self.profilesTableView.selectRow(at: IndexPath(row: rownumber, section: 0), animated: true, scrollPosition: .none)
                    let profileSelected = self.profiles[rownumber]
                    self.profileDescription.text = profileSelected.description
                }
            }
        }
    }
    
    
    @IBAction func updateTheStudent(_ sender: Any) {
        
        for profile in profileForTheDayArray   {
            if profile.isEmpty {
                print("Update Failed, All 5 Days are required")
                return
            }
        }
        
        var studentProfileList = profileForTheDayArray.joined(separator: ";")
        studentProfileList.append("~#~")
        let studentProfileListComplete = "~#~" + studentProfileList

        GetDataApi.updateUserProperty(GeneratedReq.init(request: ValidReqs.updateUserProperty(userId: String(student.id), propertyName: "notes", propertyValue: studentProfileListComplete))) {
            DispatchQueue.main.async {
                self.notesDelegate?.updateStudentNote(passedNoted: studentProfileListComplete)
                print("````````````Hooray Job well done")
            }
        }
    }
    
    @IBAction func dayOfWeekChanged(_ sender: UISegmentedControl) {
        
        guard let selectionIndexPath = self.profilesTableView.indexPathForSelectedRow
            else {
                sender.selectedSegmentIndex  = segmentMovingFrom
                print("Please select a profile before changing days")
                return
        }
        
        /// deselect current selection
        self.profilesTableView.deselectRow(at: selectionIndexPath, animated: true)
        /// save newSegment
        segmentMovingFrom = sender.selectedSegmentIndex
        
        /// set profile selected for current day
        /// get the row number from the array of values
        /// get the profile of the day
        
        if let rownumber = profiles.firstIndex(where: { (item) -> Bool in
            return item.name == profileForTheDayArray[sender.selectedSegmentIndex]
        }) {
            profilesTableView.selectRow(at: IndexPath(row: rownumber, section: 0), animated: true, scrollPosition: .none)
            let profileSelected = profiles[rownumber]
            profileDescription.text = profileSelected.description
        }
    }
    
    
    // MARK: - Helper Functions
    
    
    func processStudentNotes() {
        /// Setup
        let delimeter = "~#~"
        
        /// Function Call
        do {
            let (extractedString, cleanString) = try HelperFunctions.getStringFrom(passedString: student.notes, using: delimeter)
            
            setAlready = true
            
            /// Process Cleaned String
            print(cleanString)
            
            /// Process Extracted  String
            let strSplit2 = String(extractedString).split(separator: ";")
            // let strSplit3 = extractedString.split(separator: ";", maxSplits: 100, omittingEmptySubsequences: false)
            
            /// Load Profiles
            for (idx, item)  in strSplit2.enumerated() {
                profileForTheDayArray[idx] = (String(item))
                print("`````loading \(String(item))")
            }
        }
        catch  {
            setAlready = false
            return
        }
    }
}

extension StudentProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        
        let profile = profiles[indexPath.row]
        cell.textLabel?.text = profile.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileSelected = profiles[indexPath.row]
        profileDescription.text = profileSelected.description
        let row = indexPath.row
        profileForTheDayArray[segmentMovingFrom] = profiles[row].name
    }
}
