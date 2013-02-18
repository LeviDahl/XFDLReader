//
//  LineModel.h
//  XFDLReader
//
//  Created by Levi on 2/10/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@class LineModel;
@interface LineModel : NSObject
@property (strong, nonatomic) NSMutableDictionary *location;
@property (strong, nonatomic) NSString *name;

-(id) initWithParameters:(GDataXMLElement *)element;
@end
