//
//  ComboBoxModel.h
//  XFDLReader
//
//  Created by Levi on 2/26/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface ComboBoxModel : NSObject
@property (strong, nonatomic) NSMutableDictionary *location;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSMutableDictionary *font;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *group;
@property (nonatomic) BOOL visible;
-(id) initWithParameters:(GDataXMLElement *)element andVersion:(NSString *)version;
@end
