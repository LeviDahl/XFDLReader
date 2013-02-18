//
//  FormModel.m
//  XFDLReader
//
//  Created by Levi on 1/23/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import "FormModel.h"
#import "LabelModel.h"
#import "LineModel.h"
#import "TextViewModel.h"
#import "ImageModel.h"
#import "DataModel.h"
@implementation FormModel
-(id) initWithParameters:(GDataXMLElement *) elements{
if (self){
    self.labels = [[NSMutableArray alloc] init];
    self.lines = [[NSMutableArray alloc] init];
        self.fields = [[NSMutableArray alloc] init];
     self.images = [[NSMutableArray alloc] init];
    self.data = [[NSMutableArray alloc] init];
    self.form_name =[elements attributeForName:@"sid"].stringValue;
    self.page_orientation = [[[[[elements elementsForName:@"global"] objectAtIndex:0] elementsForName:@"vfd_pagesize"] objectAtIndex:0]stringValue];
    
    for (GDataXMLElement *labels in [elements elementsForName:@"label"]) {
            if (![[labels attributeForName:@"sid"].stringValue isEqualToString:@"TOP"] && ![[labels attributeForName:@"sid"].stringValue isEqualToString:@"LEFT"] && ![[labels attributeForName:@"sid"].stringValue isEqualToString:@"NEXT"] && ![[labels attributeForName:@"sid"].stringValue isEqualToString:@"PREVIOUS"] && ![[labels attributeForName:@"sid"].stringValue isEqualToString:@"WIZARD"] && ![[labels attributeForName:@"sid"].stringValue isEqualToString:@"TOOLBAR_VERSION"] && ![[labels attributeForName:@"sid"].stringValue isEqualToString:@"TOOLBAR_GLOBALS"]) {
               
            
            if ([labels elementsForName:@"image"] != nil)
            {
                ImageModel *image = [[ImageModel alloc] initWithParameters:labels];
                [self.images addObject:image];
            }
            else
            {
                LabelModel *label = [[LabelModel alloc] initWithParameters:labels];
                [self.labels addObject:label];
            }
            }
            else
            {
                NSLog(@"wizard labels");
            }
      }
        for (GDataXMLElement *lines in [elements elementsForName:@"line"]) {
                    LineModel *line = [[LineModel alloc] initWithParameters:lines];
                    [self.lines addObject:line];
                }
      for (GDataXMLElement *fields in [elements elementsForName:@"field"]) {
      if (![[fields attributeForName:@"sid"].stringValue isEqualToString:@"RTEDNM"] && ![[fields attributeForName:@"sid"].stringValue isEqualToString:@"SSN_PRINT"] )
      {
          TextViewModel *field = [[TextViewModel alloc] initWithParameters:fields];
        [self.fields addObject:field];
      }
    }
    for (GDataXMLElement *datas in [elements elementsForName:@"data"]) {
       DataModel *data = [[DataModel alloc] initWithParameters:datas];
        [self.data addObject:data];
    }
}
      NSLog(@"labels: %lu, lines: %lu fields: %lu images: %lu data: %lu pagename:%@", (unsigned long)[self.labels count], (unsigned long)[self.lines count], (unsigned long)[self.fields count], (unsigned long)[self.images count], (unsigned long)[self.data count],[elements attributeForName:@"sid"].stringValue);
    return self;
}
-(NSString *)description {
    return self.form_name;
}
@end
@implementation PageModel
- (id) initWithParameters:(NSArray *)page {
    [self.pages addObject:page];
    return self;
}
-(id) init {
    self.pages = [[NSMutableArray alloc] init];
    return self;
}

@end
