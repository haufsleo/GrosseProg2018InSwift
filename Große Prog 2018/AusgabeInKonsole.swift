//
//  AusgabeInKonsole.swift
//  Große Prog 2018
//
//  Created by Leo Haufs on 14.06.18.
//  Copyright © 2018 Leo Haufs. All rights reserved.
//

import Foundation

public class AusgabeInKonsole: Ausgabe{
    public func gebeAufKonsoleAus(){
        print(super.getAusgabeString())
    }
}
