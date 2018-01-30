
/*
 This is where you will be getting your data from a different source.
 */

import UIKit

class Data {
    
    static func getData(completion: @escaping ([Model]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            var data = [Model]()
            data.append(Model(title: "One", subTitle: "Subtitle", image: nil, data1: "Data1", data2: "Data2"))
            data.append(Model(title: "Two", subTitle: "Subtitle", image: nil, data1: "Data1", data2: "Data2"))
            data.append(Model(title: "Three", subTitle: "Subtitle", image: nil, data1: "Data1", data2: "Data2"))
            data.append(Model(title: "Four", subTitle: "Subtitle", image: nil, data1: "Data1", data2: "Data2"))
            
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
}
