//
//  ImageModel.h
//  XFDLReader
//
//  Created by Levi on 2/11/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@interface ImageModel : NSObject
@property (strong, nonatomic) NSMutableDictionary *location;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageName;

-(id) initWithParameters:(GDataXMLElement *)element;
@end
