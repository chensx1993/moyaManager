//
//  String+Extension.swift
//  MoyaManager
//
//  Created by hsbcnet.mobile.uk hsbcnet.mobile.uk on 2019/5/10.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation

extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "";
    }
    
}
