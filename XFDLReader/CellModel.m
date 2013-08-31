//
//  CellModel.m
//  XFDLReader
//
//  Created by Levi on 3/17/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel
-(id)initWithParameters:(GDataXMLElement *)element andVersion:(NSString *)version {
    if (self)
    {
       
        self.name = [element attributeForName:@"sid"].stringValue;
        if ([[element elementsForName:@"value"] objectAtIndex:0] != NULL)
        {
            self.value = [(GDataXMLElement *)[[element elementsForName:@"value"] objectAtIndex:0] stringValue];
        }
        else
        {
            self.value = @"";
        }
        if ([[element elementsForName:@"group"] objectAtIndex:0] != NULL)
        {
            self.group = [(GDataXMLElement *)[[element elementsForName:@"group"] objectAtIndex:0] stringValue];
        }
        else
        {
            self.group = @"";
        }
    }
    return self;
}
@end
