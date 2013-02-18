//
//  DataModel.m
//  XFDLReader
//
//  Created by Levi on 2/11/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
-(id) initWithParameters:(GDataXMLElement *)element {
    if (self)
    {
    self.name = [element attributeForName:@"sid"].stringValue;
    self.data = [[[element elementsForName:@"mimedata"] objectAtIndex:0] stringValue];
    

   
    }
     return self;
}
-(NSString *)description {
    return self.name;
}
@end
