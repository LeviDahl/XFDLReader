//
//  TextViewModel.m
//  XFDLReader
//
//  Created by Levi on 2/10/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import "TextViewModel.h"

@implementation TextViewModel
-(id) initWithParameters:(GDataXMLElement *)element {
    if (self){
        self.location = [[NSMutableDictionary alloc] init];
        self.font = [[NSMutableDictionary alloc] init];
        self.name = [element attributeForName:@"sid"].stringValue;
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
        self.field = [[UITextView alloc] init];
        
        NSLog(@"field values: name:%@ value:%@ location:%@", self.name, self.value, self.location);
    }
    return self;
}
-(NSString *)description {
    return self.name;
}
@end
