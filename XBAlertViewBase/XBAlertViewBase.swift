//
//  XBAlertViewBase.swift
//  XCP
//
//  Created by xxb on 2016/12/19.
//  Copyright © 2016年 xxb. All rights reserved.
//

import UIKit

class XBAlertViewBase: UIView {
    
    var showLayoutBlock: ((_ alertView:XBAlertViewBase) ->Void)?
    
    var hiddenLayoutBlock: ((_ alertView:XBAlertViewBase) ->Void)?
    
    var showFrame: CGRect?
    
    var hiddenFrame: CGRect?
    
    var bool_selfFIFO = false
    
    var bool_backgroundViewFIFO = true
    
    var backgroundViewColor = UIColor.black.withAlphaComponent(0.5)
    
    private var _displayView:UIView?
    var displayView: UIView?{
        get{return _displayView}
        set{
            _displayView=newValue
            _displayView?.addSubview(backgroundView)
            _displayView?.addSubview(self)}
    }
    
    lazy var backgroundView: UIView={
        let bgv=UIView(frame: (self.displayView?.bounds)!)
        bgv.backgroundColor=self.backgroundViewColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(XBAlertViewBase.clickBGView(tap:)))
        bgv.addGestureRecognizer(tap)
        bgv.alpha=0
        return bgv
    }()
    
    /// 初始化方法，要展示在哪个view上
    init(displayV: UIView) {
        super.init(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        displayView=displayV
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clickBGView(tap:UITapGestureRecognizer) -> Void {
        print("clickBGView")
        hidden()
    }
    
    func show() -> Void {
        
        hiddenCode()
        UIView.animate(withDuration: 0.5)
        {
            weak var weakSelf = self
            if self.showLayoutBlock != nil
            {
                self.showLayoutBlock!(weakSelf!)
            }
            else
            {
                self.frame=self.showFrame!
            }
            
            if self.bool_selfFIFO
            {
                self.alpha=1
            }
            
            if self.bool_backgroundViewFIFO
            {
                self.backgroundView.alpha=1
            }
            
            self.layoutIfNeeded()
        };
    }
    
    func hidden() -> Void {
        layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.hiddenCode()
            self.layoutIfNeeded()
        }) { (complete) in
            
        }
    }
    
    private func hiddenCode() -> Void {
        weak var weakSelf = self
        if hiddenLayoutBlock != nil
        {
            hiddenLayoutBlock!(weakSelf!)
        }
        else
        {
            frame=hiddenFrame!
        }
        
        if bool_selfFIFO
        {
            alpha=0
        }

        if bool_backgroundViewFIFO
        {
            backgroundView.alpha=0
        }
    }
}
