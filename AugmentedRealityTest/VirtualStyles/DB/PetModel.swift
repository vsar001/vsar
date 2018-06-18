//
//  PetModel.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 15.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import UIKit
import CoreData

class PetModel: NSManagedObject {
    
    //TODO: create SearchController and move var container to that class
    var container : NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    /*
     class func findPetModel(matching threeDObject: "TODO: difine athe search class", in context: NSManagedObjectContext) thrrows -> NSObject {
        
        let request: NSFetchRequest<>
        do {
            let matches = try.context.fetch(request)
            return matche[0]
        } catch {
            throw error
        }
    } */
}
