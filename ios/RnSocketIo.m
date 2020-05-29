#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RnSocketIo, NSObject)

RCT_EXTERN_METHOD(initialize:(NSString*)connection config:(NSDictionary*)config)
RCT_EXTERN_METHOD(addHandlers:(NSDictionary*)handlers)
RCT_EXTERN_METHOD(connect)
RCT_EXTERN_METHOD(disconnect)
RCT_EXTERN_METHOD(reconnect)
RCT_EXTERN_METHOD(emit:(NSString*)event items:(id)items)

@end
