//
//  FileManagement.swift
//  MagicCornerDeals
//
//  Created by Giorgio Dalvit on 04/07/18.
//  Copyright © 2018 Giorgio Dalvit. All rights reserved.
//

import Foundation

class FileManagement {
    
    func loadWantsFromFile()->[String] {
        var data : [String] = []
        let fileMgr = FileManager.default
        let fileName = "wants.txt"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let url = URL(fileURLWithPath: paths.first!).appendingPathComponent(fileName)
        if(fileMgr.fileExists(atPath: url.path)){
            do{
                let fullTxt = try String.init(contentsOfFile: url.path, encoding: String.Encoding.utf8)
                let rows = fullTxt.components(separatedBy: "\n") as [String]
                for i in 0..<rows.count{
                    let want = rows[i]
                    data.append(want)
                }
                return data
            } catch let error{
                print("Error: \(error)")
            }
        }
        return data
    }
    
    func insertWantInFileUpdatingData(want : String, data :inout [String])->Bool{
        let fileMgr = FileManager.default
        let fileName = "wants.txt"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let url = URL(fileURLWithPath: paths.first!).appendingPathComponent(fileName)
        if(!fileMgr.fileExists(atPath: url.path)){
            fileMgr.createFile(atPath: url.path, contents: nil, attributes: nil)
        }
        let myText = "\(want)\n"
        let textData = Data(myText.utf8)
        do {
            //try textData.write(to: url, options: .atomic)
            let fileHandle = try FileHandle(forWritingTo: url)
            fileHandle.seekToEndOfFile()
            fileHandle.write(textData)
            fileHandle.closeFile()
            
            data.append(want)
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    func updateWantsToFile(data : [String], row : Int)->Bool{
        let fileMgr = FileManager.default
        let fileName = "wants.txt"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let url = URL(fileURLWithPath: paths.first!).appendingPathComponent(fileName)
        if(!fileMgr.fileExists(atPath: url.path)){
            fileMgr.createFile(atPath: url.path, contents: nil, attributes: nil)
        }
        var varData = data
        varData.remove(at: row)
        let textData = Data(String(varData.flatMap(addSeparator)).utf8)//Data("\(varData.joined(separator: ";;"));;".utf8)
        do {
            try textData.write(to: url, options: .atomic)
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    func addSeparator (x: String) -> String {
        return "\(x)\n"
    }
}
