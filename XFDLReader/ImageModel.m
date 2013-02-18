//
//  ImageModel.m
//  XFDLReader
//
//  Created by Levi on 2/11/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel

-(id) initWithParameters:(GDataXMLElement *)element {
self.location = [[NSMutableDictionary alloc] init];
    if (self){
    self.name = [element attributeForName:@"sid"].stringValue;
        self.imageName = [[[element elementsForName:@"image"] objectAtIndex:0] stringValue];
        for (GDataXMLElement *ae in [[[element elementsForName:@"itemlocation"] objectAtIndex:0] elementsForName:@"ae"])
        {
            NSArray *values = [ae elementsForName:@"ae"];
            if ([[(GDataXMLElement *)[values objectAtIndex:0] stringValue] isEqualToString:@"absolute"])
            {
                [self.location setObject:[(GDataXMLElement *)[values objectAtIndex:1] stringValue] forKey:@"x"];
                [self.location setObject:[(GDataXMLElement *)[values objectAtIndex:2] stringValue] forKey:@"y"];
            }
            else if ([[(GDataXMLElement *)[values objectAtIndex:0] stringValue] isEqualToString:@"extent"])
            {
                [self.location setObject:[(GDataXMLElement *)[values objectAtIndex:1] stringValue] forKey:@"width"];
                [self.location setObject:[(GDataXMLElement *)[values objectAtIndex:2] stringValue] forKey:@"height"];
            }
        }
}
    return self;
}
-(NSString *)description {
    return self.name;
}
@end
