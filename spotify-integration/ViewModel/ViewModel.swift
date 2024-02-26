//
//  ViewModel.swift
//  spotify-integration
//
//  Created by Robert Brennan on 2/25/24.
//

import Foundation
import CoreData

class ViewModel: ObservableObject {
    private var managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }
}
