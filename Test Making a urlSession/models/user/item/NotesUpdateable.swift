//
//  NotesUpdateable.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 12/22/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

protocol NotesUpdateable {
    var identity:   String {get}
    var title:      String {get}
    var picName:    String {get}
    var notes:      String {get set}
}
