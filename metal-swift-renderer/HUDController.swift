import Foundation

@Observable
class HUDController {
    var renderer: Renderer?
    
    init(renderer: Renderer? = nil) {
        self.renderer = renderer
    }
    
    
}
