//
//  StudentProfileViewController.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/15/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit

enum Literals: Int {
    case nbrOfDays = 5
    
    static func nbrOfDaysInt() -> Int {
        Literals.nbrOfDays.rawValue
    }
}


class StudentProfileViewController: UIViewController {
    
    
    var student : User!
    
    @IBOutlet weak var firstName:           UILabel!
    @IBOutlet weak var LastName:            UILabel!
    @IBOutlet weak var profilesTableView:   UITableView!
    @IBOutlet weak var profileDescription:  UILabel!
    @IBOutlet weak var dayOfWeekSegment:    UISegmentedControl!
    

    var notesDelegate:          NotesDelegate?
    var setAlready:             Bool = false
    var userInputToNote          = ""
    
    var profiles:               [Profile] = []
    var profileForTheDayArray   = Array(repeating: String(), count: Literals.nbrOfDaysInt())
    var segmentMovingFrom       = 0
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilesTableView.dataSource = self
        profilesTableView.delegate = self
        
        firstName.text = student.firstName + " " + student.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        dayOfWeekSegment.selectedSegmentIndex = 0
        
        GetDataApi.getProfileListResponse { (xyz) in
            DispatchQueue.main.async {
                guard let profilesResponse = xyz as? ProfilesResponse
                    else {fatalError("could not convert it to Profiles")}
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
        
        
        for (idx, profile) in profileForTheDayArray.enumerated()   {
            if profile.isEmpty {
                dayOfWeekSegment.selectedSegmentIndex = idx
                dayOfWeekChanged(dayOfWeekSegment)
                presentAlertWithTitle("Error", message: "Update failed, all the days are required")
                return
            }
        }
        
        var studentProfileList = profileForTheDayArray.joined(separator: ";")
        studentProfileList.append("~#~")
        let studentProfileListComplete = "~#~" + studentProfileList
        
        let newNote = userInputToNote.trimmingCharacters(in: .whitespacesAndNewlines) + "   " + studentProfileListComplete
        
        /// find the clean part of note to save

        GetDataApi.updateUserProperty(GeneratedReq.init(request: ValidReqs.updateUserProperty(userId: String(student.id), propertyName: "notes", propertyValue: newNote))) {
            DispatchQueue.main.async {
                self.notesDelegate?.updateStudentNote(passedNoted: newNote)
                self.presentAlertWithTitle("Update Done", message: "Update successful, student profile set")
                print("````````````Hooray Job well done")
            }
        }
    }
    
    @IBAction func dayOfWeekChanged(_ sender: UISegmentedControl) {
        
        /* No longer doing this check
        guard let selectionIndexPath = self.profilesTableView.indexPathForSelectedRow
            else {
                sender.selectedSegmentIndex  = segmentMovingFrom
                print("Please select a profile before changing days")
                return
        }
        */
        /// deselect current selection
        if let selectionIndexPath = self.profilesTableView.indexPathForSelectedRow {
            self.profilesTableView.deselectRow(at: selectionIndexPath, animated: true)
        }
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
            print("This is the clean string",cleanString)
            userInputToNote = cleanString
            
            
            /// Process Extracted  String
            let studentsNotesAppProfileArray = String(extractedString).split(separator: ";")
            
            /// Load Profiles
            for (idx, item)  in studentsNotesAppProfileArray.enumerated() {
                profileForTheDayArray[idx] = (String(item))
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
