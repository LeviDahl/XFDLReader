//
//  CheckBoxModel.m
//  XFDLReader
//
//  Created by Levi on 2/24/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import "CheckBoxModel.h"

@implementation CheckBoxModel
-(id) initWithParameters:(GDataXMLElement *)element andVersion:(NSString *)version{
    if (self){
          self.location = [[NSMutableDictionary alloc] init];
           self.font = [[NSMutableDictionary alloc] init];
       self.name = [element attributeForName:@"sid"].stringValue;
if ([[element elementsForName:@"value"] objectAtIndex:0] != NULL)
{
    self.value = [(GDataXMLElement *)[[element elementsForName:@"value"] objectAtIndex:0] stringValue];
}
        if ([version isEqualToString:@"6.5"])
        {
for (GDataXMLElement *ae in [[[element elementsForName:@"itemlocation"] objectAtIndex:0] elementsForName:@"ae"]){
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
               NSLog(@"checkboxes values: name:%@ value:%@ location:%@", self.name, self.value, self.location);
    }
    else if ([version isEqualToString:@"7.7"]||[version isEqualToString:@"7.6"])
    {
        GDataXMLElement *ae = [[element elementsForName:@"itemlocation"] objectAtIndex:0];
        GDataXMLElement *font = [[element elementsForName:@"fontinfo"] objectAtIndex:0];
        if ([[[ae elementsForName:@"x"] objectAtIndex:0] stringValue])
        {
            [self.location setObject:[[[ae elementsForName:@"x"] objectAtIndex:0] stringValue] forKey:@"x"];
        }
        if ([[[ae elementsForName:@"y"] objectAtIndex:0] stringValue])
        {
            [self.location setObject:[[[ae elementsForName:@"y"] objectAtIndex:0] stringValue] forKey:@"y"];
        }
        if ([[[ae elementsForName:@"height"] objectAtIndex:0] stringValue])
        {
            [self.location setObject:[[[ae elementsForName:@"height"] objectAtIndex:0] stringValue] forKey:@"height"];
        }
        if ([[[ae elementsForName:@"width"] objectAtIndex:0] stringValue])
        {
            [self.location setObject:[[[ae elementsForName:@"width"] objectAtIndex:0] stringValue] forKey:@"width"];
        }
        if ([[[font elementsForName:@"fontname"] objectAtIndex:0] stringValue])
        {
            [self.font setObject:[[[font elementsForName:@"fontname"] objectAtIndex:0] stringValue] forKey:@"fontname"];
        }
        else
        {
            [self.font setObject:@"Arial" forKey:@"fontname"];
        }
        if ([[[font elementsForName:@"size"] objectAtIndex:0] stringValue])
        {
            [self.font setObject:[[[font elementsForName:@"size"] objectAtIndex:0] stringValue] forKey:@"fontsize"];
        }
        else
        {
            [self.font setObject:@"10" forKey:@"fontsize"];
        }
        if ([[[font elementsForName:@"effect"] objectAtIndex:0] stringValue])
        {
            [self.font setObject:[[[font elementsForName:@"effect"] objectAtIndex:0] stringValue] forKey:@"fonttype"];
        }
        NSLog(@"checkboxes values: name:%@ value:%@ location:%@", self.name, self.value, self.location);
    }
    }
    return self;
    
}
@end
