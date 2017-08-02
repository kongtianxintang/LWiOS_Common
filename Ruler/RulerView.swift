/***********************************************************
 * 版权所有,2017,OneKilo.
 * Copyright(C),2017,OneKilo co. LTD.All rights reserved.
 * project:OneKilo
 * Author:
 * Date:  17/08/02
 * QQ/Tel/Mail:383118832
 * Description:自定义刻度尺
 * Others:
 * Modifier:
 * Reason:
 *************************************************************/

import UIKit

class RulerScrollView: UIScrollView {
    
    var count = 200;
    
    var spacing:CGFloat = 10.0;
    
    var margin:CGFloat = 100.0;//间距
    
    private lazy var shape = CAShapeLayer()
    
    private lazy var labels = Array<UILabel>();
    
    private func drawLine(){
        
        let path = CGMutablePath()
        let height:CGFloat = bounds.height / 2.0;
        
        labels.forEach { (item:UILabel) in
            item.removeFromSuperview();
        }
        labels.removeAll();
        
        for item in 0 ... count {
            
            let x = CGFloat(item) * spacing + margin;
            
            let end = CGPoint.init(x: x, y: bounds.midY);
            
            let mark = item % 5
            
            switch mark {
            case 0:
                
                let start = CGPoint.init(x: x , y:bounds.midY - height / 2.0)
                
                path.addLines(between: [start,end])
                
                //label
                let label = UILabel();
                let s = "\(item)"
                label.text = s
                label.textAlignment = .center;
                label.font = UIFont.systemFont(ofSize: 12);
                let textSize = (s as NSString).size(attributes: [NSFontAttributeName:label.font])
                let ori = CGPoint.init(x: end.x - textSize.width / 2.0, y: end.y + textSize.height / 2.0);
                
                label.frame = CGRect.init(origin: ori, size: textSize);
                
                addSubview(label);
                
                labels.append(label);
                
            default:
                let start = CGPoint.init(x: x , y:bounds.midY - height / 3.0)
                
                path.addLines(between: [start,end])
                
                break;
            }
            
        }
        
        shape.removeFromSuperlayer();
        
        shape.strokeColor = UIColor.lightGray.cgColor;
        shape.lineWidth = 2;
        shape.lineCap = kCALineCapRound;
        shape.path = path;
        
        layer.addSublayer(shape);
        
        contentSize = CGSize.init(width: CGFloat(count) * spacing + margin * 2.0, height: 20.0)
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect);
        
        drawLine()
        
    }
    
}

protocol RulerProtocol:NSObjectProtocol {
    //刻度尺的值
    func rulerNumber(number:CGFloat)
}

class RulerView:UIView,UIScrollViewDelegate{
    
    
    private lazy var ruler:RulerScrollView = RulerScrollView();
    
    weak var rulerDelegate:RulerProtocol?
    
    private lazy var bg = UIView()
    
    private lazy var topIndicator = CAShapeLayer();
    
    private lazy var bottomIndicator = CAShapeLayer();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setupSubvies();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupSubvies();
    }
    
    
    private func setupSubvies(){
        
        
        addSubview(bg);
        addSubview(ruler);
        
        ruler.delegate = self;
        
        ruler.backgroundColor = UIColor.clear;
        
        ruler.translatesAutoresizingMaskIntoConstraints = false;
        
        let top = NSLayoutConstraint.init(item: ruler, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0);
        let left = NSLayoutConstraint.init(item: ruler, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0);
        let bottom = NSLayoutConstraint.init(item: ruler, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0);
        let right = NSLayoutConstraint.init(item: ruler, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0);
        
        addConstraints([top,left,bottom,right]);
        
        
        bg.translatesAutoresizingMaskIntoConstraints = false;
        
        let bTop = NSLayoutConstraint.init(item: bg, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0);
        let bLeft = NSLayoutConstraint.init(item: bg, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0);
        let bBttom = NSLayoutConstraint.init(item: bg, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0);
        let bRight = NSLayoutConstraint.init(item: bg, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0);
        addConstraints([bTop,bLeft,bBttom,bRight]);
        bg.backgroundColor = UIColor.white;
        bg.alpha = 0.9
        
        
        
        layer.addSublayer(topIndicator)
        layer.addSublayer(bottomIndicator);
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let width = bounds.width
        ruler.margin = width / 2.0
        ruler.showsHorizontalScrollIndicator = false;
        showIndicator();
    }
    
    
    //draw indicator
    private func showIndicator(){
        //指示器三角形的边长
        let width:CGFloat = 8;
        
        //top indicator
        let s1 = CGPoint.init(x: bounds.midX, y: bounds.minY + width)
        let s2 = CGPoint.init(x: bounds.midX - width / 2.0, y: bounds.minY);
        let s3 = CGPoint.init(x: bounds.midX + width / 2.0 , y: bounds.minY);
        let p1 = CGMutablePath();
        p1.addLines(between: [s1,s2,s3]);
        topIndicator.path = p1;
        topIndicator.fillColor = UIColor.red.cgColor;
        
        //bottom indicator
        let s4 = CGPoint.init(x: bounds.midX, y: bounds.maxY - width);
        let s5 = CGPoint.init(x: bounds.midX - width / 2.0 , y: bounds.maxY);
        let s6 = CGPoint.init(x: bounds.midX + width / 2.0, y: bounds.maxY)
        let p2 = CGMutablePath();
        p2.addLines(between: [s4,s5,s6]);
        bottomIndicator.path = p2;
        bottomIndicator.fillColor = UIColor.red.cgColor;
        
    }
    
    
    //UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let i = (scrollView.contentOffset.x ) / ruler.spacing
        
        if i >= 0 {
            if rulerDelegate != nil {
                rulerDelegate!.rulerNumber(number: i);
            }
        }
    }
    
}

