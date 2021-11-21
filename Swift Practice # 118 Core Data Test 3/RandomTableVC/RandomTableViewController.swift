//
//  RandomTableViewController.swift
//  Swift Practice # 118 Core Data Test 3
//
//  Created by Dogpa's MBAir M1 on 2021/11/21.
//

import UIKit
import CoreData

class RandomTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   //取得Core data
    var record: [Record]?                                                                           //變數指派為Core data定義的Record的Array
    var timer = Timer()                                                                             //指派timer為時間type
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //執行兩個自定義Function
        createDataInDesignatedTIme ()
        fetchInfo()
    }

    //嘗試讀取Core Data資料庫內容
    func fetchInfo() {
        do {
            self.record = try context.fetch(Record.fetchRequest()) //(request)//(RecordInfo.fetchRequest())另外寫法
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{
            print(error)
        }

    }
    
    //指定時間執行自定義Function   addRandomData來產生資料
    func createDataInDesignatedTIme () {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(addRandomData), userInfo: nil, repeats: true)
    }
    
    //產生資料的Function
    @objc func addRandomData () {
        let recordRandom = Int.random(in: 1...9999)
        let date = Date()
        print("本次產生成績秒數\((recordRandom))")
        
        //取得Coredata後指派給recordResult
        //接著指派recordResult內自定義的Type內容後透過context.save()儲存
        let recordResult = Record(context: context)
        recordResult.recordDate = date
        recordResult.recordType = typeArray.randomElement()
        recordResult.recordTime = Int64(recordRandom)
        
        try! context.save()

        print("")
        //儲存後再回去Core Data讀取資料
        fetchInfo()
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //core data最早最早是沒有資料的所以透過預設初始值給0以防止閃退
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return record?.count ?? 0
    }

    
    //tableView顯示的內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RandomTableViewCell", for: indexPath) as? RandomTableViewCell else {return UITableViewCell()}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        
        cell.allRecordLabel.text = "記錄時間：\(record![indexPath.row].recordTime)\n紀錄種類：\(record![indexPath.row].recordType!)\n記錄日期：\(dateFormatter.string(from: record![indexPath.row].recordDate!))"
        return cell
    }
    

    

}
