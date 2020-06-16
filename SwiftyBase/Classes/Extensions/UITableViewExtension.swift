//
//  UITableViewExtension.swift
//  Pods
//
//  Created by MacMini-2 on 04/09/17.
//
//

import Foundation
#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

public extension UITableView {
    
    func reloadWithAnimation()
    {
        self.reloadData()
        
        let tableHeight: CGFloat = self.bounds.size.height
        
        for cell in self.visibleCells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for cell in self.visibleCells {
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    func estimatedRowHeight(_ height: CGFloat) {
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = height
    }
    
    /// Hides the space at the top of the section style
    func hideHeaderViewSpace(_ margin: CGFloat = 0.1) {
        self.tableHeaderView = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: margin))
    }
    
    ///  Hide empty cell
    func hideEmptyCells() {
        self.tableFooterView = UIView(frame: .zero)
    }
    
    /// Dequeue reusable UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    /// - Returns: UITableViewCell object with associated class name (optional value)
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: name)) as? T
    }
    
    /// Dequeue reusable UITableViewCell using class name for indexPath
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - indexPath: location of cell in tableView.
    /// - Returns: UITableViewCell object with associated class name.
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as! T
    }
    
    /// Dequeue reusable UITableViewHeaderFooterView using class name
    ///
    /// - Parameter name: UITableViewHeaderFooterView type
    /// - Returns: UITableViewHeaderFooterView object with associated class name (optional value)
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T
    }
    
    /// Register UITableViewHeaderFooterView using class name
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the header or footer view.
    ///   - name: UITableViewHeaderFooterView type.
    func register<T: UITableViewHeaderFooterView>(nib: UINib?, withHeaderFooterViewClass name: T.Type) {
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    /// Register UITableViewHeaderFooterView using class name
    ///
    /// - Parameter name: UITableViewHeaderFooterView type
    func register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    /// Register UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    /// Register UITableViewCell using class name
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the tableView cell.
    ///   - name: UITableViewCell type.
    func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }
    
    /// Retrive all the IndexPaths for the section.
    ///
    /// - Parameter section: The section.
    /// - Returns: Return an array with all the IndexPaths.
    func indexPaths(section: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        let rows: Int = self.numberOfRows(inSection: section)
        for i in 0 ..< rows {
            let indexPath: IndexPath = IndexPath(row: i, section: section)
            indexPaths.append(indexPath)
        }
        
        return indexPaths
    }
    
    /// Retrive the next index path for the given row at section.
    ///
    /// - Parameters:
    ///   - row: Row of the index path.
    ///   - section: Section of the index path
    /// - Returns: Returns the next index path.
    func nextIndexPath(row: Int, forSection section: Int) -> IndexPath? {
        let indexPath: [IndexPath] = self.indexPaths(section: section)
        guard indexPath != [] else {
            return nil
        }
        
        return indexPath[row + 1]
    }
    
    /// Retrive the previous index path for the given row at section
    ///
    /// - Parameters:
    ///   - row: Row of the index path.
    ///   - section: Section of the index path.
    /// - Returns: Returns the previous index path.
    func previousIndexPath(row: Int, forSection section: Int) -> IndexPath? {
        let indexPath: [IndexPath] = self.indexPaths(section: section)
        guard indexPath != [] else {
            return nil
        }
        
        return indexPath[row - 1]
    }
}


public extension UITableView {
    func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }
    
    
    func insertRowsAtBottom(_ rows: [IndexPath]) {
        
        // ensure that insert row is not splash screen
        
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.beginUpdates()
        self.insertRows(at: rows, with: .none)
        self.endUpdates()
        self.scrollToRow(at: rows[0], at: .bottom, animated: false)
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }
    
    func totalRows() -> Int {
        var i = 0
        var rowCount = 0
        while i < self.numberOfSections {
            rowCount += self.numberOfRows(inSection: i)
            i += 1
        }
        return rowCount
    }
    
    var lastIndexPath: IndexPath? {
        if (self.totalRows()-1) > 0{
            return IndexPath(row: self.totalRows()-1, section: 0)
        } else {
            return nil
        }
    }
    
    
    // Call after inserting data
    func scrollBottomWithoutFlashing() {
        guard let indexPath = self.lastIndexPath else {
            return
        }
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        CATransaction.commit()
        UIView.setAnimationsEnabled(true)
    }
    
    // call after keyboard animation ends
    func scrollBottomToLastRow() {
        guard let indexPath = self.lastIndexPath else {
            return
        }
        self.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    //    func scrollToBottom(animated: Bool) {
    //        let bottomOffset = CGPoint(x: 0, y:self.contentSize.height - self.bounds.size.height)
    //        self.setContentOffset(bottomOffset, animated: animated)
    //    }
    
    var isContentInsetBottomZero: Bool {
        get { return self.contentInset.bottom == 0 }
    }
    
    func resetContentInsetAndScrollIndicatorInsets() {
        self.contentInset = UIEdgeInsets.zero
        self.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
