//
//  FontProvider.swift
//  Dunbar Common
//
//  Created by George Birch on 9/28/23.
//

import Foundation
import VFont

public protocol AssetProviding {
    
    var dnbrGreen: UIColor { get }
    var paragraphFont: UIFont { get }
    
}

public class AssetProvider: AssetProviding {
    
    private let bundle = Bundle(identifier: "com.withdunbar.Dunbar-Common")
    
    public var dnbrGreen: UIColor {
        // TODO: remove force unwrap
        return UIColor(named: "DunbarGreen", in: bundle, compatibleWith: nil)!
    }
    
    public var paragraphFont: UIFont {
        let vFont = VFont(name: "RobotoFlex-Regular", size: 18)!
        vFont.setValue(1, forAxisID: 2003265652)
        return vFont.uiFont
    }
    
    public init() {}
    
}

public enum DnbrColor {
    case Green
}

/*
 @mixin paragraph() {
   font-family: 'Roboto Flex', sans-serif;
   font-weight: 350;
   font-size: 18px;
   line-height: 1.33em;
   font-variation-settings: "wdth" 88, "opsz" 14, "slnt" 0, "GRAD" 0, "XTRA" 480, "XOPQ" 102, "YOPQ" 88, "YTLC" 485, "YTUC" 680, "YTAS" 720, "YTDE" -235, "YTFI" 680;
 }

 @mixin title {
   font-family: 'Roboto Flex';
   font-weight: 500;
   font-size: 42px;
   font-variation-settings: 'wdth' 65, 'opsz' 36, 'slnt' 0, 'GRAD' 0, 'XTRA' 468, 'XOPQ' 80, 'YOPQ' 65, 'YTLC' 500, 'YTUC' 660, 'YTAS' 700, 'YTDE' -170, 'YTFI' 660;
 }

 @mixin sub-title {
   font-family: 'Roboto Flex';
   font-size: 28px;
   font-weight: 250;
   font-variation-settings: 'wdth' 150, 'opsz' 18, 'slnt' 0, 'GRAD' 0, 'XTRA' 468, 'XOPQ' 96, 'YOPQ' 80, 'YTLC' 520, 'YTUC' 710,
   'YTAS' 750, 'YTDE' -200, 'YTFI' 710;
 }

 @mixin caption {
   font-family: 'Roboto Flex';
   font-weight: 400;
   font-size: 11px;
   font-variation-settings: 'wdth' 88, 'opsz' 11, 'slnt' 0, 'GRAD' 0, 'XTRA' 480, 'XOPQ' 102, 'YOPQ' 88, 'YTLC' 485, 'YTUC' 680,
   'YTAS' 720, 'YTDE' -235, 'YTFI' 680;
 }

 @mixin heavy-title {
   font-family: Roboto Flex;
   font-size: 42px;
   font-weight: 700;
   line-height: 42px;
   letter-spacing: 0em;
   text-align: left;
   font-variation-settings: 'wdth' 65, 'GRAD' 0, 'slnt' 0, 'XTRA' 468, 'XOPQ' 80, 'YOPQ' 65, 'YTLC' 500, 'YTUC' 660, 'YTAS' 700, 'YTDE' -170, 'YTFI' 660;
 }
 */
