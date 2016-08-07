//
//  Utils.swift
//  hackkathon
//
//  Created by Vijay on 07/24/15.
//  Copyright (c) 2016 Vijay. All rights reserved.
//

import Foundation

/// Function to execute a block after a delay.
/// - parameter delay:: Double delay in seconds

func delay(delay: Double, block:()->())
{
  let nSecDispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)));
  let queue = dispatch_get_main_queue()
  
  dispatch_after(nSecDispatchTime, queue, block)
}