//
//  AppStore.swift
//  Template Categories
//
//  Created by Steven Hertz on 2/12/20.
//  Copyright © 2020 DevelopItSolutions. All rights reserved.
//

import Foundation

class AppStore {
    
    let appList = [
        (0,"10 fingers plus", "Profile-App-1Kiosk 10 fingers plus", "Used at home or at school, with your fingers or combined with SMART NUMBERS wooden toys, 10 fingers is the must-have app for learning to count to 10.\nDeveloped with teachers, the 10 fingers app perfectly matches kindergarten educational objectives. "),
        (0,"123 Genius PRO - First Numbers and Counting Games", "Profile-App-1Kiosk 123 Genius PRO - First Numbers and Counting Games ", "23 Genius makes learning numbers and counting fun simple and easy!\r\n\r\nFinally a FUN and EDUCATIONAL game to help little ones\r\nlearn their first numbers and counting in to time at all."),
        (3,"ABC - Magnetic Alphabet HD for Kids", "Profile-App-1Kiosk ABC - Magnetic Alphabet HD for Kids", "Elementum facilisis leo vel fringilla est ullamcorper eget nulla facilisi. Sagittis id consectetur purus ut faucibus. "),
        (2,"ABC Genius PRO - Alphabet Letters Phonics  Handwriting", "Profile-App-1Kiosk ABC Genius PRO - Alphabet Letters Phonics  Handwriting", "Tellus rutrum tellus pellentesque eu tincidunt tortor aliquam nulla. Dis parturient montes nascetur ridiculus mus mauris vitae ultricies. "),
        (1,"Alphabet Sounds Word Study", "Profile-App-1Kiosk Alphabet Sounds Word Study", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ipsum suspendisse ultrices gravida dictum. "),
        (1,"Butterfly Math", "Profile-App-1Kiosk Butterfly Math", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
        (1,"Categories - Categorization Skill Development App", "Profile-App-1Kiosk Categories - Categorization Skill Development App", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ipsum suspendisse ultrices gravida dictum. "),
        (0,"Count, Sort and Match", "Profile-App-1Kiosk Count, Sort and Match", "****Featured in Kids Best iPad Apps – “Count, Sort and Match” simplifies key math concepts for preschool kids up to age 6. The app helps kids to count to 20, spell numbers, and sort by color, shape and size to preschool children."),
        (0,"Counting Bear - Easily Learn How to Count", "Profile-App-1Kiosk Counting Bear - Easily Learn How to Count", "Endorsed by parents, teachers, and toddlers.\n\nGrasshopper Apps = Top Educational Apps for Kids :-) \n\nWarning: Your child will keep begging for your iPhone or iPad after they try this app."),
        (0,"Counting Dots: Number Practice", "Profile-App-1Kiosk Counting Dots: Number Practice", "Build counting confidence while having fun in this colorful counting game.  Counting Dots is a colorful counting game that will hold a child’s attention.  Helping kids learn to count from one to one million!"),
        (6,"Doodle Buddy Paint Draw App", "Profile-App-1Kiosk Doodle Buddy Paint Draw App", "Vitae sapien pellentesque habitant morbi tristique senectus et. In massa tempor nec feugiat nisl pretium fusce id. Turpis tincidunt id aliquet risus feugiat in ante. "),
        (6,"Draw and Tell HD", "Profile-App-1Kiosk Draw and Tell HD", "Vel fringilla est ullamcorper eget nulla facilisi etiam. Magna fringilla urna porttitor rhoncus dolor. Dui accumsan sit amet nulla facilisi morbi tempus. "),
        (2,"Endless Alphabet", "Profile-App-1Kiosk Endless Alphabet", "Elementum facilisis leo vel fringilla est ullamcorper eget nulla facilisi. Sagittis id consectetur purus ut faucibus. "),
        (1,"Feed the Monkey", "Profile-App-1Kiosk Feed the Monkey", "Tellus rutrum tellus pellentesque eu tincidunt tortor aliquam nulla. Dis parturient montes nascetur ridiculus mus mauris vitae ultricies. "),
        (2,"First Letters and Phonics", "Profile-App-1Kiosk First Letters and Phonics", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ipsum suspendisse ultrices gravida dictum. "),
        (3,"First Words Deluxe", "Profile-App-1Kiosk First Words Deluxe", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
        (6,"Following Directions Game", "Profile-App-1Kiosk Following Directions Game", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ipsum suspendisse ultrices gravida dictum. "),
        (6,"Geoboard by The Math Learning Center", "Profile-App-1Kiosk Geoboard by The Math Learning Center", "Tellus rutrum tellus pellentesque eu tincidunt tortor aliquam nulla. Dis parturient montes nascetur ridiculus mus mauris vitae ultricies. "),
        (5,"iTrace - handwriting for kids", "Profile-App-1Kiosk iTrace - handwriting for kids", "Elementum facilisis leo vel fringilla est ullamcorper eget nulla facilisi. Sagittis id consectetur purus ut faucibus. "),
        (6,"Learning Patterns PRO - Develop Thinking Skills", "Profile-App-1Kiosk Learning Patterns PRO - Develop Thinking Skills", "Vel fringilla est ullamcorper eget nulla facilisi etiam. Magna fringilla urna porttitor rhoncus dolor. Dui accumsan sit amet nulla facilisi morbi tempus. "),
        (5,"LetterSchool - Block Letters", "Profile-App-1Kiosk LetterSchool - Block Letters", "Vitae sapien pellentesque habitant morbi tristique senectus et. In massa tempor nec feugiat nisl pretium fusce id. Turpis tincidunt id aliquet risus feugiat in ante. "),
        (1,"Line em Up", "Profile-App-1Kiosk Line em Up", "Vel fringilla est ullamcorper eget nulla facilisi etiam. Magna fringilla urna porttitor rhoncus dolor. Dui accumsan sit amet nulla facilisi morbi tempus. "),
        (4,"Little Writer Tracing App: Trace Letters & Numbers", "Profile-App-1Kiosk Little Writer Tracing App: Trace Letters & Numbers", "Elementum facilisis leo vel fringilla est ullamcorper eget nulla facilisi. Sagittis id consectetur purus ut faucibus. "),
        (1,"Monkey Math School Sunshine", "Profile-App-1Kiosk Monkey Math School Sunshine", "Vel fringilla est ullamcorper eget nulla facilisi etiam. Magna fringilla urna porttitor rhoncus dolor. Dui accumsan sit amet nulla facilisi morbi tempus. "),
        (7,"Monkey Preschool Fix-It", "Profile-App-1Kiosk Monkey Preschool Fix-It", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ipsum suspendisse ultrices gravida dictum. "),
        (7,"Monkey Preschool Lunchbox", "Profile-App-1Kiosk Monkey Preschool Lunchbox", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
        (1,"Montessori Numbers for Kids", "Profile-App-1Kiosk Montessori Numbers for Kids", "Tellus rutrum tellus pellentesque eu tincidunt tortor aliquam nulla. Dis parturient montes nascetur ridiculus mus mauris vitae ultricies. "),
        (1,"Moose Math - Duck Duck Moose", "Profile-App-1Kiosk Moose Math - Duck Duck Moose", "Elementum facilisis leo vel fringilla est ullamcorper eget nulla facilisi. Sagittis id consectetur purus ut faucibus. "),
        (1,"Park Math HD - Duck Duck Moose", "Profile-App-1Kiosk Park Math HD - Duck Duck Moose", "Vel fringilla est ullamcorper eget nulla facilisi etiam. Magna fringilla urna porttitor rhoncus dolor. Dui accumsan sit amet nulla facilisi morbi tempus. "),
        (7,"PreK Letters and Numbers Learning Tracing Games", "Profile-App-1Kiosk PreK Letters and Numbers Learning Tracing Games", "Tellus rutrum tellus pellentesque eu tincidunt tortor aliquam nulla. Dis parturient montes nascetur ridiculus mus mauris vitae ultricies. "),
        (4,"Ready to Print", "Profile-App-1Kiosk Ready to Print", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
        (2,"Rhyming Words", "Profile-App-1Kiosk Rhyming Words", "Vitae sapien pellentesque habitant morbi tristique senectus et. In massa tempor nec feugiat nisl pretium fusce id. Turpis tincidunt id aliquet risus feugiat in ante. "),
        (7,"ShapeBuilder Preschool Puzzles", "Profile-App-1Kiosk ShapeBuilder Preschool Puzzles", "Vel fringilla est ullamcorper eget nulla facilisi etiam. Magna fringilla urna porttitor rhoncus dolor. Dui accumsan sit amet nulla facilisi morbi tempus. "),
        (3,"SPELLING MAGIC 1 for Schools", "Profile-App-1Kiosk SPELLING MAGIC 1 for Schools", "Elementum facilisis leo vel fringilla est ullamcorper eget nulla facilisi. Sagittis id consectetur purus ut faucibus. "),
        (2,"Starfall ABCs", "Profile-App-1Kiosk Starfall ABCs", "Vel fringilla est ullamcorper eget nulla facilisi etiam. Magna fringilla urna porttitor rhoncus dolor. Dui accumsan sit amet nulla facilisi morbi tempus. "),
        (0,"TallyTots Counting", "Profile-App-1Kiosk TallyTots Counting", "Get the action-packed app that helps toddlers learn to count with 20 awesome mini-games. Whether they're serving up a seven-layer sandwich or finding 14 colorful cupcakes, they'll have fun with numbers in this awesome learning game"),
        (7,"TeachMe: Preschool / Toddler", "Profile-App-1Kiosk TeachMe: Preschool / Toddler", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ipsum suspendisse ultrices gravida dictum. "),
        (4,"Todo Number Matrix: Brain teasers logic puzzles  mathema", "Profile-App-1Kiosk Todo Number Matrix: Brain teasers logic puzzles  mathema", "Vitae sapien pellentesque habitant morbi tristique senectus et. In massa tempor nec feugiat nisl pretium fusce id. Turpis tincidunt id aliquet risus feugiat in ante. "),
        (3,"Word Wagon by Duck Duck Moose", "Profile-App-1Kiosk Word Wagon by Duck Duck Moose", "Vel fringilla est ullamcorper eget nulla facilisi etiam. Magna fringilla urna porttitor rhoncus dolor. Dui accumsan sit amet nulla facilisi morbi tempus. "),
        (3,"Word Wizard for Kids School Ed", "Profile-App-1Kiosk Word Wizard for Kids School Ed4", "Elementum facilisis leo vel fringilla est ullamcorper eget nulla facilisi. Sagittis id consectetur purus ut faucibus. ")
    ]

    
    var apps = [App]()
    
    init() {
        for (_, app) in appList.enumerated() {
            let app = App(key: app.0, name: app.1, kioskName: app.2, description: app.3)
            apps.append(app)
        }
    }

}
