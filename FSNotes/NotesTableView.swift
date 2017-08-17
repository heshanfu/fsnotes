//
//  NotesTableView.swift
//  FSNotes
//
//  Created by Oleksandr Glushchenko on 7/31/17.
//  Copyright © 2017 Oleksandr Glushchenko. All rights reserved.
//

import Cocoa

class NotesTableView: NSTableView, NSTableViewDataSource,
    NSTableViewDelegate {
    
    var noteList = [Note]()
    
    override func draw(_ dirtyRect: NSRect) {
        self.dataSource = self
        self.delegate = self
        super.draw(dirtyRect)
    }
    
    override func keyUp(with event: NSEvent) {
        // Tab
        if (event.keyCode == 48) {
            let viewController = self.window?.contentViewController as? ViewController
            viewController?.focusEditArea()
        }
        
        super.keyUp(with: event)
    }
    
    func removeNote(_ note: Note) {
        note.remove()
        
        let viewController = self.window?.contentViewController as! ViewController
        viewController.editArea.string = ""
        viewController.updateTable(filter: "")
        
        // select next note if exist
        let nextRow = selectedRow
        if (noteList.indices.contains(nextRow)) {
            self.selectRowIndexes([nextRow], byExtendingSelection: false)
        }
    }
    
    // Custom note highlight style
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return NoteRowView()
    }
    
    // Populate table data
    func numberOfRows(in tableView: NSTableView) -> Int {
        return noteList.count
    }
    
    // On selected row show notes in right panel
    func tableViewSelectionDidChange(_ notification: Notification) {
        let viewController = self.window?.contentViewController as? ViewController
        
        if (noteList.indices.contains(selectedRow)) {
            viewController?.editArea.fill(note: noteList[selectedRow])
        }
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return noteList[row]
    }
    
    func getNoteFromSelectedRow() -> Note {
        var note = Note()
        var selected = self.selectedRow
        
        if (selected < 0) {
            selected = 0
        }
        
        if (noteList.indices.contains(selected)) {
            let viewController = self.window?.contentViewController as! ViewController
            let id = noteList[selected].id
            note = viewController.storage.noteList[id]
        }
        
        return note
    }
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if (
            event.keyCode == 16
            && event.modifierFlags.contains(.command)) {
            return true
        }
        
        return super.performKeyEquivalent(with: event)
    }
    
}
