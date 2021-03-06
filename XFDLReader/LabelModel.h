//
//  LabelModel.h
//  XFDLReader
//
//  Created by Levi on 1/23/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface LabelModel : NSObject
@property (strong, nonatomic) NSMutableDictionary *location;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSMutableDictionary *font;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *justify;
@property (nonatomic) BOOL visible;
-(id) initWithParameters:(GDataXMLElement *)element andVersion:(NSString *)version;

@end
