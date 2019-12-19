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
    func updateStudentNote(passedNoted: String, user: User)
}

class StudentCollectionViewController: UICollectionViewController, NotesDelegate {
    
    enum SelectionMode {
        
        case multipleEnabled
        case multipleDisabled
               
        var allTitles: (buttonTitle: String, barTitle: String) {
            switch self {
            case .multipleDisabled:
                return ("Select", UserDefaultsHelper.groupName ?? "Students")
            case .multipleEnabled:
                return ("Cancel", "Select Items")
            }
        }

        var allowsMultipleSelection: Bool {
            switch self {
            case .multipleDisabled:
                return false
            case .multipleEnabled:
                return true
            }
        }

        mutating func toggle()  {
            switch self {
            case .multipleEnabled:
                self = .multipleDisabled
            case .multipleDisabled:
                self = .multipleEnabled
            }
        }
    }
    
    var selectionMode : SelectionMode = .multipleDisabled {
        
        willSet {
            switch newValue {
            case .multipleDisabled:
                collectionView.indexPathsForSelectedItems?.forEach{
                    if let cell = collectionView.cellForItem(at: $0) as? StudentCollectionViewCell {
                        cell.hideIcon()
                    }
                    collectionView.deselectItem(at: $0, animated: false)
                }
                navigationController?.setToolbarHidden(true, animated: true)
            case .multipleEnabled:
                addBarButton.isEnabled = false
                navigationController?.setToolbarHidden(false, animated: true)
                
                print("multiple enablled")
            }
        }
        
        didSet {
            collectionView.allowsMultipleSelection = selectionMode.allowsMultipleSelection
            barButtonSelectCancel.title = selectionMode.allTitles.buttonTitle
            navigationItem.title = selectionMode.allTitles.barTitle
        }
    }

    
    var addBarButton: UIBarButtonItem = UIBarButtonItem()
    
    @IBOutlet weak var barButtonSelectCancel: UIBarButtonItem!

    
    var navBarTitle = ""
    
    var classGroupCodeInt: Int!
    var className: String! {
        didSet {
            navigationItem.title = className
        }
    }
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
        
         //       print(UserDefaults.standard.object(forKey: "name_preference") as Any)
//                UserDefaults.standard.set(20, forKey: "teacherSelected")
//                print("- - - - - -", UserDefaults.standard.object(forKey: "teacherSelected") as Any)
        //         UserDefaults.standard.set("NOOOO", forKey: "name_preference")
         //       print(UserDefaults.standard.object(forKey: "name_preference") as Any)

        
//        UserDefaultsHelper.removeGroupID()
//        UserDefaultsHelper.removeGroupName()
        
        // Customize the navigation bar
        // navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // navigationController?.navigationBar.shadowImage = UIImage()
        
        // navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.tintColor = UIColor(named: "tintContrast")
        
        print("in view did load")
//        guard UserDefaultsHelper.groupID != nil else {
//            print("it is nil")
//            print("it is nil")
//            return
//        }
//
        
        
        
        
       // addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        addBarButton = UIBarButtonItem(title: "Select App Prolfiles", style: .plain, target: self, action: #selector(addTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        addBarButton.isEnabled = false
        toolbarItems = [addBarButton, spacer]
        navigationController?.setToolbarHidden(true, animated: false)
                
        barButtonSelectCancel.title = "Select"
        collectionView.allowsMultipleSelection = false
        
        
        
        classGroupCodeInt = UserDefaultsHelper.groupID
        className = UserDefaultsHelper.groupName
        
