import Flutter
import UIKit
import Foundation
import ARKit
import Combine
import ARCoreCloudAnchors

class IosARView: NSObject, FlutterPlatformView, ARSCNViewDelegate, UIGestureRecognizerDelegate, ARSessionDelegate {
    let sceneView: ARSCNView
    let coachingView: ARCoachingOverlayView
    let sessionManagerChannel: FlutterMethodChannel
    let objectManagerChannel: FlutterMethodChannel
    let anchorManagerChannel: FlutterMethodChannel
    var showPlanes = false
    var planeCount = 0
    var customPlaneTexturePath: String? = nil
    private var floorPlacementReady = false
    private var placedFromFloor = false
    private var trackedPlanes = [UUID: (SCNNode, SCNNode)]()
    let modelBuilder = ArModelBuilder()
    
    var cancellableCollection = Set<AnyCancellable>() //Used to store all cancellables in (needed for working with Futures)
    var anchorCollection = [String: ARAnchor]() //Used to bookkeep all anchors created by Flutter calls
    
    private var cloudAnchorHandler: CloudAnchorHandler? = nil
    private var arcoreSession: GARSession? = nil
    private var arcoreMode: Bool = false
    private var configuration: ARWorldTrackingConfiguration!
    private var tappedPlaneAnchorAlignment = ARPlaneAnchor.Alignment.horizontal // default alignment
    
    private var panStartLocation: CGPoint?
    private var panCurrentLocation: CGPoint?
    private var panCurrentVelocity: CGPoint?
    private var panCurrentTranslation: CGPoint?
    private var rotationStartLocation: CGPoint?
    private var rotation: CGFloat?
    private var rotationVelocity: CGFloat?
    private var panningNode: SCNNode?
    private var panningNodeCurrentWorldLocation: SCNVector3?
    private var dragHit: SIMD3<Float>?
    private var rotationApplied: Float = 0

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        self.sceneView = ARSCNView(frame: frame)
        self.coachingView = ARCoachingOverlayView(frame: frame)
        
        self.sessionManagerChannel = FlutterMethodChannel(name: "arsession_\(viewId)", binaryMessenger: messenger)
        self.objectManagerChannel = FlutterMethodChannel(name: "arobjects_\(viewId)", binaryMessenger: messenger)
        self.anchorManagerChannel = FlutterMethodChannel(name: "aranchors_\(viewId)", binaryMessenger: messenger)
        super.init()

        let configuration = ARWorldTrackingConfiguration() // Create default configuration before initializeARView is called
        self.sceneView.delegate = self
        self.coachingView.delegate = self
        self.sceneView.session.run(configuration)
        self.sceneView.session.delegate = self

