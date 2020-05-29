import {
	DeviceEventEmitter,
	NativeEventEmitter,
	NativeModules,
	Platform
} from 'react-native';
let SocketIO = NativeModules.RnSocketIo;

export class SocketIOClient {
	constructor(host, config = {}) {
		if (!host) {
			throw 'Invalid constructor parameter host';
		}

		this.sockets = SocketIO;
		this.isConnected = false;
		this.handlers = {};
		this.onAnyHandler = (data) => {
			// console.log('wild card event', data);
		};

		const emitter = () => {
			return Platform.OS === 'ios'
				? new NativeEventEmitter(SocketIO)
				: DeviceEventEmitter;
		};

		emitter().addListener('socketEvent', this._handleEvent.bind(this));

		this.defaultHandlers = {
			connect: () => {
				this.isConnected = true;
			},

			disconnect: () => {
				this.isConnected = false;
			}
		};

		this.sockets.initialize(host, config);
	}

	_handleEvent(event) {
		const eventHandlers = this.handlers[event.name];
		if (this.handlers.hasOwnProperty(event.name)) {
			Object.keys(eventHandlers).forEach((uniqueId) => {
				eventHandlers[uniqueId](
					event.hasOwnProperty('items') ? event.items : null
				);
			});
		}
		if (this.defaultHandlers.hasOwnProperty(event.name)) {
			this.defaultHandlers[event.name]();
		}

		if (this.onAnyHandler) {
			this.onAnyHandler(event);
		}
	}

	connect() {
		this.sockets.connect();
	}

	onUnique(event, uniqueId, handler) {
		this.handlers[event] = {
			...this.handlers[event],
			[uniqueId]: handler
		};
		if (Platform.OS === 'android') {
			this.sockets.on(event);
		}
	}

	on(event, handler) {
		this.handlers[event] = {
			...this.handlers[event],
			event: handler
		};
		if (Platform.OS === 'android') {
			this.sockets.on(event);
		}
	}

	off(event, uniqueId = 'event') {
		if (this.handlers.hasOwnProperty(event)) {
			const eventHandlers = this.handlers[event];
			if (eventHandlers.hasOwnProperty(uniqueId)) {
				delete this.handlers[event][uniqueId];
			}
		}
	}

	onAny(handler) {
		this.onAnyHandler = handler;
	}

	emit(event, data = undefined) {
		if (Platform.OS === 'ios') {
			if (data) {
				this.sockets.emit(event, data);
			} else {
				this.sockets.emit(event, {});
			}
		}
	}

	disconnect() {
		this.sockets.disconnect();
	}

	reconnect() {
		this.sockets.reconnect();
	}
}
