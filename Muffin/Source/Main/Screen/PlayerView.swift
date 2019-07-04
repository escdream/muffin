//
//  PlayerView.swift
//  Muffin
//
//  Created by JoonHo Kang on 04/07/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

import Foundation
import UIKit

@objc protocol PlaylistDelegate : class {
    @objc optional func getPlaylst(arrList:NSArray, nIndex:Int)
}


@objc class PlaylistView : UIView  {

    @objc var delegate : PlaylistDelegate? = nil
    @objc var currentSong : SongInfo?
    @objc var currentIndex = -1
    
    var _arrList = NSMutableArray()
    
    let lbTitle =  UILabel()
    let bgView = UIButton()

    let tblView = UITableView()

    init() {
        super.init(frame: CGRect.zero)
        
        
        
        initLayout();
    }
    
    // This attribute hides `init(coder:)` from subclasses
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    @objc var arrList : NSArray {
        
        get {
            return _arrList;
        }
        set (newVal) {
            _arrList.removeAllObjects()
            if (newVal.count > 0) {
                
                for i in 0...newVal.count-1 {
                    
                    var songInfo : SongInfo;
                    
                    songInfo = newVal[i] as! SongInfo
                    
                    print("SongName : \(songInfo.songName!)")
                    lbTitle.text = songInfo.songName;
                    
                    _arrList.add(songInfo)
                 
                }
            }
            
            
            tblView.reloadData()
        }
    }
    
    @objc func printTest ()
    {
        
        var dic = [String:String]()
        dic = [:]
        
        dic.removeAll()
        
        print("Print test"); 
    }
    
    
    @objc func showList(_ superView : UIView)
    {
        superView.addSubview(bgView);
        superView.addSubview(self);
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        lbTitle.frame = self.bounds
        tblView.frame = self.bounds
    }
    
    
    func initLayout()
    {
        tblView.dataSource = self
        tblView.delegate = self;

        
        tblView.register(SongTableViewCell.self, forCellReuseIdentifier: "TableViewCell")

        self.addSubview(lbTitle)
        self.addSubview(tblView)
        
        
        bgView.frame = UIScreen.main.bounds;
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.3;
        bgView.addTarget(self, action:#selector(onCloseList), for: .touchUpInside)
        
        let r  = UIScreen.main.bounds

        let w = r.size.width - 60
        let h = r.size.height - 100
        
        self.frame = CGRect.init(x:(r.size.width - w) / 2, y:(r.size.height - h) / 2, width:w, height:h)
        
        
        self.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        self.layer.shadowRadius = 30
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    
    @objc func onCloseList() {
        self.bgView.removeFromSuperview()
        self.removeFromSuperview()
    }
    

    deinit {
        bgView.removeTarget(self, action:#selector(onCloseList), for: .touchDragInside)
    }
}


extension PlaylistView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SongTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")! as! SongTableViewCell

        cell.songInfo = self.arrList[indexPath.row] as! SongInfo;
        
        if (currentSong == cell.songInfo)
        {
            cell.backgroundColor = UIColor.lightGray
        }
        
        cell.showPlayer = false;
        cell.showFavorite = false;
        cell.showPlayButton = false;

        return cell
    }
}

extension PlaylistView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.getPlaylst?(arrList: self.arrList, nIndex: indexPath.row)
        self.onCloseList()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}
