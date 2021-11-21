//
//  Record+CoreDataProperties.swift
//  Swift Practice # 118 Core Data Test 3
//
//  Created by Dogpa's MBAir M1 on 2021/11/21.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var recordType: String?
    @NSManaged public var recordTime: Int64
    @NSManaged public var recordDate: Date?

}

extension Record : Identifiable {

}
