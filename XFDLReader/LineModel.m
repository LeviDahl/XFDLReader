//
//  LineModel.m
//  XFDLReader
//
//  Created by Levi on 2/10/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import "LineModel.h"

@implementation LineModel
-(id) initWithParameters:(GDataXMLElement *)element andVersion:(NSString *)version {
    if (self){
        self.location = [[NSMutableDictionary alloc] init];

        if ([version isEqualToString:@"6.5"])
        {
            self.name = [element attributeForName:@"sid"].stringValue;

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
        NSLog(@"line location:%@", self.location);
        }
        else if([version isEqualToString:@"7.7"]|| [version isEqualToString:@"7.6"])
        {
            GDataXMLElement *ae = [[element elementsForName:@"itemlocation"] objectAtIndex:0];
            if ([[[ae elementsForName:@"x"] objectAtIndex:0]stringValue]) {
            [self.location setObject:[[[ae elementsForName:@"x"] objectAtIndex:0]stringValue] forKey:@"x"];
            }
            if ([[[ae elementsForName:@"y"] objectAtIndex:0]stringValue]) {
                [self.location setObject:[[[ae elementsForName:@"y"] objectAtIndex:0]stringValue] forKey:@"y"];
            }
            if ([[[ae elementsForName:@"width"] objectAtIndex:0]stringValue]) {
                [self.location setObject:[[[ae elementsForName:@"width"] objectAtIndex:0]stringValue] forKey:@"width"];
            }
            if ([[[ae elementsForName:@"height"] objectAtIndex:0]stringValue]) {
                [self.location setObject:[[[ae elementsForName:@"height"] objectAtIndex:0]stringValue] forKey:@"height"];
            }


        }
    }
    return self;
}
-(NSString *)description {
    return self.name;
}

@end
