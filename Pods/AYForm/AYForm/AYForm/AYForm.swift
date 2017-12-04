//
//  AYForm.swift
//  JoCars
//
//  Created by Ayman Rawashdeh on 3/29/17.
//  Copyright © 2017 Ayman Rawashdeh. All rights reserved.
//
import UIKit

public typealias Output = (String, label: String)
public typealias Cell = (identifier: String, uniqueIdentifier: String?, section: Int, outputs: [AYFormOutput])


public protocol AYFormDelegate {
    
    @available( *, deprecated: 0.2.0, message: "Please use the new AYFormDataSource instead")
    func form(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, label: String, cell : UITableViewCell, field: Any, output: Output)
    
    @available( *, deprecated: 0.2.0, message: "Please use the new AYFormDataSource")
    func form(_ tableView: UITableView, cellForRowAt indexPath: IndexPath,cell : UITableViewCell, cellIdentifier: String)
    
    @available( *, deprecated: 0.2.0, message: "Please use the new AYFormDataSource instead")
    func form(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    
    @available( *, deprecated: 0.2.0, message: "Please use the new AYFormDataSource instead")
    func form(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
}

@objc public protocol AYFormDataSource: NSObjectProtocol {
    
    @objc optional func form(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, label: String, field: Any, cell : UITableViewCell)
    @objc optional func form(_ tableView: UITableView, cellForRowAt indexPath: IndexPath,cell : UITableViewCell, cellIdentifier: String, uniqueIdentifier: String!)
    
    @objc optional func form(_ tableView: UITableView, titleForHeaderInSection section: Int, isHiddenSection: Bool) -> String?
    @objc optional func form(_ tableView: UITableView, titleForFooterInSection section: Int, isHiddenSection: Bool) -> String?
}


public class AYForm: NSObject, UITableViewDataSource  {
    
    public var fieldsArray = [AYFormCell]()
    
    @available( *, deprecated: 0.2.0, message: "Please use the new AYFormDataSource instead")
    public var delegate: AYFormDelegate?
    
    public var dataSource: AYFormDataSource?
    public var numberOfSections: Int = 1
    
    private var indexSet = IndexSet()
    private var refrenceDictionary = [String: AnyObject]()
    
    
    public override init() {
        super.init()
        
        populateSectionsSet()
    }
   
    public init(numberOfSections: Int){
        super.init()
        
        self.numberOfSections = numberOfSections
        populateSectionsSet()
    }
    
    private func populateSectionsSet(){
    
        for index in 0...(numberOfSections - 1){
            
            indexSet.insert(index)
        }
    }
    
    public func addFields(cellIdentifier: String, forSection: Int, outputs: (String, String)!...){
        
        let cell = AYFormCell(identifier: cellIdentifier, uniqueIdentifier: nil, section: forSection, outputs: AYFormOutput.getOutputs(outputs))
        fieldsArray.append(cell)
    }
    
    public func addFields(cellIdentifier: String, uniqueIdentifier: String!, forSection: Int, outputs: (String, String)!...){
        
        let cell = AYFormCell(identifier: cellIdentifier, uniqueIdentifier: uniqueIdentifier, section: forSection, outputs: AYFormOutput.getOutputs(outputs))
        fieldsArray.append(cell)
        
    }
    
    public func addField(cellIdentifier: String, fieldOutput: String, label: String){
        
        let cell = fieldsArray.filter({$0.identifier == cellIdentifier}).first
        cell?.outputs.append(AYFormOutput(fieldOutput: fieldOutput, label: label))
    }
    
    public func addField(unequeIdentifier: String, fieldOutput: String, label: String){
        
        let cell = fieldsArray.filter({$0.uniqueIdentifier == unequeIdentifier}).first
        cell?.outputs.append(AYFormOutput(fieldOutput: fieldOutput, label: label))
    }
    
    public func addCell(cellIdentifier: String, uniqueIdentifier: String!, forSection: Int){
        
        if let uniqueIdentifier = uniqueIdentifier, isUnique(identifier: uniqueIdentifier) == false {
            
            print("You are trying to add cell with uniqueIdentifier that is already exists")
            return
        }
        
        let cell = AYFormCell(identifier: cellIdentifier, uniqueIdentifier: uniqueIdentifier, section: forSection, outputs: nil)
        fieldsArray.append(cell)
    }
    
    public func addCell(cellIdentifier: String, uniqueIdentifier: String, inSection: Int, forTableView: UITableView!){
        
        if isUnique(identifier: uniqueIdentifier) == false {
            
            print("You are trying to add cell with uniqueIdentifier that is already exists")
            return
        }
        
        let cell = AYFormCell(identifier: cellIdentifier, uniqueIdentifier: uniqueIdentifier, section: inSection, outputs: nil)
        fieldsArray.append(cell)
        
        if let index = index(for: cell) {
            
            let indexPath = IndexPath(row: index, section: cell.section)
            forTableView?.insertRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    public func removeCell(uniqueIdentifier: String, tableView: UITableView!){
        
        for (arrayIndex, cell) in fieldsArray.enumerated() {
            
            if cell.uniqueIdentifier == uniqueIdentifier {
                
                if let index = index(for: cell) {
                    fieldsArray.remove(at: arrayIndex)
                    let indexPath = IndexPath(row: index, section: cell.section)
                    tableView?.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func isUnique(identifier: String) -> Bool {
        
        for cell in fieldsArray {
            
            if cell.uniqueIdentifier == identifier {
                
                return false
            }
        }
        
        return true
    }
    
    public func hideCell(uniqueIdentifier: String) {
        hideCell(uniqueIdentifier: uniqueIdentifier, tableView: nil)
    }
    
    public func hideCell(uniqueIdentifier: String, tableView: UITableView!) {
        
        if let cell = fieldsArray.filter({$0.uniqueIdentifier == uniqueIdentifier}).first{
            
            if cell.isHidden {
                return
            }
            
            cell.isHidden = true
            
            if let index = index(for: cell) {
                
                let indexPath = IndexPath(row: index, section: cell.section)
                tableView?.deleteRows(at: [indexPath], with: .automatic)
            }
            
        }
    }
    
    public func showCell(uniqueIdentifier: String, tableView: UITableView!) {
        
        if let cell = fieldsArray.filter({$0.uniqueIdentifier == uniqueIdentifier}).first{
            
            if !cell.isHidden {
                return
            }
            
            cell.isHidden = false
            
            if let index = index(for: cell) {
                
                let indexPath = IndexPath(row: index, section: cell.section)
                tableView?.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    public func toggleCell(uniqueIdentifier: String, tableView: UITableView) {
        
        if let cell = fieldsArray.filter({$0.uniqueIdentifier == uniqueIdentifier}).first{
            
            cell.isHidden = !cell.isHidden
            
            if let index = index(for: cell) {
                
                let indexPath = IndexPath(row: index, section: cell.section)
                
                if cell.isHidden {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }else{
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }
                
            }
        }
    }
    
    public func hide(section: Int, tableView: UITableView) {
        
        if indexSet.remove(section) != nil {
            
            var indexSet2 = IndexSet()
            indexSet2.insert(section)
            
            tableView.deleteSections(indexSet2, with: .bottom)
        }
    }
    
    public func show(section: Int, tableView: UITableView) {
       
        let countBefore = indexSet.count
        
        indexSet.insert(section)
        if indexSet.count == countBefore {
            
            return
        }
        
        
        var indexSet2 = IndexSet()
        indexSet2.insert(section)
        
        tableView.insertSections(indexSet2, with: .top)
        
        
    }
    
    public func index(for cell: AYFormCell) -> Int?{
        
        let cellsInSection = fieldsArray.filter({$0.section == cell.section})
        
        for (index, value) in cellsInSection.enumerated() {
            
            if value === cell {
                
                return index
                
            }
        }
        
        return nil
    }
    
    public func fields(inSection: Int) -> [AYFormCell]{
        
        return fieldsArray.filter({$0.section == inSection && $0.isHidden == false})
    }
    
    public func field(label: String) -> AnyObject? {
        
        return refrenceDictionary[label]
    }
    
    public func fields() -> [AnyObject] {
        
        var array = [AnyObject]()
        
        for value in refrenceDictionary.values {
            
            array.append(value)
        }
        
        return array
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return indexSet.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields(inSection: section).count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let field = fields(inSection: indexPath.section)[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: field.identifier, for: indexPath)
        
        for output in field.outputs {
            
            if let Field = cell.safeValue(forKey: output.fieldOutput) {
                
                refrenceDictionary[output.label] = Field as AnyObject
                
                // FIX: Deprecated method it will be removed in version 0.3.0
                delegate?.form(tableView, cellForRowAt: indexPath, label: output.label, cell: cell, field: Field, output: (output.fieldOutput, output.label))
                
                if dataSource?.responds(to: #selector(dataSource?.form(_:cellForRowAt:label:field:cell:))) == true {
                    
                    dataSource?.form!(tableView, cellForRowAt: indexPath, label: output.label, field: Field, cell: cell)
                }
                
            }else{
                
                print("(: AYForm :) Couldn't find output: ", output.fieldOutput)
            }
        }
        
        // FIX: Deprecated method it will be deleted in version 0.3.0
        delegate?.form(tableView, cellForRowAt: indexPath, cell: cell, cellIdentifier: field.identifier)
        
        if dataSource?.responds(to: #selector(dataSource?.form(_:cellForRowAt:cell:cellIdentifier:uniqueIdentifier:))) == true {
            
            dataSource?.form!(tableView, cellForRowAt: indexPath, cell: cell, cellIdentifier: field.identifier, uniqueIdentifier: field.uniqueIdentifier)
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if dataSource?.responds(to: #selector(dataSource?.form(_:titleForHeaderInSection:isHiddenSection:))) == true {
            
            return dataSource?.form!(tableView, titleForHeaderInSection: section, isHiddenSection: !indexSet.contains(section))
        }
        
        // FIX: Deprecated method it will be deleted in version 0.3.0
        return delegate?.form(tableView, titleForHeaderInSection: section)
        
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if dataSource?.responds(to: #selector(dataSource?.form(_:titleForFooterInSection:isHiddenSection:))) == true {
            
            
           return dataSource?.form!(tableView, titleForFooterInSection: section, isHiddenSection: !indexSet.contains(section))
        }
        
        
        
        // FIX: Deprecated method it will be deleted in version 0.3.0
        return delegate?.form(tableView, titleForFooterInSection: section)
    }
    
}



public extension NSObject {
    func safeValue(forKey key: String) -> Any? {
        let copy = Mirror(reflecting: self)
        for child in copy.children.makeIterator() {
            if let label = child.label, label == key {
                return child.value
            }
        }
        return nil
    }
}
