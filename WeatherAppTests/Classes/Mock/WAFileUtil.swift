//
//  FileUtil.swift
//  WeatherAppTests
//
//  Created by Girish Muchalambe on 12/04/23.
//

import Foundation

class WAFileUtil {
    
    var fileName : String!
    var ext : String!
    
    public init(fileName : String!, ext : String! = "json") {
        self.fileName = fileName
        self.ext = ext
    }
    
    public func getData() -> Data? {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: fileName, ofType: ext)!
        
        var data : Data?
        
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        } catch let error {
            #if DEBUG
            print(error.localizedDescription)
            #endif
        }
        
        return data
    }
}
