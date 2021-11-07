////
////  NewModel.swift
////  download jamfschool student pic
////
////  Created by Steven Hertz on 1/9/21.
////
//
//import Foundation
//
//public struct ClassReturnObject: Codable {
//    
//    public let code: Int
//    public struct Clss: Codable {
//        public let uuid: String
//        public let name: String
//        public let description: String
//        public let locationId: Int
//        public let source: String
//        //        public let image: String
//        //        public let classAsmIdentifier: String
//        //        public let userGroupId: Int
//        public let studentCount: Int
//        public struct Student: Codable, Equatable {
//    
//            public static func == (lhs: Student, rhs: Student) -> Bool {
//                lhs.username == rhs.username
//            }
//
//            public let id: Int
//            public let name: String
//            public let email: String
//            public let username: String
//            public let firstName: String
//            public let lastName: String
//            public let photo: URL
//        }
//        public let students: [Student]
//        public let teacherCount: Int
//        public let deviceCount: Int
//    }
//    public let `class`: Clss
//
//}