        self.sessionManagerChannel.setMethodCallHandler(self.onSessionMethodCalled)
        self.objectManagerChannel.setMethodCallHandler(self.onObjectMethodCalled)
        self.anchorManagerChannel.setMethodCallHandler(self.onAnchorMethodCalled)
    }

    func view() -> UIView {
        return self.sceneView
    }

    func onDispose(_ result:FlutterResult) {
                sceneView.session.pause()
                self.sessionManagerChannel.setMethodCallHandler(nil)
                self.objectManagerChannel.setMethodCallHandler(nil)
                self.anchorManagerChannel.setMethodCallHandler(nil)
                result(nil)
            }

    func onSessionMethodCalled(_ call :FlutterMethodCall, _ result:FlutterResult) {
        let arguments = call.arguments as? Dictionary<String, Any>

        switch call.method {
            case "init":
                //self.sessionManagerChannel.invokeMethod("onError", arguments: ["SessionTEST from iOS"])
                //result(nil)
                initializeARView(arguments: arguments!, result: result)
                break
            case "getCameraPose":
                if let cameraPose = sceneView.session.currentFrame?.camera.transform {
                    result(serializeMatrix(cameraPose))
                } else {
                    result(FlutterError())
                }
                break
            case "getAnchorPose":
            if let cameraPose = anchorCollection[arguments?["anchorId"] as! String]?.transform {
                    result(serializeMatrix(cameraPose))
                } else {
                    result(FlutterError())
                }
                break
            case "snapshot":
                // call the SCNView Snapshot method and return the Image
                let snapshotImage = sceneView.snapshot()
                if let bytes = snapshotImage.pngData() {
                    let data = FlutterStandardTypedData(bytes:bytes)
                    result(data)
                } else {
                    result(nil)
                }
            case "dispose":
                onDispose(result)
                result(nil)
                break
            case "showPlanes":
                if let showPlanesArgument = arguments?["showPlanes"] as? Bool {
                        showPlanes = showPlanesArgument
                } else {
                    showPlanes = false
                }
                if (showPlanes){
                    // Visualize currently tracked planes
                    for plane in trackedPlanes.values {
                        plane.0.addChildNode(plane.1)
                    }
                } else {
                    // Remove currently visualized planes
                    for plane in trackedPlanes.values {
                        plane.1.removeFromParentNode()
                    }
                }
                result(nil)
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }

    func onObjectMethodCalled(_ call :FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as? Dictionary<String, Any>
          
        switch call.method {
            case "init":
                DispatchQueue.main.async {self.objectManagerChannel.invokeMethod("onError", arguments: ["ObjectTEST from iOS"])}
                result(nil)
                break
            case "addNode":
                addNode(dict_node: arguments!).sink(receiveCompletion: {completion in }, receiveValue: { val in
                       result(val)
                    }).store(in: &self.cancellableCollection)
                break
            case "addNodeToPlaneAnchor":
                if let dict_node = arguments!["node"] as? Dictionary<String, Any>, let dict_anchor = arguments!["anchor"] as? Dictionary<String, Any> {
                    addNode(dict_node: dict_node, dict_anchor: dict_anchor).sink(receiveCompletion: {completion in }, receiveValue: { val in
                           result(val)
                        }).store(in: &self.cancellableCollection)
                }
                break
            case "removeNode":
                if let name = arguments!["name"] as? String {
                    sceneView.scene.rootNode.childNode(withName: name, recursively: true)?.removeFromParentNode()
                }
                break
            case "transformationChanged":
                if let name = arguments!["name"] as? String, let transform = arguments!["transformation"] as? Array<NSNumber> {
                    transformNode(name: name, transform: transform)
                    result(nil)
                }
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }

    func onAnchorMethodCalled(_ call :FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as? Dictionary<String, Any>
          
        switch call.method {
            case "init":
                DispatchQueue.main.async {self.objectManagerChannel.invokeMethod("onError", arguments: ["ObjectTEST from iOS"])}
                result(nil)
                break
            case "addAnchor":
                if let type = arguments!["type"] as? Int, type == 0,
                   let transform = arguments!["transformation"] as? Array<NSNumber>,
                   let name = arguments!["name"] as? String {
                    result(addPlaneAnchor(transform: transform, name: name))
                } else {
                    result(false)
                }
                break
            case "removeAnchor":
                if let name = arguments!["name"] as? String {
                    deleteAnchor(anchorName: name)
                }
                break
            case "initGoogleCloudAnchorMode":
                arcoreSession = try! GARSession.session()

                if (arcoreSession != nil){
                    let configuration = GARSessionConfiguration();
                    configuration.cloudAnchorMode = .enabled;
                    arcoreSession?.setConfiguration(configuration, error: nil);
                    if let token = JWTGenerator().generateWebToken(){
                        arcoreSession!.setAuthToken(token)
                        
                        cloudAnchorHandler = CloudAnchorHandler(session: arcoreSession!)
                        arcoreSession!.delegate = cloudAnchorHandler
                        arcoreSession!.delegateQueue = DispatchQueue.main
                        
                        arcoreMode = true
                    } else {
                        DispatchQueue.main.async {self.sessionManagerChannel.invokeMethod("onError", arguments: ["Error generating JWT, have you added cloudAnchorKey.json into the ios/Runner directory ?"])}
                    }
                } else {
                    DispatchQueue.main.async {self.sessionManagerChannel.invokeMethod("onError", arguments: ["Error initializing Google AR Session"])}
                }
                    
                break
            case "uploadAnchor":
                if let anchorName = arguments!["name"] as? String, let anchor = anchorCollection[anchorName] {
                    print("---------------- HOSTING INITIATED ------------------")
                    if let ttl = arguments!["ttl"] as? Int {
                        cloudAnchorHandler?.hostCloudAnchorWithTtl(anchorName: anchorName, anchor: anchor, listener: cloudAnchorUploadedListener(parent: self), ttl: ttl)
                    } else {
                        cloudAnchorHandler?.hostCloudAnchor(anchorName: anchorName, anchor: anchor, listener: cloudAnchorUploadedListener(parent: self))
                    }
                }
                result(true)
                break
            case "downloadAnchor":
                if let anchorId = arguments!["cloudanchorid"] as? String {
                    print("---------------- RESOLVING INITIATED ------------------")
                    cloudAnchorHandler?.resolveCloudAnchor(anchorId: anchorId, listener: cloudAnchorDownloadedListener(parent: self))
                }
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }

    func initializeARView(arguments: Dictionary<String,Any>, result: FlutterResult){
        // Set plane detection configuration
        self.configuration = ARWorldTrackingConfiguration()
        self.configuration.environmentTexturing = .automatic
        if let planeDetectionConfig = arguments["planeDetectionConfig"] as? Int {
            switch planeDetectionConfig {
                case 1: 
                    configuration.planeDetection = .horizontal
                
                case 2: 
                    if #available(iOS 11.3, *) {
                        configuration.planeDetection = .vertical
                    }
                case 3: 
                    if #available(iOS 11.3, *) {
                        configuration.planeDetection = [.horizontal, .vertical]
                    }
                default: 
                    configuration.planeDetection = []
            }
        }

        // Set plane rendering options
        if let configShowPlanes = arguments["showPlanes"] as? Bool {
            showPlanes = configShowPlanes
            if (showPlanes){
                // Visualize currently tracked planes
                for plane in trackedPlanes.values {
                    plane.0.addChildNode(plane.1)
                }
            } else {
                // Remove currently visualized planes
                for plane in trackedPlanes.values {
                    plane.1.removeFromParentNode()
                }
            }
        }
        if let configCustomPlaneTexturePath = arguments["customPlaneTexturePath"] as? String {
            customPlaneTexturePath = configCustomPlaneTexturePath
        }

        // Set debug options
        var debugOptions = ARSCNDebugOptions().rawValue
        if let showFeaturePoints = arguments["showFeaturePoints"] as? Bool {
            if (showFeaturePoints) {
                debugOptions |= ARSCNDebugOptions.showFeaturePoints.rawValue
            }
        }
        if let showWorldOrigin = arguments["showWorldOrigin"] as? Bool {
            if (showWorldOrigin) {
                debugOptions |= ARSCNDebugOptions.showWorldOrigin.rawValue
            }
        }
        self.sceneView.debugOptions = ARSCNDebugOptions(rawValue: debugOptions)
        
        if let configHandleTaps = arguments["handleTaps"] as? Bool {
            if (configHandleTaps){
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                tapGestureRecognizer.delegate = self
                self.sceneView.addGestureRecognizer(tapGestureRecognizer)
            }
        }

        if let configHandlePans = arguments["handlePans"] as? Bool {
            if (configHandlePans){
                let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                panGestureRecognizer.maximumNumberOfTouches = 1
                panGestureRecognizer.delegate = self
                self.sceneView.addGestureRecognizer(panGestureRecognizer)
            }
        }
        
        if let configHandleRotation = arguments["handleRotation"] as? Bool {
            if (configHandleRotation){
                let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
                rotationGestureRecognizer.delegate = self
                self.sceneView.addGestureRecognizer(rotationGestureRecognizer)
            }
        }
        
        // Add coaching view
        if let configShowAnimatedGuide = arguments["showAnimatedGuide"] as? Bool {
            if configShowAnimatedGuide {
                if self.sceneView.superview != nil && self.coachingView.superview == nil {
                    self.sceneView.addSubview(self.coachingView)
        //            self.coachingView.translatesAutoresizingMaskIntoConstraints = false
                    self.coachingView.autoresizingMask = [
                          .flexibleWidth, .flexibleHeight
                        ]
                    self.coachingView.session = self.sceneView.session
                    self.coachingView.activatesAutomatically = true
                    if configuration.planeDetection == .horizontal {
                        self.coachingView.goal = .horizontalPlane
                    }else{
                        self.coachingView.goal = .verticalPlane
                    }
                    // TODO: look into constraints issue. This causes a crash:
                    /**
                     Terminating app due to uncaught exception 'NSGenericException', reason: 'Unable to activate constraint with anchors <NSLayoutXAxisAnchor:0x28342dec0 "ARCoachingOverlayView:0x13a470ae0.centerX"> and <NSLayoutXAxisAnchor:0x28342c680 "FlutterTouchInterceptingView:0x10bad1c90.centerX"> because they have no common ancestor.  Does the constraint or its anchors reference items in different view hierarchies?  That's illegal.'
                     */
        //            NSLayoutConstraint.activate([
        //                self.coachingView.centerXAnchor.constraint(equalTo: self.sceneView.superview!.centerXAnchor),
        //                self.coachingView.centerYAnchor.constraint(equalTo: self.sceneView.superview!.centerYAnchor),
        //                self.coachingView.widthAnchor.constraint(equalTo: self.sceneView.superview!.widthAnchor),
        //                self.coachingView.heightAnchor.constraint(equalTo: self.sceneView.superview!.heightAnchor)
        //                ])
                }
            }
        }
    
        // Update session configuration
        self.sceneView.session.run(configuration)
        floorPlacementReady = true
    }

    /// Drops the piece on the floor in front of the camera once that floor
    /// is tracked, then leaves it anchored so walking around shows every side.
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard floorPlacementReady, !placedFromFloor else { return }
        guard sceneView.bounds.width > 0, sceneView.bounds.height > 0 else { return }
        let aim = CGPoint(
            x: sceneView.bounds.midX,
            y: sceneView.bounds.height * 0.58
        )
        guard let floorHit = raycastFloor(sceneView: sceneView, touchLocation: aim) else {
            return
        }
        placedFromFloor = true
        DispatchQueue.main.async {
            self.sessionManagerChannel.invokeMethod("onPlaneOrPointTap", arguments: [floorHit])
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let planeAnchor = anchor as? ARPlaneAnchor{
            let plane = modelBuilder.makePlane(anchor: planeAnchor, flutterAssetFile: customPlaneTexturePath)
            trackedPlanes[anchor.identifier] = (node, plane)
            planeCount += 1
            DispatchQueue.main.async {self.sessionManagerChannel.invokeMethod("onPlaneDetected", arguments: self.planeCount)}
            if (showPlanes) {
                node.addChildNode(plane)
            }
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if let planeAnchor = anchor as? ARPlaneAnchor, let plane = trackedPlanes[anchor.identifier] {
            modelBuilder.updatePlaneNode(planeNode: plane.1, anchor: planeAnchor)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        trackedPlanes.removeValue(forKey: anchor.identifier)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if (arcoreMode) {
            do {
                try arcoreSession!.update(frame)
            } catch {
                print(error)
            }
        }
    }

    func addNode(dict_node: Dictionary<String, Any>, dict_anchor: Dictionary<String, Any>? = nil) -> Future<Bool, Never> {

        return Future {promise in
            
            switch (dict_node["type"] as! Int) {
                case 0: // GLTF2 Model from Flutter asset folder
                    // Get path to given Flutter asset
                    let key = FlutterDartProject.lookupKey(forAsset: dict_node["uri"] as! String)
                    // Add object to scene
                    if let node: SCNNode = self.modelBuilder.makeNodeFromGltf(name: dict_node["name"] as! String, modelPath: key, transformation: dict_node["transformation"] as? Array<NSNumber>) {
                        if let anchorName = dict_anchor?["name"] as? String, let anchorType = dict_anchor?["type"] as? Int {
                            switch anchorType{
                                case 0: //PlaneAnchor
                                    if let anchor = self.anchorCollection[anchorName]{
                                        // Attach node to the top-level node of the specified anchor
                                        self.sceneView.node(for: anchor)?.addChildNode(node)
                                        promise(.success(true))
                                    } else {
                                        promise(.success(false))
                                    }
                                default:
                                    promise(.success(false))
                                }
                            
                        } else {
                            // Attach to top-level node of the scene
            self.sceneView.scene.rootNode.addChildNode(node)
            promise(.success(true))
        }
                    } else {
                        DispatchQueue.main.async {self.sessionManagerChannel.invokeMethod("onError", arguments: ["Unable to load renderable \(dict_node["uri"] as! String)"])}
                        promise(.success(false))
                    }
                    break
                case 1: // GLB Model from the web
                    // Add object to scene
                    self.modelBuilder.makeNodeFromWebGlb(name: dict_node["name"] as! String, modelURL: dict_node["uri"] as! String, transformation: dict_node["transformation"] as? Array<NSNumber>)
                    .sink(receiveCompletion: {
                                    completion in print("Async Model Downloading Task completed: ", completion)
                    }, receiveValue: { val in
                        if let node: SCNNode = val {
                            if let anchorName = dict_anchor?["name"] as? String, let anchorType = dict_anchor?["type"] as? Int {
                                switch anchorType{
                                    case 0: //PlaneAnchor
                                        if let anchor = self.anchorCollection[anchorName]{
                                            // Attach node to the top-level node of the specified anchor
                                            self.sceneView.node(for: anchor)?.addChildNode(node)
                                            promise(.success(true))
                                        } else {
                                            promise(.success(false))
                                        }
                                    default:
                                        promise(.success(false))
                                    }
                                
                            } else {
                                // Attach to top-level node of the scene
            self.sceneView.scene.rootNode.addChildNode(node)
            promise(.success(true))
        }
                        } else {
                            DispatchQueue.main.async {self.sessionManagerChannel.invokeMethod("onError", arguments: ["Unable to load renderable \(dict_node["name"] as! String)"])}
                            promise(.success(false))
                        }
                    }).store(in: &self.cancellableCollection)
                    break
                case 2: // GLB Model from the app's documents folder
                    // Get path to given file system asset
                    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    let documentsDirectory = paths[0]
                    let targetPath = documentsDirectory.appendingPathComponent(dict_node["uri"] as! String).path
 
                    // Add object to scene
                    if let node: SCNNode = self.modelBuilder.makeNodeFromFileSystemGLB(name: dict_node["name"] as! String, modelPath: targetPath, transformation: dict_node["transformation"] as? Array<NSNumber>) {
                        if let anchorName = dict_anchor?["name"] as? String, let anchorType = dict_anchor?["type"] as? Int {
                            switch anchorType{
                                case 0: //PlaneAnchor
                                    if let anchorNode = self.anchorNode(named: anchorName) {
                                        anchorNode.addChildNode(node)
                                        self.seatOnAnchor(node)
                                        promise(.success(true))
                                    } else {
                                        self.placedFromFloor = false
                                        promise(.success(false))
                                    }
                                default:
                                    promise(.success(false))
                                }
                            
                        } else {
                            // Attach to top-level node of the scene
            self.sceneView.scene.rootNode.addChildNode(node)
            promise(.success(true))
        }
                    } else {
                        DispatchQueue.main.async {self.sessionManagerChannel.invokeMethod("onError", arguments: ["Unable to load renderable \(dict_node["uri"] as! String)"])}
                        promise(.success(false))
                    }
                    break
                case 3: //fileSystemAppFolderGLTF2
                    // Get path to given file system asset
                    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    let documentsDirectory = paths[0]
                    let targetPath = documentsDirectory.appendingPathComponent(dict_node["uri"] as! String).path

                    // Add object to scene
                    if let node: SCNNode = self.modelBuilder.makeNodeFromFileSystemGltf(name: dict_node["name"] as! String, modelPath: targetPath, transformation: dict_node["transformation"] as? Array<NSNumber>) {
                        if let anchorName = dict_anchor?["name"] as? String, let anchorType = dict_anchor?["type"] as? Int {
                            switch anchorType{
                                case 0: //PlaneAnchor
                                    if let anchor = self.anchorCollection[anchorName]{
                                        // Attach node to the top-level node of the specified anchor
                                        self.sceneView.node(for: anchor)?.addChildNode(node)
                                        promise(.success(true))
                                    } else {
                                        promise(.success(false))
                                    }
                                default:
                                    promise(.success(false))
                                }
                            
                        } else {
                            // Attach to top-level node of the scene
            self.sceneView.scene.rootNode.addChildNode(node)
            promise(.success(true))
        }
                    } else {
                        DispatchQueue.main.async {self.sessionManagerChannel.invokeMethod("onError", arguments: ["Unable to load renderable \(dict_node["uri"] as! String)"])}
                        promise(.success(false))
                    }
                    break
                default:
                    promise(.success(false))
            }
            
        }
    }
    
    func transformNode(name: String, transform: Array<NSNumber>) {
        let node = sceneView.scene.rootNode.childNode(withName: name, recursively: true)
        node?.transform = deserializeMatrix4(transform)
        if let node = node {
            seatOnAnchor(node)
        }
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let sceneView = recognizer.view as? ARSCNView else {
            return
        }
        let touchLocation = recognizer.location(in: sceneView)
    
        let allHitResults = sceneView.hitTest(touchLocation, options: [SCNHitTestOption.searchMode : SCNHitTestSearchMode.closest.rawValue])
        // Because 3D model loading can lead to composed nodes, we have to traverse through a node's parent until the parent node with the name assigned by the Flutter API is found
        let nodeHitResults: Array<String> = allHitResults.compactMap { nearestParentWithNameStart(node: $0.node, characters: "[#")?.name }
        if (nodeHitResults.count != 0) {
            DispatchQueue.main.async {self.objectManagerChannel.invokeMethod("onNodeTap", arguments: Array(Set(nodeHitResults)))} // Chaining of Array and Set is used to remove duplicates
            return
        }
            
        if let floorHit = raycastFloor(sceneView: sceneView, touchLocation: touchLocation) {
            DispatchQueue.main.async {
                self.sessionManagerChannel.invokeMethod("onPlaneOrPointTap", arguments: [floorHit])
            }
            return
        }

        let planeTypes: ARHitTestResult.ResultType = [
            .existingPlaneUsingGeometry,
            .existingPlaneUsingExtent,
        ]
        let planeAndPointHitResults = sceneView.hitTest(touchLocation, types: planeTypes)
        if let first = planeAndPointHitResults.first {
            if let hitAnchor = first.anchor as? ARPlaneAnchor {
                self.tappedPlaneAnchorAlignment = hitAnchor.alignment
            } else {
                self.tappedPlaneAnchorAlignment = .horizontal
            }
            let hit: [String: Any] = [
                "type": 1,
                "distance": first.distance,
                "worldTransform": serializeMatrix(first.worldTransform),
            ]
            DispatchQueue.main.async {
                self.sessionManagerChannel.invokeMethod("onPlaneOrPointTap", arguments: [hit])
            }
        }
    }

    /// A point on the floor about 1.2 m in front of the phone.
    ///
    /// Uses the lowest horizontal plane ARKit is already tracking. A straight
    /// down ray was missing that plane, so the table never appeared.
    func floorPose() -> simd_float4x4? {
        guard let frame = sceneView.session.currentFrame else { return nil }
        let camera = frame.camera.transform
        let cam = SIMD3<Float>(camera.columns.3.x, camera.columns.3.y, camera.columns.3.z)
        var forward = SIMD3<Float>(-camera.columns.2.x, 0, -camera.columns.2.z)
        let length = simd_length(forward)
        if length < 0.001 { return nil }
        forward /= length
        let spot = cam + forward * 1.2

        let planes = frame.anchors.compactMap { $0 as? ARPlaneAnchor }.filter { plane in
            plane.alignment == .horizontal && plane.transform.columns.3.y < cam.y - 0.05
        }
        guard let floor = planes.min(by: {
            $0.transform.columns.3.y < $1.transform.columns.3.y
        }) else { return nil }

        var floorY = floor.transform.columns.3.y
        // A plane next to the phone is the session start, not the floor.
        // Drop the attached model to standing height so it is in view.
        if cam.y - floorY < 0.8 {
            floorY = cam.y - 1.15
        }
        var pose = matrix_identity_float4x4
        pose.columns.3 = SIMD4<Float>(spot.x, floorY, spot.z, 1)
        return pose
    }

    func raycastFloor(sceneView: ARSCNView, touchLocation: CGPoint) -> Dictionary<String, Any>? {
        guard let pose = floorPose() else { return nil }
        self.tappedPlaneAnchorAlignment = .horizontal
        let camera = sceneView.session.currentFrame?.camera.transform.columns.3
        let hit = pose.columns.3
        let dx = hit.x - (camera?.x ?? hit.x)
        let dy = hit.y - (camera?.y ?? hit.y)
        let dz = hit.z - (camera?.z ?? hit.z)
        return [
            "type": 1,
            "distance": Double(sqrt(dx * dx + dy * dy + dz * dz)),
            "worldTransform": serializeMatrix(pose),
        ]
    }

    /// Moves the rendered mesh so its lowest point sits on the anchor.
    func seatOnAnchor(_ node: SCNNode) {
        guard let parent = node.parent else { return }
        let bottom = lowestWorldY(node)
        guard bottom < Float.greatestFiniteMagnitude / 2 else { return }
        let delta = parent.worldPosition.y - bottom
        // A bad mesh bound can be tens of metres. Leave the model where it
        // was placed instead of throwing it out of view.
        guard delta.isFinite, abs(delta) < 2 else { return }
        node.worldPosition.y += delta
    }

    func lowestWorldY(_ node: SCNNode) -> Float {
        var lowest = Float.greatestFiniteMagnitude
        func consider(_ item: SCNNode) {
            if item.geometry != nil {
                let box = item.boundingBox
                let corners = [
                    SCNVector3(box.min.x, box.min.y, box.min.z),
                    SCNVector3(box.min.x, box.min.y, box.max.z),
                    SCNVector3(box.max.x, box.min.y, box.min.z),
                    SCNVector3(box.max.x, box.min.y, box.max.z),
                ]
                for corner in corners {
                    let world = item.convertPosition(corner, to: nil)
                    if world.y < lowest { lowest = world.y }
                }
            }
            for child in item.childNodes {
                consider(child)
            }
        }
        consider(node)
        return lowest
    }

    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let sceneView = recognizer.view as? ARSCNView else {
            return
        }

        // State Begins
        if recognizer.state == UIGestureRecognizer.State.began
        {
            panStartLocation = recognizer.location(in: sceneView)
            if let startLocation = panStartLocation {
                let allHitResults = sceneView.hitTest(startLocation, options: [SCNHitTestOption.searchMode : SCNHitTestSearchMode.closest.rawValue])
                // Because 3D model loading can lead to composed nodes, we have to traverse through a node's parent until the parent node with the name assigned by the Flutter API is found
                let nodeHitResults: Array<String> = allHitResults.compactMap {
                    if let nearestNode = nearestParentWithNameStart(node: $0.node, characters: "[#") {
                        panningNode = nearestNode
                        return nearestNode.name
                    }else{
                        return nil
                    }
                }
                if (nodeHitResults.count != 0 && panningNode != nil) {
                dragHit = nil
                panningNodeCurrentWorldLocation = panningNode!.worldPosition
                DispatchQueue.main.async {self.objectManagerChannel.invokeMethod("onPanStart", arguments: self.panningNode!.name)}
                return
            }
            }
        }
        // State Changes
        if(recognizer.state == UIGestureRecognizer.State.changed)
        {
            // the velocity of the gesture is how fast it is moving. This can be used to translate the position of the node.
            panCurrentVelocity = recognizer.velocity(in: sceneView)
            panCurrentLocation = recognizer.location(in: sceneView)
            panCurrentTranslation = recognizer.translation(in: sceneView)

            if recognizer.numberOfTouches == 1, let panLoc = panCurrentLocation, let panNode = panningNode {
                let targets: [ARRaycastQuery.Target] = [.existingPlaneGeometry, .existingPlaneInfinite]
                var hitPoint: SIMD3<Float>?
                for target in targets {
                    guard let query = sceneView.raycastQuery(from: panLoc, allowing: target, alignment: .horizontal),
                          let result = sceneView.session.raycast(query).first else { continue }
                    let column = result.worldTransform.columns.3
                    hitPoint = SIMD3<Float>(column.x, column.y, column.z)
                    break
                }
                if let hit = hitPoint {
                    if let previous = dragHit {
                        panNode.worldPosition.x += hit.x - previous.x
                        panNode.worldPosition.z += hit.z - previous.z
                    }
                    dragHit = hit
                }
                DispatchQueue.main.async {self.objectManagerChannel.invokeMethod("onPanChange", arguments: panNode.name)}
            }
        }
        // State Ended
        if(recognizer.state == UIGestureRecognizer.State.ended)
        {
            // kill variables
            panStartLocation = nil
            panCurrentLocation = nil
            dragHit = nil
            DispatchQueue.main.async {self.objectManagerChannel.invokeMethod("onPanEnd", arguments: serializeLocalTransformation(node: self.panningNode))}
            panningNode = nil
        }
    }
    
    @objc func handleRotation(_ recognizer: UIRotationGestureRecognizer) {
        guard let sceneView = recognizer.view as? ARSCNView else {
            return
        }

        // State Begins
        if recognizer.state == UIGestureRecognizer.State.began
        {
            rotationStartLocation = recognizer.location(in: sceneView)
            if let startLocation = rotationStartLocation {
                let allHitResults = sceneView.hitTest(startLocation, options: [SCNHitTestOption.searchMode : SCNHitTestSearchMode.closest.rawValue])
                // Because 3D model loading can lead to composed nodes, we have to traverse through a node's parent until the parent node with the name assigned by the Flutter API is found
                let nodeHitResults: Array<String> = allHitResults.compactMap {
                    if let nearestNode = nearestParentWithNameStart(node: $0.node, characters: "[#") {
                        panningNode = nearestNode
                        return nearestNode.name
                    }else{
                        return nil
                    }
                }
                if (nodeHitResults.count != 0 && panningNode != nil) {
                    rotationApplied = 0
                    DispatchQueue.main.async {self.objectManagerChannel.invokeMethod("onRotationStart", arguments: self.panningNode!.name)}
                    return
                }
            }
        }
        // State Changes
        if(recognizer.state == UIGestureRecognizer.State.changed)
        {
            // the velocity of the gesture is how fast it is moving. This can be used to translate the position of the node.
            rotation = recognizer.rotation
            if let panNode = panningNode {
                let current = Float(recognizer.rotation)
                let delta = current - rotationApplied
                rotationApplied = current
                panNode.eulerAngles.y -= delta
                DispatchQueue.main.async {self.objectManagerChannel.invokeMethod("onRotationChange", arguments: panNode.name)}
            }

            // update position of panning node if it has been created
            // panningNode.position + the gesture delta
        }
        // State Ended
        if(recognizer.state == UIGestureRecognizer.State.ended)
        {
            // kill variables
            rotation = nil
            rotationVelocity = nil
            rotationApplied = 0
            DispatchQueue.main.async {self.objectManagerChannel.invokeMethod("onRotationEnd", arguments: serializeLocalTransformation(node: self.panningNode))}
            panningNode = nil
        }
    
    }

    // Recursive helper function to traverse a node's parents until a node with a name starting with the specified characters is found
    func nearestParentWithNameStart(node: SCNNode?, characters: String) -> SCNNode? {
        if let nodeNamePrefix = node?.name?.prefix(characters.count) {
            if (nodeNamePrefix == characters) { return node }
        }
        if let parent = node?.parent { return nearestParentWithNameStart(node: parent, characters: characters) }
        return nil
    }
    
    func anchorNode(named name: String) -> SCNNode? {
        guard let anchor = anchorCollection[name] else { return nil }
        if let node = sceneView.node(for: anchor) { return node }
        let deadline = Date().addingTimeInterval(0.6)
        while sceneView.node(for: anchor) == nil && Date() < deadline {
            RunLoop.current.run(mode: .default, before: Date().addingTimeInterval(0.01))
        }
        return sceneView.node(for: anchor)
    }

    func addPlaneAnchor(transform: Array<NSNumber>, name: String) -> Bool {
        let pose = floorPose() ?? simd_float4x4(deserializeMatrix4(transform))
        let arAnchor = ARAnchor(transform: pose)
        anchorCollection[name] = arAnchor
        sceneView.session.add(anchor: arAnchor)
        if anchorNode(named: name) != nil {
            placedFromFloor = true
            return true
        }
        sceneView.session.remove(anchor: arAnchor)
        anchorCollection.removeValue(forKey: name)
        placedFromFloor = false
        return false
    }
    
    func deleteAnchor(anchorName: String) {
        if let anchor = anchorCollection[anchorName]{
            // Delete all child nodes
            if var attachedNodes = sceneView.node(for: anchor)?.childNodes {
                attachedNodes.removeAll()
            }
            // Remove anchor
            sceneView.session.remove(anchor: anchor)
            // Update bookkeeping
            anchorCollection.removeValue(forKey: anchorName)
        }
    }
    
    private class cloudAnchorUploadedListener: CloudAnchorListener {
        private var parent: IosARView
        
        init(parent: IosARView) {
            self.parent = parent
        }
        
        func onCloudTaskComplete(anchorName: String?, anchor: GARAnchor?) {
            if let cloudState = anchor?.cloudState {
                if (cloudState == GARCloudAnchorState.success) {
                    var args = Dictionary<String, String?>()
                    args["name"] = anchorName
                    args["cloudanchorid"] = anchor?.cloudIdentifier
                    DispatchQueue.main.async {self.parent.anchorManagerChannel.invokeMethod("onCloudAnchorUploaded", arguments: args)}
                } else {
                    print("Error uploading anchor, state: \(parent.decodeCloudAnchorState(state: cloudState))")
                    DispatchQueue.main.async {self.parent.sessionManagerChannel.invokeMethod("onError", arguments: ["Error uploading anchor, state: \(self.parent.decodeCloudAnchorState(state: cloudState))"])}
                    return
                }
            }
        }
    }

    private class cloudAnchorDownloadedListener: CloudAnchorListener {
        private var parent: IosARView
        
        init(parent: IosARView) {
            self.parent = parent
        }
        
        func onCloudTaskComplete(anchorName: String?, anchor: GARAnchor?) {
            if let cloudState = anchor?.cloudState {
                if (cloudState == GARCloudAnchorState.success) {
                    let newAnchor = ARAnchor(transform: anchor!.transform)
                    // Register new anchor on the Flutter side of the plugin
                    DispatchQueue.main.async {self.parent.anchorManagerChannel.invokeMethod("onAnchorDownloadSuccess", arguments: serializeAnchor(anchor: newAnchor, anchorNode: nil, ganchor: anchor!, name: anchorName), result: { result in
                        if let anchorName = result as? String {
                            self.parent.sceneView.session.add(anchor: newAnchor)
                            self.parent.anchorCollection[anchorName] = newAnchor
                        } else {
                            DispatchQueue.main.async {self.parent.sessionManagerChannel.invokeMethod("onError", arguments: ["Error while registering downloaded anchor at the AR Flutter plugin"])}
                        }

                    })}
                } else {
                    print("Error downloading anchor, state \(cloudState)")
                    DispatchQueue.main.async {self.parent.sessionManagerChannel.invokeMethod("onError", arguments: ["Error downloading anchor, state \(cloudState)"])}
                    return
                }
            }
        }
    }
    
    func decodeCloudAnchorState(state: GARCloudAnchorState) -> String {
        switch state {
        case .errorCloudIdNotFound:
            return "Cloud anchor id not found"
        case .errorHostingDatasetProcessingFailed:
            return "Dataset processing failed, feature map insufficient"
        case .errorHostingServiceUnavailable:
            return "Hosting service unavailable"
        case .errorInternal:
            return "Internal error"
        case .errorNotAuthorized:
            return "Authentication failed: Not Authorized"
        case .errorResolvingSdkVersionTooNew:
            return "Resolving Sdk version too new"
        case .errorResolvingSdkVersionTooOld:
            return "Resolving Sdk version too old"
        case .errorResourceExhausted:
            return " Resource exhausted"
        case .none:
            return "Empty state"
        case .taskInProgress:
            return "Task in progress"
        case .success:
            return "Success"
        case .errorServiceUnavailable:
            return "Cloud Anchor Service unavailable"
        case .errorResolvingLocalizationNoMatch:
            return "No match"
        @unknown default:
            return "Unknown"
        }
    }
}

// ---------------------- ARCoachingOverlayViewDelegate ---------------------------------------

extension IosARView: ARCoachingOverlayViewDelegate {
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView){
        // use this delegate method to hide anything in the UI that could cover the coaching overlay view
    }
    
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        // Reset the session.
        self.sceneView.session.run(configuration, options: [.resetTracking])
    }
}
