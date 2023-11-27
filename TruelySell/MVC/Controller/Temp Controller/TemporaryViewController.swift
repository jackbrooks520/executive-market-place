 
import UIKit

class TemporaryViewController: UIViewController {

//    var socket: WebSocket!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        socket = WebSocket(url: URL(string: "ws://172.16.1.170:8191/websocket_chat/applications/libraries/PhpSocket.php")!)
//        socket.delegate = self
//        socket.connect()
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    // MARK: Websocket Delegate Methods.
//    func websocketDidConnect(socket: WebSocketClient) {
//        print("websocket is connected")
//    }
//
//    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
//        if let e = error as? WSError {
//            print("websocket is disconnected: \(e.message)")
//        } else if let e = error {
//            print("websocket is disconnected: \(e.localizedDescription)")
//        } else {
//            print("websocket disconnected")
//        }
//    }
//
//    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        print("Received text: \(text)")
//    }
//
//    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//        print("Received data: \(data.count)")
//    }
//
//    // MARK: Write Text Action
//
//    @IBAction func writeText(_ sender: UIBarButtonItem) {
//        socket.write(string: "hello there!")
//    }
//
//    // MARK: Disconnect Action
//
//    @IBAction func disconnect(_ sender: UIBarButtonItem) {
//        if socket.isConnected {
//            sender.title = "Connect"
//            socket.disconnect()
//        } else {
//            sender.title = "Disconnect"
//            socket.connect()
//        }
//    }

}
