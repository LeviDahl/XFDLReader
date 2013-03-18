//
//  CheckBoxModel.h
//  XFDLReader
//
//  Created by Levi on 2/24/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface CheckBoxModel : NSObject
@property (strong, nonatomic) NSMutableDictionary *location;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSMutableDictionary *font;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *justify;
@property (strong, nonatomic) UIButton *checkbox;
-(id) initWithParameters:(GDataXMLElement *)element andVersion:(NSString *)version;
@end
