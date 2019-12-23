//
//  StudentProfileStaticTableViewController.swift
//


import UIKit

class StudentProfileStaticTableViewController: UITableViewController {
    
    // MARK: - Screen Properies
    @IBOutlet var profileForDayLabel: [UILabel]!
    @IBOutlet weak var notesLabel: UITextView!
    
    
    // MARK: -  Properies
    var user : User!
    var student : Student!
    var daySelected = 99
    var notesDelegate: NotesDelegate?
    
    /// New property to handle multiple selections and even one selection now
    var usersSelected: [User] = [User]()

    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        /// Set navigation bar
        ///
        navigationItem.prompt = "Setup the Student"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
    
        /// become a textView delegate
        notesLabel.delegate = self
        
        /// Configure Taps to leave editing
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        if usersSelected.count == 1 {
            /// Setup Student With Application Profile By the Day
            student = Student.getStudentFromUser(usersSelected.first!)
            dump(student)
            
            /// Update the screen
            /*
             for x in 0...4 {
             profileForDayLabel[x].text = student.mondayName.replacingOccurrences(of: UserDefaultsHelper.appFilter, with: "")
             }
             */
            profileForDayLabel[0].text = student.mondayName.replacingOccurrences(of: UserDefaultsHelper.appFilter, with: "")
            profileForDayLabel[1].text = student.tuesdayName.replacingOccurrences(of: UserDefaultsHelper.appFilter, with: "")
            profileForDayLabel[2].text = student.wednesdayName.replacingOccurrences(of: UserDefaultsHelper.appFilter, with: "")
            profileForDayLabel[3].text = student.thursdayName.replacingOccurrences(of: UserDefaultsHelper.appFilter, with: "")
            profileForDayLabel[4].text = student.fridayName.replacingOccurrences(of: UserDefaultsHelper.appFilter, with: "")
            notesLabel.text = student.notes
            notesLabel.isEditable = true
        } else {
            profileForDayLabel[0].text = "*** We are in multiple mode ***"
            profileForDayLabel[1].text = "*** We are in multiple mode ***"
            profileForDayLabel[2].text = "*** We are in multiple mode ***"
            profileForDayLabel[3].text = "*** We are in multiple mode ***"
            profileForDayLabel[4].text = "*** We are in multiple mode ***"
            notesLabel.text = "*** We are in multiple mode ***"
            notesLabel.isEditable = false
        }
    }
 
}

extension StudentProfileStaticTableViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {

        print("we ended editing")
        
        /// Check if the note changed
        if notesLabel.text != student.notes {
            student.notes = notesLabel.text
            print(" Notes have changed")
            upDateStudentAppNotes(appProfileToUse: nil, for: usersSelected.first!)
        }
    /* Updated for Swift 4 */

        
//        store.student.notes = textView.text
//        Student.saveTheStudent(self.store.student)
    }
    
     /* Updated for Swift 4 */
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         if(text == "\n") {
             textView.resignFirstResponder()
             return false
         }
         return true
     }
}


extension StudentProfileStaticTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let appProfileVC = segue.destination as? AppProfilesTableViewController else {
            fatalError("could not cast the destination app segue")
        }
        
        let forLiteral = usersSelected.count == 1 ? student.firstName : "Multiple Mode"
        
        switch segue.identifier {
        case "monday":
            daySelected = 0
            appProfileVC.navigationItem.prompt = "Monday apps for \(forLiteral)"
        case "tuesday":
            daySelected = 1
            appProfileVC.navigationItem.prompt = "Tuesday apps for \(forLiteral)"
        case "wednesday":
            daySelected = 2
            appProfileVC.navigationItem.prompt = "Wednesday apps for \(forLiteral)"
        case "thursday":
            daySelected = 3
            appProfileVC.navigationItem.prompt = "Thursday apps for \(forLiteral)"
        case "friday":
            daySelected = 4
            appProfileVC.navigationItem.prompt = "Friday apps for \(forLiteral)"
        default:
            break
        }
        
        appProfileVC.itemsToDisplay = .students
    }
    
    
    @IBAction func backToStudentAppProfile(seque: UIStoryboardSegue)  {
        /// What we need
        guard let appProfilesTableVC =  seque.source as? AppProfilesTableViewController else {fatalError("Was not the AppProfilesTable VC")}
        
        let segmentIdx = appProfilesTableVC.navBarSegmentedControl.selectedSegmentIndex
        guard let row = appProfilesTableVC.rowSelected else { fatalError("There was no row selected")}
        
        /// get the profile name ,  use it to show on the screen so we take off the prefix
        profileForDayLabel[daySelected].text = appProfilesTableVC.profileArray[segmentIdx][row].name.replacingOccurrences(of: UserDefaultsHelper.appFilter, with: "")
        
        /// then Update the student
        for (position, user)  in usersSelected.enumerated() {
            upDateStudentAppNotes(appProfileToUse: appProfilesTableVC.profileArray[segmentIdx][row].name, for: user)
        }
        
        daySelected = 99
    }
    
    func upDateStudentAppNotes(appProfileToUse: String? = nil, for userToUpdate: User)  {
        
        var studentBeingUpdated = Student.getStudentFromUser(userToUpdate)
        
        // Build the app profile portion of the note
        let profileNoteDelimiter = "~#~"

        /// update the student record if doing this because of app profile change
        if let appProfileToUse = appProfileToUse {
            studentBeingUpdated.setStudentAppProfileForDayNbr(daySelected, with: appProfileToUse)
        }
        
        /*
        guard let profileForDayLabel = profileForDayLabel else {fatalError("eeeee")}
        print(profileForDayLabel.count)
        let profileArrayNoNulls = profileForDayLabel.compactMap { $0.text }
        print(profileArrayNoNulls)
        
        var studentProfileListTemp = profileNoteDelimiter
        for item in profileArrayNoNulls {
            studentProfileListTemp.append((item.isEmpty ? "" : UserDefaultsHelper.appFilter) + item + ";")
        }
        var studentProfileList = String(studentProfileListTemp.dropLast())
        studentProfileList.append(profileNoteDelimiter)
        */
        
        let studentFullAppProfile = profileNoteDelimiter + studentBeingUpdated.makeNote + profileNoteDelimiter
                
        let trimmedNote = studentBeingUpdated.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let fullNote = trimmedNote +  "   " + studentFullAppProfile
        
        
        print("~*~~~~~", fullNote)
        
        GetDataApi.updateUserProperty(GeneratedReq.init(request: ValidReqs.updateUserProperty(userId: String(studentBeingUpdated.id), propertyName: "notes", propertyValue: fullNote))) {
            DispatchQueue.main.async {
                /// Update local versions of note being kept in the student collection list and here in the student profile
                self.notesDelegate?.updateStudentNote(passedNoted: fullNote, user: userToUpdate )   //Update local versions of note being kept in the student collection list
                if let idx = self.usersSelected.firstIndex(of: userToUpdate) {
                    self.usersSelected[idx].notes = fullNote
                }   //   and here in the student profile

                // self.presentAlertWithTitle("Update Done", message: "Update successful, student profile set")
                print("````````````Hooray Job well done")
            }
        }
    }
}
