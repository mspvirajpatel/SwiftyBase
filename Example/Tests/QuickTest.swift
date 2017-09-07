//
//  QuickTest.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 07/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//


import Quick
import Nimble
@testable import SwiftyBase

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("these will fail") {
            
            var btnPrimary : BaseButton!
           
            beforeEach {
                btnPrimary = BaseButton.init(type: .primary)
                btnPrimary.setTitle("Primary Button", for: UIControlState())
                btnPrimary.setButtonTouchUpInsideEvent { (sender, object) in
                    XCTAssert(true , "Sucess")
                }
            }
            
            describe("its click") {
                var touchUpInsideEvent : ControlTouchUpInsideEvent!
               
                beforeEach {
                    touchUpInsideEvent = btnPrimary.touchUpInsideEvent
                }
                
                it("has a high frequency") {
                    expect(touchUpInsideEvent).toNot(beNil())
                }
            }
        }
        
        describe("Callback testing") {
            it("can test callbacks using waitUntil") {
                
                waitUntil(timeout: 30) {done in
                    APIManager.shared.getRequest(URL: API.countries, Parameter: NSDictionary(), completionHandler:{ (result) in
                        
                        switch result{
                        case .Success(let object, _):
                            
                            expect(object).toNot(beNil())
                            
                            done()
                            
                            break
                        case .Error(let error):
                            expect(error).toNot(beNil())
//                            or 
//                            if let bool : Bool = (error != nil) ? false : true
//                            {
//                                expect(false) == bool
//                            }
                            done()
                            break
                        case .Internet(let isOn):
                            
                            expect(isOn).to(beTrue())
                            
                            print("Internet is  \(isOn)")
                            
                        }
                    })
                }
            }
        }
    }
}
