//
//  Socket.swift
//  ReactSockets
//
//  Created by Henry Kirkness on 10/05/2015.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

import Foundation
import SocketIO

@objc(RnSocketIo)
class RnSocketIo: RCTEventEmitter {

	var manager: SocketManager!
  var socket: SocketIOClient!
  var connectionSocket: NSURL!

  /**
  * Construct and expose RCTBridge to module
  */

    public static var emitter: RCTEventEmitter!
    override init() {
        super.init()
        RnSocketIo.emitter = self
    }
    
    open override func supportedEvents() -> [String] {
      ["socketEvent"]
    }
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        return true
    }

  /**
  * Initialize and configure socket
  */

  @objc func initialize(_ connection: String, config: NSDictionary) -> Void {
    connectionSocket = NSURL(string: connection);

    // Connect to socket with config
    self.manager = SocketManager(socketURL: URL(string: connection)!, config: config as? [String : AnyObject])
    self.socket = self.manager.defaultSocket;

    // Initialize onAny events
    self.onAnyEvent()
  }

  /**
  * Exposed but not currently used
  * add NSDictionary of handler events
  */

  @objc func addHandlers(handlers: NSDictionary) -> Void {
    for handler in handlers {
      self.socket.on(handler.key as! String) { data, ack in
        RnSocketIo.emitter.sendEvent(withName: "socketEvent", body: handler.key as! String)
      }
    }
  }

  /**
  * Emit event to server
  */

  @objc func emit(_ event: String, items: AnyObject?) -> Void {
    if items != nil {
        self.socket.emit(event, items as! SocketData)
    } else {
        self.socket.emit(event, [])
    }
  }

  /**
  * PRIVATE: handler called on any event
  */

  private func onAnyEventHandler (sock: SocketAnyEvent) -> Void {
    if let items = sock.items {
        if items.count > 0 {
            RnSocketIo.emitter.sendEvent(withName: "socketEvent", body: ["name": sock.event, "items": items[0]])
        } else {
            RnSocketIo.emitter.sendEvent(withName: "socketEvent", body: ["name": sock.event])
        }
    } else {
        RnSocketIo.emitter.sendEvent(withName: "socketEvent", body: ["name": sock.event])
    }
  }

  /**
  * Trigger the event above on any event
  * Currently adding handlers to event on the JS layer
  */

  @objc func onAnyEvent() -> Void {
    self.socket.onAny(self.onAnyEventHandler)
  }

  // Connect to socket
  @objc func connect() -> Void {
    self.socket.connect()
  }

  // Reconnect to socket
  @objc func reconnect() -> Void {
    self.manager.reconnect()
  }

  // Disconnect from socket
  @objc func disconnect() -> Void {
    self.socket.disconnect()
  }
}
