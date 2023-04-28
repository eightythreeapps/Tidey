//
//  BundleFactory.swift
//  Tidey
//
//  Created by Ben Reed on 26/04/2023.
//

import Foundation

public class BundleFactory {
    
    public static func mainBundle() -> Bundle {
        return Bundle.main
    }
    
    public static func bundleFor(classType:AnyObject) -> Bundle {
        return Bundle(for: type(of: classType))
    }
    
}
