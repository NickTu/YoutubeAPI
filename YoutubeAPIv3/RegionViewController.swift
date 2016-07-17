//
//  RegionViewController.swift
//  YoutubeAPIv3
//
//  Created by 涂安廷 on 2016/7/16.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import Foundation

class RegionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func finishSearchSettings(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    let CateogryRegion = ["Asia", //1,2:亞洲,
                          "Europe", // 3:歐洲
                          "Africa", //4:非洲
                          "America", // 5,6,7美洲
                          "Oceania", //8;大洋洲
    ]
    
    var tableRegionData :Dictionary<NSObject, AnyObject> = [:]
    var RegionCodeData :Dictionary<String, String> = [:]
    var AsiaRegionArrayData :Array<String> = []
    var EuropeRegionArrayData :Array<String> = []
    var AfricaRegionArrayData :Array<String> = []
    var AmericaRegionArrayData :Array<String> = []
    var OceaniaRegionArrayData :Array<String> = []
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "RegionTableViewCell",bundle: nil), forCellReuseIdentifier: "idRegionTableViewCell")
        
        AsiaRegionArrayData = [ "Azerbaijan", // AZ : 亞塞拜然
                                "Bahrain", // BH : 巴林
        ]
        EuropeRegionArrayData = [ "Austria", // AT : 奧地利
            
        ]
        AfricaRegionArrayData = [ "Algeria", // DZ : 阿爾及利亞
            
        ]
        AmericaRegionArrayData = [ "United States", // US : 美國
                                   "Argentina", // AR : 阿根廷
        ]
        OceaniaRegionArrayData = [ "Australia", // AU : 澳大利亞
        ]
        
        tableRegionData = [ CateogryRegion[0]:AsiaRegionArrayData,
                            CateogryRegion[1]:EuropeRegionArrayData,
                            CateogryRegion[2]:AfricaRegionArrayData,
                            CateogryRegion[3]:AmericaRegionArrayData,
                            CateogryRegion[4]:OceaniaRegionArrayData,
        ]
        
        RegionCodeData = [ AsiaRegionArrayData[0]:"AZ", // AZ : 亞塞拜然
                           AsiaRegionArrayData[1]:"BH", // BH : 巴林
                           EuropeRegionArrayData[0]:"AT", // AT : 奧地利
                           AfricaRegionArrayData[0]:"DZ", // DZ : 阿爾及利亞
                           AmericaRegionArrayData[0]:"US", // US : 美國
                           AmericaRegionArrayData[1]:"AR", // AR : 阿根廷
                           OceaniaRegionArrayData[0]:"AU", // AU : 澳大利亞
        ]
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return CateogryRegion.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableRegionData[ CateogryRegion[section] ]?.count)!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let text = ( tableRegionData[ CateogryRegion[indexPath.section] ] as! NSArray )[indexPath.row] as! String
        
        if recordSearchSettings.regionCode == RegionCodeData[text] {
            recordSearchSettings.isChangeRegionCode = false
        }else {
            recordSearchSettings.isChangeRegionCode = true
            recordSearchSettings.regionCode = RegionCodeData[text]
        }
        print(recordSearchSettings.regionCode)
        /*let rowNumber =
        let lastIndex = NSIndexPath(forRow: tableData.indexOf(recordSearchSettings.videoType)!, inSection: indexPath.section)
        /*tableView.cellForRowAtIndexPath(lastIndex)!.accessoryType = .None
        tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .Checkmark*/
        recordSearchSettings.videoType = tableData[indexPath.row]*/
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CateogryRegion[section]
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idRegionTableViewCell") as! RegionTableViewCell
        
        let text = ( tableRegionData[ CateogryRegion[indexPath.section] ] as! NSArray )[indexPath.row] as! String
        cell.countryFlag.image = UIImage(named: "\(text)")
        /*if indexPath.row == tableData.indexOf(recordSearchSettings.videoType)! {
            cell!.accessoryType = .Checkmark
        }else {
            cell!.accessoryType = .None
        }*/
        //print(( tableRegionData[ CateogryRegion[indexPath.section] ] as! NSArray )[indexPath.row])
        
        cell.countryName.text = text
        return cell
    }
    
}