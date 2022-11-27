import Vapor
import Leaf
import LeafKit
import FilesSourcer

// configures your application
public func configure(_ app: Application) throws {

    
    app.middleware.use(FilesSourcerMidleware(files: Files.shared))

//    if !app.environment.isRelease {
//        app.leaf.renderer.cache = LeafCache(isEnabled: false)
//    }
    
//    app.leaf.configuration = LeafConfiguration(rootDirectory: app.directory.viewsDirectory)
    
    let detected = app.directory.viewsDirectory
    
    let defaultSource = NIOLeafFiles(fileio: app.fileio,
                                         limits: .default,
                                         sandboxDirectory: detected,
                                         viewDirectory: detected,
                                         defaultExtension: "leaf")
    
    let customSource = FilesSourcerLeafSource(files: Files.shared)

    let multipleSources = LeafSources()
    try multipleSources.register(using: defaultSource)
    try multipleSources.register(source: "custom-source-key", using: customSource)
    
    app.leaf.sources = multipleSources


    app.views.use(.leaf)
    
    try routes(app)
}
