//
//  ComboBoxModel.m
//  XFDLReader
//
//  Created by Levi on 2/26/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import "ComboBoxModel.h"

@implementation ComboBoxModel

-(id) initWithParameters:(GDataXMLElement *)element andVersion:(NSString *)version {
    if (self){
        self.location = [[NSMutableDictionary alloc] init];
        if ([version isEqualToString:@"6.5"])
        {
            self.name = [element attributeForName:@"sid"].stringValue;
            if ([[element elementsForName:@"group"] objectAtIndex:0] != NULL)
            {
                self.group = [(GDataXMLElement *)[[element elementsForName:@"group"] objectAtIndex:0] stringValue];
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
            NSLog(@"combobox location:%@, group: %@", self.location, self.group);
        }
        }
    return self;
}
-(NSString *)description {
        return self.name;
    }
@end