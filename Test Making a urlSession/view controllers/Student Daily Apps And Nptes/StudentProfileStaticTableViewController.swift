//
//  StudentProfileStaticTableViewController.swift
//


import UIKit

class StudentProfileStaticTableViewController: UITableViewController {

    
    @IBOutlet var profileForDayLabel: [UILabel]!
    
    @IBOutlet weak var notesLabel: UITextView!

    var user : User!
    var student : Student!

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
