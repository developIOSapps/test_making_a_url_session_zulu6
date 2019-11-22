//
//  Student.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/21/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

struct Student: Codable {
    var  username                  : String  =  ""
    var  firstName                 : String  =  ""
    var  lastName                  : String  =  ""
    var  notes                     : String  =  ""
    var  mondayName                : String  =  ""
    var  mondayId                  : Int = 0
    var  tuesdayName               : String  =  ""
    var  tuesdayId                 : Int = 0
    var  wednesdayName             : String  =  ""
    var  wednesdayId               : Int = 0
    var  thursdayName              : String  =  ""
    var  thursdayId                : Int = 0
    var  fridayName                : String  =  ""
    var  fridayId                  : Int  =  0
    
    var  makeNote: String {
        return   [mondayName, tuesdayName, wednesdayName, thursdayName, fridayName].joined(separator: ";")
    }
    
    
    static func getStudentFromUser(_ user: User) -> Student {
        
        /// Setup
        let delimeter = "~#~"
        
        /// Function Call
        do {
            let (extractedString, cleanString) = try HelperFunctions.getStringFrom(passedString: user.notes, using: delimeter)
            
            /// Process Cleaned String
            print("This is the clean string",cleanString)
 
            /// Get the notes
            let cleanedNotes = cleanString
            
            
            /// Process Extracted String - Split the string and get the profiles
            let studentsNotesAppProfileArray = String(extractedString).split(separator: ";", omittingEmptySubsequences: false)
            var mondayName = ""
            var tuesdayName = ""
            var wednesdayName = ""
            var thursdayName = ""
            var fridayName = ""
            if studentsNotesAppProfileArray.count == 5 {
                mondayName = String(studentsNotesAppProfileArray[0])
                tuesdayName = String(studentsNotesAppProfileArray[1])
                wednesdayName = String(studentsNotesAppProfileArray[2])
                thursdayName = String(studentsNotesAppProfileArray[3])
                fridayName = String(studentsNotesAppProfileArray[4])
            }
            
            
            /*
            /// Load Profiles
            for (idx, item)  in studentsNotesAppProfileArray.enumerated() {
                profileForTheDayArray[idx] = (String(item))
            }
            */
            
            let newStudent = Student(username: user.username, firstName: user.firstName, lastName: user.lastName, notes: cleanedNotes, mondayName: mondayName, mondayId: 0, tuesdayName: tuesdayName, tuesdayId: 0, wednesdayName: wednesdayName, wednesdayId: 0, thursdayName: thursdayName, thursdayId: 0, fridayName: fridayName, fridayId: 0)
            return newStudent
        }
        catch  {
            return Student()
        }
    }
    
    
    
    
    static func getTheStudent() -> Student {
        if let jsonData = UserDefaults.standard.data(forKey: "student") {
            let jsonDecoder = JSONDecoder()
            let student = try! jsonDecoder.decode(Student.self, from: jsonData)
            return student
        }
        else {
            return Student(username: "DovidStein", firstName: "Dovid", lastName: "Stein")
        }
    }
    
    static func saveTheStudent(_ student: Student) {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(student)
        UserDefaults.standard.set(jsonData, forKey: "student")
        UserDefaults.standard.synchronize()
    }
}
