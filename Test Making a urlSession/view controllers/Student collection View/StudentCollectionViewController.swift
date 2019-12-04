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

    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        print("in view did appear")
         if classGroupCodeInt ==  nil {
            print("in about to perform segue")
             performSegue(withIdentifier: "loginScr", sender: nil)
         }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Customize the navigation bar
        // navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // navigationController?.navigationBar.shadowImage = UIImage()
        
        // navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.tintColor = UIColor(named: "tintContrast")

        

        print("in view did load")
         if classGroupCodeInt ==  nil {
            print("in about to perform segue")
             performSegue(withIdentifier: "loginScr", sender: nil)
         } else {

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
    }

    
    
     
    @IBAction func returnFromLoginWithClass(segue: UIStoryboardSegue) {
        guard let vc = segue.source as? LoginViewController, let groupID = vc.groupID else { fatalError("No Class Group Code")  }
        classGroupCodeInt = groupID
        print("Returned from Segue \(classGroupCodeInt)")
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
        cell.studentNameLabel.text = student.firstName // + " " + student.lastName
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("in did select item and the item in \(indexPath.row)")
        rowSelected = indexPath.row
        performSegue(withIdentifier: "goToStudentDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "goToStudentDetail":
                    guard let studentProfileStaticTableVC = segue.destination as? StudentProfileStaticTableViewController else { fatalError(" could not segue ") }
            // guard let studentProfileStaticTableVC = tabBarVC.customizableViewControllers?.first as? StudentProfileStaticTableViewController else {fatalError(" could not segue ")}
             
             studentProfileStaticTableVC.user = users[rowSelected]
             studentProfileStaticTableVC.notesDelegate = self
             
             studentProfileStaticTableVC.navigationItem.title = users[rowSelected].firstName.trimmingCharacters(in: .whitespacesAndNewlines) + " " + users[rowSelected].lastName.trimmingCharacters(in: .whitespacesAndNewlines)

             print("finished Segue")

        default:
            break
        }
        
    }



}
