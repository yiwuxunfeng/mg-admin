
#import <Foundation/Foundation.h>

@interface Parser : NSObject

@property (nonatomic, strong) NSMutableDictionary * params;

- (NSMutableArray*)parser:(NSString*)ident fromData:(NSData*)dict;

@end
