//
//  StudentCollectionViewController.swift
//  Student Collection View Test
//
//  Created by Steven Hertz on 11/21/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol NotesDelegate {
        func updateStudentNote(passedNoted: String)
}

class StudentCollectionViewController: UICollectionViewController, NotesDelegate {
    
    var navBarTitle = ""
    
    var classGroupCodeInt: Int!
    var users: [User] = []
    var rowSelected = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

         title = navBarTitle
        let classGroupCodeStr = String(classGroupCodeInt)
        
        GetDataApi.getUserListByGroupResponse (GeneratedReq.init(request: ValidReqs.usersInDeviceGroup(parameterDict: ["memberOf" : classGroupCodeStr ]) )) { (userResponse) in
            DispatchQueue.main.async {
                
                guard let usrResponse = userResponse as? UserResponse else {fatalError("could not convert it to Users")}
                
                /// Just load in the users into this class if needed
                self.users = usrResponse.users
                self.users.sort {
                    $0.lastName < $1.lastName
                }

                /// Here we have what we need
                usrResponse.users.forEach { print($0.firstName + "--" + $0.lastName) }
                
                 self.collectionView.reloadData()
            }
        }

        
    }

    func updateStudentNote(passedNoted: String) {
        users[rowSelected].notes = passedNoted
    }
    

    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
         return users.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? StudentCollectionViewCell else {fatalError("could not deque")}
    
        // Configure the cell
        let student = users[indexPath.row]
        cell.studentImageView.image = UIImage(named: student.username)
        cell.studentNameLabel.text = student.firstName + " " + student.lastName
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let studentProfileVC = segue.destination as! StudentProfileViewController
        
        guard let rowSelectedTemp = collectionView.indexPathsForSelectedItems?.last?.row else {fatalError()}
        rowSelected = rowSelectedTemp
        
        studentProfileVC.student = users[rowSelected]
        studentProfileVC.notesDelegate = self

    }


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
