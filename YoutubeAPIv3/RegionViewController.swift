//
//  RegionViewController.swift
//  YoutubeAPIv3
//
//  Created by 涂安廷 on 2016/7/16.
//  Copyright © 2016年 涂安廷. All rights reserved.
//

import Foundation

class RegionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func finishSearchSettings(sender: UIBarButtonItem) {
        
        if countryRegion.regionCode == regionCode {
            common.isSearch = false
        }else {
            common.isSearch = true
            countryRegion.regionCode = regionCode
        }

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    let CateogryRegion = [
        "Asia", //1,2:亞洲,
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
    
    var regionCode:String = ""
    var headerTag:Int = 0
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        tableView.registerNib(UINib(nibName: "RegionTableViewCell",bundle: nil), forCellReuseIdentifier: "idRegionTableViewCell")
        regionCode = countryRegion.regionCode
        headerTag = countryRegion.section
        
        AsiaRegionArrayData = [
            "Azerbaijan", // AZ : 亞塞拜然
            "Bahrain", // BH : 巴林
            "Georgia", // GE : 喬治亞
            "Hong Kong", // HK : 香港
            "India", // IN : 印度
            "Indonesia", // ID : 印尼
            "Iraq", // IQ : 伊拉克
            "Israel", // IL : 以色列
            "Japan", // JP : 日本
            "Jordan", // JO : 約旦
            "Kazakhstan", // KZ : 哈薩克
            "Kuwait", // KW : 科威特
            "Lebanon", // LB : 黎巴嫩
            "Malaysia", // MY : 馬來西亞
            "Nepal", // NP : 尼伯爾
            "Oman", // OM : 阿曼
            "Pakistan", // PK : 巴基斯坦
            "Poland", // PH : 菲律賓
            "Qatar", // QA : 庫達(卡達)
            "Saudi Arabia", // SA : 沙烏地阿拉伯
            "Singapore", // SG : 新加坡
            "South Korea", // KR : 大韓民國
            "Sri Lanka", // LK : 斯里蘭卡
            "Taiwan", // TW : 中華民國
            "Thailand", // TH : 泰國
            "United Arab Emirates", // AE : 阿拉伯聯合大公國
            "Vietnam", // VN : 越南
            "Yemen", // YE : 北葉門
        ]
        EuropeRegionArrayData = [
            "Austria", // AT : 奧地利
            "Belarus", // BY : 白俄羅斯
            "Belgium", // BE : 比利時
            "Bosnia and Herzegovina", // BA : 波士尼亞
            "Bulgaria", // BG : 保加利亞
            "Croatia", // HR : 克羅埃西亞
            "Czech Republic", // CZ : 捷克
            "Denmark", // DZ : 丹麥
            "Estonia", // EE : 愛沙尼亞
            "Finland", // FI : 芬蘭
            "France", // FR : 法國
            "Germany", // DE : 德國
            "Greece", // GR : 希臘
            "Hungary", // HU : 匈牙利
            "Iceland", // IS : 冰島
            "Ireland", // IE : 愛爾蘭
            "Italy", // IT : 義大利
            "Latvia", // LV : 拉脫維亞
            "Lithuania", // LT : 立陶宛
            "Luxembourg", // LU : 盧森堡
            "Macedonia", // MK : 馬其頓
            "Montenegro", // ME : 蒙特尼哥羅
            "Netherlands", // NL : 荷蘭
            "Norway", // NO : 挪威
            "Portugal", // PT : 葡萄牙
            "Romania", // RO : 羅馬尼亞
            "Russia", // RU : 俄羅斯聯邦
            "Serbia", // RS : 塞爾維亞
            "Slovakia", // SK : 斯洛伐克
            "Slovenia", // SI : 斯洛凡尼亞
            "Spain", // ES : 西班牙
            "Sweden", // SE : 瑞典
            "Switzerland", // CH : 瑞士
            "Turkey", // TR : 土耳其
            "Ukraine", // UA : 烏克蘭
            "United Kingdom", // GB : 英國
        ]
        AfricaRegionArrayData = [
            "Algeria", // DZ : 阿爾及利亞
            "Egypt", // EG : 埃及
            "Ghana", // GH : 迦納
            "Kenya", // KE : 肯亞
            "Libya", // LY : 利比亞
            "Morocco", // MA : 摩洛哥
            "Nigeria", // NG : 奈及利亞
            "Senegal", // SN : 塞內加爾
            "South Africa", // ZA : 南非共和國
            "Tanzania", // TZ : 坦尚尼亞
            "Tunisia", // TN : 突尼西亞
            "Uganda", // UG : 烏干達
            "Zimbabwe", // ZW : 辛巴威(羅德西亞)
        ]
        AmericaRegionArrayData = [
            "United States", // US : 美國
            "Argentina", // AR : 阿根廷
            "Brazil", // BR : 巴西
            "Canada", // CA : 加拿大
            "Chile", // CL : 智利
            "Colombia", // CO : 哥倫比亞
            "Mexico", // MX : 墨西哥
            "Peru", // PE : 秘魯
            "Puerto Rico", // PR : 波多黎各
        ]
        OceaniaRegionArrayData = [ "Australia", // AU : 澳大利亞
            "New Zealand", // NZ : 紐西蘭
        ]
        
        tableRegionData = [ CateogryRegion[0]:AsiaRegionArrayData,
                            CateogryRegion[1]:EuropeRegionArrayData,
                            CateogryRegion[2]:AfricaRegionArrayData,
                            CateogryRegion[3]:AmericaRegionArrayData,
                            CateogryRegion[4]:OceaniaRegionArrayData,
        ]
        
        RegionCodeData = [
            "Azerbaijan":"AZ", // AZ : 亞塞拜然
            "Bahrain":"BH", // BH : 巴林
            "Georgia":"GE", // GE : 喬治亞
            "Hong Kong":"HK", // HK : 香港
            "India":"IN", // IN : 印度
            "Indonesia":"ID", // ID : 印尼
            "Iraq":"IQ", // IQ : 伊拉克
            "Israel":"IL", // IL : 以色列
            "Japan":"JP", // JP : 日本
            "Jordan":"JO", // JO : 約旦
            "Kazakhstan":"KZ", // KZ : 哈薩克
            "Kuwait":"KW", // KW : 科威特
            "Lebanon":"LB", // LB : 黎巴嫩
            "Malaysia":"MY", // MY : 馬來西亞
            "Nepal":"NP", // NP : 尼伯爾
            "Oman":"OM", // OM : 阿曼
            "Pakistan":"PK", // PK : 巴基斯坦
            "Poland":"PH", // PH : 菲律賓
            "Qatar":"QA", // QA : 庫達(卡達)
            "Saudi Arabia":"SA", // SA : 沙烏地阿拉伯
            "Singapore":"SG", // SG : 新加坡
            "South Korea":"KR", // KR : 大韓民國
            "Sri Lanka":"LK", // LK : 斯里蘭卡
            "Taiwan":"TW", // TW : 中華民國
            "Thailand":"TH", // TH : 泰國
            "United Arab Emirates":"AE", // AE : 阿拉伯聯合大公國
            "Vietnam":"VN", // VN : 越南
            "Yemen":"YE", // YE : 北葉門
            "Austria":"AT", // AT : 奧地利
            "Belarus":"BY", // BY : 白俄羅斯
            "Belgium":"BE", // BE : 比利時
            "Bosnia and Herzegovina":"BA", // BA : 波士尼亞
            "Bulgaria":"BG", // BG : 保加利亞
            "Croatia":"HR", // HR : 克羅埃西亞
            "Czech Republic":"CZ", // CZ : 捷克
            "Denmark":"DZ", // DZ : 丹麥
            "Estonia":"EE", // EE : 愛沙尼亞
            "Finland":"FI", // FI : 芬蘭
            "France":"FR", // FR : 法國
            "Germany":"DE", //DE : 德國
            "Greece":"GR", // GR : 希臘
            "Hungary":"HU", // HU : 匈牙利
            "Iceland":"IS", // IS : 冰島
            "Ireland":"IE", // IE : 愛爾蘭
            "Italy":"IT", // IT : 義大利
            "Latvia":"LV", // LV : 拉脫維亞
            "Lithuania":"LT", // LT : 立陶宛
            "Luxembourg":"LU", // LU : 盧森堡
            "Macedonia":"MK", // MK : 馬其頓
            "Montenegro":"ME", // ME : 蒙特尼哥羅
            "Netherlands":"NL", // NL : 荷蘭
            "Norway":"NO", // NO : 挪威
            "Portugal":"PT", // PT : 葡萄牙
            "Romania":"RO", // RO : 羅馬尼亞
            "Russia":"RU", // RU : 俄羅斯聯邦
            "Serbia":"RS", // RS : 塞爾維亞
            "Slovakia":"SK", // SK : 斯洛伐克
            "Slovenia":"SI", // SI : 斯洛凡尼亞
            "Spain":"ES", // ES : 西班牙
            "Sweden":"SE", // SE : 瑞典
            "Switzerland":"CH", // CH : 瑞士
            "Turkey":"TR", // TR : 土耳其
            "Ukraine":"UA", // UA : 烏克蘭
            "United Kingdom":"GB", // GB : 英國
            "Algeria":"DZ", // DZ : 阿爾及利亞
            "Egypt":"EG", // EG : 埃及
            "Ghana":"GH", // GH : 迦納
            "Kenya":"KE", // KE : 肯亞
            "Libya":"LY", // LY : 利比亞
            "Morocco":"MA", // MA : 摩洛哥
            "Nigeria":"NG", // NG : 奈及利亞
            "Senegal":"SN", // SN : 塞內加爾
            "South Africa":"ZA", // ZA : 南非共和國
            "Tanzania":"TZ", // TZ : 坦尚尼亞
            "Tunisia":"TN", // TN : 突尼西亞
            "Uganda":"UG", // UG : 烏干達
            "Zimbabwe":"ZW", // ZW : 辛巴威(羅德西亞)
            "United States":"US", // US : 美國
            "Argentina":"AR", // AR : 阿根廷
            "Brazil":"BR", // BR : 巴西
            "Canada":"CA", // CA : 加拿大
            "Chile":"CL", // CL : 智利
            "Colombia":"CO", // CO : 哥倫比亞
            "Mexico":"MX", // MX : 墨西哥
            "Peru":"PE", // PE : 秘魯
            "Puerto Rico":"PR", // PR : 波多黎各
            "Australia":"AU", // AU : 澳大利亞
            "New Zealand":"NZ", // NZ : 紐西蘭
        ]
        
        //print(RegionCodeData.count)
        //print(AsiaRegionArrayData.count + EuropeRegionArrayData.count + AfricaRegionArrayData.count + AmericaRegionArrayData.count + OceaniaRegionArrayData.count)
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let sectionHeaderHeight = CGFloat(40);
        if scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return CateogryRegion.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        print("viewForHeaderInSection")
        let headerView = RegionTableViewHeader(frame: CGRectMake(0,0,50,tableView.frame.width))
        headerView.label.text = CateogryRegion[section]
        let expandButton = headerView.expandButton as UIImageView
        expandButton.tag = section
        if section == headerTag {
            headerView.expandButton.image = UIImage(named: "down_arrow")
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(RegionViewController.expandTableView(_:)))
        expandButton.userInteractionEnabled = true
        expandButton.addGestureRecognizer(tapGestureRecognizer)
        return headerView
        
    }
    
    func expandTableView(sender: UITapGestureRecognizer) {
        
        print("expandTableView")
        if headerTag == sender.view!.tag {
            headerTag = -1
        } else {
            headerTag = sender.view!.tag
        }
        tableView.reloadData()        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == headerTag {
            return (tableRegionData[ CateogryRegion[section] ]?.count)!
        }else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("didSelectRowAtIndexPath")
        
        let text = ( tableRegionData[ CateogryRegion[indexPath.section] ] as! NSArray )[indexPath.row] as! String
        
        regionCode = RegionCodeData[text]!
        print(countryRegion.regionCode)
        
        countryRegion.section = indexPath.section
        countryRegion.row = indexPath.row
        tableView.reloadData()
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("cellForRowAtIndexPath")
        let cell = tableView.dequeueReusableCellWithIdentifier("idRegionTableViewCell") as! RegionTableViewCell
        cell.backgroundColor = UIColor.whiteColor()
        let text = ( tableRegionData[ CateogryRegion[indexPath.section] ] as! NSArray )[indexPath.row] as! String
        cell.countryFlag.image = UIImage(named: text)
        if indexPath.section == countryRegion.section && indexPath.row == countryRegion.row {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        cell.countryName.text = text
        return cell
    }
    
}