//
//  StudentProfileStaticTableViewController.swift
//


import UIKit

class StudentProfileStaticTableViewController: UITableViewController {

    
    @IBOutlet var profileForDayLabel: [UILabel]!
    @IBOutlet weak var notesLabel: UITextView!

    var user : User!
    var student : Student!
    var daySelected = 99
    

    override func viewDidLoad() {
        super.viewDidLoad()
        student = Student.getStudentFromUser(user)
        print(student.mondayName)
        
        navigationItem.title = student.lastName
        
        /// Set navigation left bar button
        ///
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
    
        notesLabel.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        profileForDayLabel[0].text = student.mondayName
        profileForDayLabel[1].text = student.tuesdayName
        profileForDayLabel[2].text = student.wednesdayName
        profileForDayLabel[3].text = student.thursdayName
        profileForDayLabel[4].text = student.fridayName
        notesLabel.text = student.notes
    }
 
}

extension StudentProfileStaticTableViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        print("we ended editing")
//        store.student.notes = textView.text
//        Student.saveTheStudent(self.store.student)
    }
}

extension StudentProfileStaticTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "monday":
            daySelected = 0
        case "tuesday":
            daySelected = 1
        case "wednesday":
            daySelected = 2
        case "thursday":
            daySelected = 3
        case "friday":
            daySelected = 4
        default:
            break
        }
    }
    
    @IBAction func backToStudentAppProfile(seque: UIStoryboardSegue)  {
        print("in unwind segue")
        guard let appProfilesTableVC =  seque.source as? AppProfilesTableViewController  else {fatalError("Was not the AppProfilesTable VC")}
        print(appProfilesTableVC.profiles[appProfilesTableVC.rowSelected])

        profileForDayLabel[daySelected].text = appProfilesTableVC.profiles[appProfilesTableVC.rowSelected].name
        daySelected = 99
        
        /// get the note ready
        
        var studentProfileList = ""
        for profile in profileForDayLabel {
            studentProfileList += (";" + (profile.text ?? ""))
        }
        studentProfileList.removeFirst()
     
        studentProfileList.append("~#~")
        let studentProfileListComplete = "~#~" + studentProfileList
        
    }
}
