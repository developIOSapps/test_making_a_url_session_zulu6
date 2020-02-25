//
//  AppCategoriesStore.swift
//  Template Categories
//
//  Created by Steven Hertz on 2/12/20.
//  Copyright © 2020 DevelopItSolutions. All rights reserved.
//

import Foundation

class AppCategoryStore {
    
    let categories = [
       ( "Curricula", "General all in one apps"),
        ( "Early Math", "Numbers and counting, and connect both to the idea of “how many"),
        ( "Handwriting", "Practice tracing letters and numbers"),
        ( "Letters and Sounds", "Learn the Alphabet Letters and associated sounds"),
        ( "Numbers and Counting", "Learn Numbers and counting skills"),
        ( "Pre-Literacy", "Pre literacy skills. Build cvc words, spelling, movable alphabet"),
        ( "Pre-Handwriting Skills", "Practice tracing shapes, dragging objects"),
        ( "Thinking Skills", "Patterns, puzzles art and draw and tell")
       ]

    let iconCtg: [String: String] = [
        "Curricula":"a",
        "Early Math": "list.number",
        "Handwriting": "pencil.and.ellipsis.rectangle",
        "Letters and Sounds": "textformat.abc",
        "Numbers and Counting": "textformat.123",
        "Pre-Literacy": "textformat.abc",
        "Pre-Handwriting Skills": "signature",
        "Thinking Skills": "person.badge.plus.fill"
    ]

    var appCategories = [AppCategory]()
    
    init() {
        for (idx, category) in categories.enumerated() {
            let appCategory = AppCategory(key: idx, name: category.0, description: category.1, iconName: iconCtg[category.0]!, iconType: .system)
            appCategories.append(appCategory)
        }
    }
    
    
}
