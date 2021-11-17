//
//  User.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 8/9/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

struct JSUser: OurCodable, NotesUpdateable {
    static func doConvert() {
        print("do convert")
    }
    
    let id:             Int
    let firstName:      String
    let lastName:       String
    let username:       String
    var notes:          String
    var title:          String  { firstName }
    var picName:        String  { username  }
    var identity:       String  {String(id) }

}

extension JSUser: Equatable {
  static func == (lhs: JSUser, rhs: JSUser) -> Bool {
    return lhs.id == rhs.id 
  }
}