         if classGroupCodeInt ==  nil {
            print("in about to perform segue")
             performSegue(withIdentifier: "loginScr", sender: nil)
         } else {

            // Register cell classes
            self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

             // title = navBarTitle
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
    

    @IBAction func buttonClicked(_ sender: UIBarButtonItem) {
        selectionMode.toggle()
        print(selectionMode)
        // sender.title = selectionMode.buttonTitle
        print(sender.title)
    }
    
    @objc func addTapped() {
        print("button tapped")
        performSegue(withIdentifier: "goToStudentDetail", sender: nil)
    }
    
    func setBarButtonSelected() {
        barButtonSelectCancel.title = "Select"
        selectionMode = .multipleDisabled
    }
    

    
     
    @IBAction func returnFromLoginWithClass(segue: UIStoryboardSegue) {
        guard let vc = segue.source as? LoginViewController, let groupID = vc.groupID, let groupName = vc.groupName  else { fatalError("No Class Group Code")  }
        classGroupCodeInt = groupID
        className = groupName
        print("Returned from Segue \(classGroupCodeInt)")
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        navigationItem.title = className

         // title = navBarTitle
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
    

    func updateStudentNote(passedNoted: String, user: User) {
        
        if let idx = self.users.firstIndex(of: user) {
            users[idx].notes = passedNoted
            print("Updating in the delegate the student at position \(idx) with note \(passedNoted)")
        }
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
    
    
    
    
    
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//           if let cell = collectionView.cellForItem(at: indexPath) {
//               cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
//           }
           print("itemhightlighted")
           
       }
       
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
           if let cell = collectionView.cellForItem(at: indexPath) {
               cell.contentView.backgroundColor = nil
           }
           print("itemUNhightlighted")
       }
       
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("in did select item and the item in \(indexPath.row)")
        
        switch selectionMode {
        case .multipleDisabled:
            rowSelected = indexPath.row
            collectionView.deselectItem(at: indexPath, animated: false)
            performSegue(withIdentifier: "goToStudentDetail", sender: nil)
            
        case .multipleEnabled:
            print("itemselected")
            if let cell = collectionView.cellForItem(at: indexPath) as? StudentCollectionViewCell {
                cell.showIcon()
            }
            addBarButton.isEnabled = true
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("itemDeselected")
        if let cell = collectionView.cellForItem(at: indexPath) as? StudentCollectionViewCell {
            cell.hideIcon()
        }
        guard let count = collectionView.indexPathsForSelectedItems?.count else {return}
        if count < 1 {
            addBarButton.isEnabled = false
        }
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch selectionMode {
            
        case .multipleDisabled:
            switch segue.identifier {
            case "goToStudentDetail":
                guard let studentProfileStaticTableVC = segue.destination as? StudentProfileStaticTableViewController else { fatalError(" could not segue ") }
                studentProfileStaticTableVC.user = users[rowSelected]
                studentProfileStaticTableVC.usersSelected.append(users[rowSelected])
                studentProfileStaticTableVC.notesDelegate = self
                
                studentProfileStaticTableVC.navigationItem.title =
                    studentProfileStaticTableVC.usersSelected.count == 1 ? users[rowSelected].firstName.trimmingCharacters(in: .whitespacesAndNewlines) + " " + users[rowSelected].lastName.trimmingCharacters(in: .whitespacesAndNewlines) : "* * * Multiple * * *"
                
                print("finished Segue")
            default:
                break
            }
            
        case .multipleEnabled:
            switch segue.identifier {
            case "goToStudentDetail":
                
                guard let studentProfileStaticTableVC = segue.destination as? StudentProfileStaticTableViewController else { fatalError(" could not segue ") }
                guard let indexPaths = collectionView.indexPathsForSelectedItems else {fatalError("Could not get the index paths")}
                for indexPath in indexPaths {
                    studentProfileStaticTableVC.usersSelected.append(users[indexPath.row])
                }
                
                studentProfileStaticTableVC.notesDelegate = self
                
                studentProfileStaticTableVC.navigationItem.title =
                    studentProfileStaticTableVC.usersSelected.count == 1 ? users[rowSelected].firstName.trimmingCharacters(in: .whitespacesAndNewlines) + " " + users[rowSelected].lastName.trimmingCharacters(in: .whitespacesAndNewlines) : "* * * Multiple * * *"
                selectionMode.toggle()
                print("finished Segue")
            default:
                break
            }
            
        }
    }

    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "goToStudentDetail":
            guard let studentProfileStaticTableVC = segue.destination as? StudentProfileStaticTableViewController else { fatalError(" could not segue ") }
            
            studentProfileStaticTableVC.user = users[rowSelected]
            studentProfileStaticTableVC.usersSelected.append(users[rowSelected])
//            let nextOne = rowSelected + 1
//            studentProfileStaticTableVC.usersSelected.append(users[nextOne])
            studentProfileStaticTableVC.notesDelegate = self
           
            studentProfileStaticTableVC.navigationItem.title =
                studentProfileStaticTableVC.usersSelected.count == 1 ? users[rowSelected].firstName.trimmingCharacters(in: .whitespacesAndNewlines) + " " + users[rowSelected].lastName.trimmingCharacters(in: .whitespacesAndNewlines) : "* * * Multiple * * *"
            
            print("finished Segue")
            
        default:
            break
        }
    }
    */
}
