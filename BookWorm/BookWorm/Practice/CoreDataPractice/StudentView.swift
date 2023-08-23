//
//  StudentView.swift
//  BookWorm
//
//  Created by Anay Sahu on 7/30/23.
//

import SwiftUI

//struct StudentView: View {
//    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student>
//    @Environment(\.managedObjectContext) var moc
//    
//    var body: some View {
//        VStack {
//            List(students) { student in
//                Text(student.name ?? "Unknown")
//            }
//            
//            Button("Add Student") {
//                let student = Student(context: moc)
//                let fNames = ["Harry", "Ron", "Hermoine"]
//                let lNames = ["Potter", "Weasly", "Granger"]
//                let name = "\(fNames.randomElement()!) \(lNames.randomElement()!)"
//                student.id = UUID()
//                student.name = name
//                
//                
//                try? moc.save()
//            }
//        }
//    }
//}
//
//struct StudentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StudentView()
//    }
//}
