import UIKit

enum FilterType : String {
    case pixellate = "CIPixellate"
    case vintage = "CIPhotoEffectTransfer"
    case blackAndWhite = "CIPhotoEffectMono"
    case sepia = "CISepiaTone"
    case comic = "CIComicEffect"
    case colorPosterize = "CIColorPosterize"
    
    static let allFilters = [pixellate, vintage, blackAndWhite, sepia, comic, colorPosterize]
    static let allFiltersString = ["Pixellate", "Vintage", "Mono", "Sepia", "Comic", "Posterize"]
}

typealias FilterCompletion = (UIImage?) -> ()

class Filters {
    
    static let shared = Filters() // singleton

    static var originalImage: UIImage?
    
    let context: CIContext
    
    private init() {
        //GPU Context
        let options = [kCIContextWorkingColorSpace: NSNull()]
        guard let eaglContext = EAGLContext(api: .openGLES2) else {
            fatalError("Failed to create EAGLContext.")
        }
        context = CIContext(eaglContext: eaglContext, options: options)
    }
    
    
    class func filter(name: FilterType, image: UIImage, completion: @escaping FilterCompletion) {
        OperationQueue().addOperation {
            
            guard let filter = CIFilter(name: name.rawValue) else { fatalError("Failed to create CIFilter") }
            
            let coreImage = CIImage(image: image)
            filter.setValue(coreImage, forKey: kCIInputImageKey)
            

            
            //Get final image using GPU
            guard let outputImage = filter.outputImage else { fatalError("Failed to get output image from Filter.") }
            
            if let cgImage = Filters.shared.context.createCGImage(outputImage, from: outputImage.extent) {
                
                let finalImage = UIImage(cgImage: cgImage)
                
                OperationQueue.main.addOperation {
                    completion(finalImage)
                }
                
            } else {
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
            
        }
    }
}
