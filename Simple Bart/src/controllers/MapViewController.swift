//
//  FirstViewController.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/21/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate {
    //@IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var mapView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        let imageSize = mapView.frame.size
        
        scrollView.contentSize = imageSize

        //mapView.contentMode = UIViewContentMode.Center
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / imageSize.width
        let scaleHeight = scrollViewFrame.size.height / imageSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 0.75
        scrollView.zoomScale = minScale
        scrollView.bounces = true
        
        centerScrollViewContents()
        //scrollView.contentOffset = CGPoint(x:500, y:100)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func centerScrollViewContents(){
        let boundsSize = scrollView.bounds.size
        var contentsFrame = mapView.frame
        
        if contentsFrame.size.width < boundsSize.width{
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
        }else{
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
        }else{
            contentsFrame.origin.y = 0
        }
        
        mapView.frame = contentsFrame
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //func scrollViewDidZoom(scrollView: UIScrollView) {
    //}
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapView
    }


}

