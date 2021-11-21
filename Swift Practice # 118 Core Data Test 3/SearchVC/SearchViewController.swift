//
//  SearchViewController.swift
//  Swift Practice # 118 Core Data Test 3
//
//  Created by Dogpa's MBAir M1 on 2021/11/21.
//

import UIKit
import CoreData


//導入UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate
class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {

    
    
    @IBOutlet weak var selectResultTableView: UITableView!                                          //tableView
    
    @IBOutlet weak var selectPickerView: UIPickerView!                                              //pickerView
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   //coredata
    
    var record: [Record]?                                                                           //存指定選取資料的record Array
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchSeletData(type: typeArray[0])
    }
    
    //透過NSPredicate取得指定的種類名稱的資料
    //再透過NSSortDescriptor排序資料
    //request.fetchLimit指派只拿最小的七筆資料
    //排序後的資料再指派給record
    func fetchSeletData(type:String) {
        do{
            let request = Record.fetchRequest() as NSFetchRequest<Record>
            let pred = NSPredicate(format: "recordType CONTAINS '\(type)'")
            let sort = NSSortDescriptor(key: "recordTime", ascending: true)
            
            request.predicate = pred
            request.fetchLimit = 7
            request.sortDescriptors = [sort]
            self.record = try context.fetch(request)
            //self.record = try context.fetch(Record.fetchRequest())
            
            DispatchQueue.main.async {
                self.selectResultTableView.reloadData()
            }
        }catch{
            
        }
    }
    
    

    //Table View 相關
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return record?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        
        cell.searchLabel.text = "記錄時間：\(record![indexPath.row].recordTime)\n紀錄種類：\(record![indexPath.row].recordType!)\n記錄日期：\(dateFormatter.string(from: record![indexPath.row].recordDate!))"
        return cell
    }

    
    
    
    
    
    
    //Picker View 相關
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeArray[row]
    }
    
    //選到指定的row指派row的值給selectIndex，再透過selectIndex取得typeArray的字串內容
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectIndex = selectPickerView.selectedRow(inComponent: 0)
        fetchSeletData(type: typeArray[selectIndex])
        
        print(typeArray[selectIndex])
    }
    

}



