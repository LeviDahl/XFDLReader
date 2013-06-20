//
//  CellModel.h
//  XFDLReader
//
//  Created by Levi on 3/17/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CellModel : NSObject
@property (strong, nonatomic) NSString *group;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *name;

-(id) initWithParameters:(GDataXMLElement *)element andVersion:(NSString *)version;
@end
