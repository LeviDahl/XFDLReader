//
//  LabelModel.m
//  XFDLReader
//
//  Created by Levi on 1/23/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import "LabelModel.h"

@implementation LabelModel
-(id) initWithParameters:(GDataXMLElement *)element {
    if (self){
               self.location = [[NSMutableDictionary alloc] init];
        self.font = [[NSMutableDictionary alloc] init];
                     self.name = [element attributeForName:@"sid"].stringValue;
        if (![self.name isEqualToString:@"doHideSSNs"] && ![[[[element elementsForName:@"value"] objectAtIndex:0] stringValue] isEqualToString:@"Edit Component"] && ![[[[element elementsForName:@"value"] objectAtIndex:0] stringValue] isEqualToString:@"This evaluation report is due at HQDA on: N/A"])
            {

        if ([[element elementsForName:@"value"] objectAtIndex:0] != NULL)
        {
            self.value = [(GDataXMLElement *)[[element elementsForName:@"value"] objectAtIndex:0] stringValue];
        }
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
        for (GDataXMLElement *ae in [element elementsForName:@"fontinfo"])
        {
                NSArray *values = [ae elementsForName:@"ae"];
                    [self.font setObject:[(GDataXMLElement *)[values objectAtIndex:0] stringValue] forKey:@"fontname"];
                    [self.font setObject:[(GDataXMLElement *)[values objectAtIndex:1] stringValue] forKey:@"fontsize"];
                    [self.font setObject:[(GDataXMLElement *)[values objectAtIndex:2] stringValue] forKey:@"fonttype"];
        }
        self.justify = [(GDataXMLElement *)[[element elementsForName:@"justify"] objectAtIndex:0] stringValue];

        NSLog(@"label values: name:%@ value:%@ justify:%@ location:%@ ", self.name, self.value, self.justify, self.location);
            }
    
            }
    return self;
}
-(NSString *)description {
    return self.name;
}
@end
