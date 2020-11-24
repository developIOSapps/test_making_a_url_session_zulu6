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
        ( "Numbers and Counting", "Learn Numbers and counting skills"),
        ( "Early Math", "Numbers and counting, and connect both to the idea of “how many"),
        ( "Letters and Sounds", "Learn the Alphabet Letters and associated sounds"),
        ( "Pre-Literacy", "Pre literacy skills. Build cvc words, spelling, movable alphabet"),
        ( "Pre-Handwriting Skills", "Practice tracing shapes, dragging objects"),
        ( "Handwriting", "Practice tracing letters and numbers"),
        ( "Thinking Skills", "Patterns, puzzles art and draw and tell"),
        ( "Curricula", "General all in one apps")
       ]

    let iconCtg: [String: String] = [
        "Numbers and Counting": "textformat.123",
        "Early Math": "list.number",
        "Letters and Sounds": "textformat.abc",
        "Pre-Literacy": "textformat.abc",
        "Pre-Handwriting Skills": "signature",
        "Handwriting": "pencil.and.ellipsis.rectangle",
        "Thinking Skills": "person.badge.plus.fill",
        "Curricula":"a"
    ]

    var appCategories = [AppCategory]()
    
    init() {
        for (idx, category) in categories.enumerated() {
            let appCategory = AppCategory(key: idx, name: category.0, description: category.1, iconName: iconCtg[category.0]!, iconType: .system)
            appCategories.append(appCategory)
        }
    }
    
    
}
