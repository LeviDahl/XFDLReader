//
//  LabelModel.m
//  XFDLReader
//
//  Created by Levi on 1/23/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import "LabelModel.h"

@implementation LabelModel
-(id) initWithParameters:(GDataXMLElement *)element andVersion:(NSString *)version{
    if (self){
        self.location = [[NSMutableDictionary alloc] init];
        self.font = [[NSMutableDictionary alloc] init];

        if ([version isEqualToString: @"6.5"])
        {
            self.visible = TRUE;
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
                if ([element elementsForName:@"fontinfo"] != nil){
                for (GDataXMLElement *ae in [element elementsForName:@"fontinfo"])
        {
                NSArray *values = [ae elementsForName:@"ae"];
            if ((GDataXMLElement *)[values objectAtIndex:0]) {
            [self.font setObject:[(GDataXMLElement *)[values objectAtIndex:0] stringValue] forKey:@"fontname"];
            }
            else
            {
                [self.font setObject:@"Arial" forKey:@"fontname"];
            }
            if ((GDataXMLElement *)[values objectAtIndex:1] != nil) {

                    [self.font setObject:[(GDataXMLElement *)[values objectAtIndex:1] stringValue] forKey:@"fontsize"];
            }
            else
            {
                [self.font setObject:@"10" forKey:@"fontsize"];
            }
                    [self.font setObject:[(GDataXMLElement *)[values objectAtIndex:2] stringValue] forKey:@"fonttype"];
        }
                }
                else
                {
                    [self.font setObject:@"Arial" forKey:@"fontname"];
                     [self.font setObject:@"10" forKey:@"fontsize"];
                }
        self.justify = [(GDataXMLElement *)[[element elementsForName:@"justify"] objectAtIndex:0] stringValue];

        NSLog(@"label values: name:%@ value:%@ justify:%@ location:%@ ", self.name, self.value, self.justify, self.location);
            }
    
            }
    
    else if ([version isEqualToString: @"7.7"]|| [version isEqualToString: @"7.6"])
    {
        self.name = [element attributeForName:@"sid"].stringValue;
        GDataXMLElement *ae = [[element elementsForName:@"itemlocation"] objectAtIndex:0];
        GDataXMLElement *font = [[element elementsForName:@"fontinfo"] objectAtIndex:0];

      
        {

        if ([ae elementsForName:@"within"] == nil)
        {
                     self.visible = TRUE;
            if ([[element elementsForName:@"value"] objectAtIndex:0] != NULL)
            {
             
                self.value = [(GDataXMLElement *)[[element elementsForName:@"value"] objectAtIndex:0] stringValue];
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

                     NSLog(@"label values: name:%@ value:%@ justify:%@ location:%@ ", self.name, self.value, self.justify, self.location);
            }
        }
            else
            {
                         self.visible = FALSE;
                NSLog(@"within toolbar %@",self.name);
            }
        }
    }
    }
    return self;
}
-(NSString *)description {
    return self.name;
}
@end
