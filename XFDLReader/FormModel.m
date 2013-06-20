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
#import "CheckBoxModel.h"
#import "CellModel.h"
#import "ComboBoxModel.h"
@implementation FormModel
-(id) initWithParameters:(GDataXMLElement *) elements andVersion:(NSString *)version{
if (self){
    self.labels = [[NSMutableArray alloc] init];
    self.lines = [[NSMutableArray alloc] init];
    self.fields = [[NSMutableArray alloc] init];
    self.images = [[NSMutableArray alloc] init];
    self.data = [[NSMutableArray alloc] init];
    self.checkboxes = [[NSMutableArray alloc] init];
    self.comboboxes = [[NSMutableArray alloc] init];
    self.cells = [[NSMutableArray alloc] init];
    if ([version isEqualToString:@"6.5"])
    {
   
    self.form_name =[elements attributeForName:@"sid"].stringValue;
    self.page_orientation = [[[[[elements elementsForName:@"global"] objectAtIndex:0] elementsForName:@"vfd_pagesize"] objectAtIndex:0]stringValue];
    
    for (GDataXMLElement *labels in [elements elementsForName:@"label"]) {
            if (![[labels attributeForName:@"sid"].stringValue isEqualToString:@"TOP"] && ![[labels attributeForName:@"sid"].stringValue isEqualToString:@"LEFT"] && ![[labels attributeForName:@"sid"].stringValue isEqualToString:@"NEXT"] && ![[labels attributeForName:@"sid"].stringValue isEqualToString:@"PREVIOUS"] && ![[labels attributeForName:@"sid"].stringValue isEqualToString:@"WIZARD"] && ![[labels attributeForName:@"sid"].stringValue isEqualToString:@"TOOLBAR_VERSION"] && ![[labels attributeForName:@"sid"].stringValue isEqualToString:@"TOOLBAR_GLOBALS"] && ![[labels attributeForName:@"sid"].stringValue isEqualToString:@"VE_COMMENT1"]) {
               
            
            if ([labels elementsForName:@"image"] != nil)
            {
                ImageModel *image = [[ImageModel alloc] initWithParameters:labels];
                [self.images addObject:image];
            }
            else
            {
                LabelModel *label = [[LabelModel alloc] initWithParameters:labels andVersion:version];
                [self.labels addObject:label];
            }
            }
            else
            {
                NSLog(@"wizard labels");
            }
      }
        for (GDataXMLElement *lines in [elements elementsForName:@"line"]) {
                  LineModel *line = [[LineModel alloc] initWithParameters:lines andVersion:version];
                    [self.lines addObject:line];
                }
      for (GDataXMLElement *fields in [elements elementsForName:@"field"]) {
      if (![[fields attributeForName:@"sid"].stringValue isEqualToString:@"RTEDNM"] && ![[fields attributeForName:@"sid"].stringValue isEqualToString:@"SSN_PRINT"] &&  ![[fields attributeForName:@"sid"].stringValue isEqualToString:@"VE_COMMENT1"] )
      {
          TextViewModel *field = [[TextViewModel alloc] initWithParameters:fields andVersion:version];
        [self.fields addObject:field];
      }
    }
    for (GDataXMLElement *datas in [elements elementsForName:@"data"]) {
       DataModel *data = [[DataModel alloc] initWithParameters:datas];
        [self.data addObject:data];
    }
        for (GDataXMLElement *checks in [elements elementsForName:@"check"]) {
            CheckBoxModel *check = [[CheckBoxModel alloc] initWithParameters:checks andVersion:version];
            [self.checkboxes addObject:check];
        }
        for (GDataXMLElement *combobox in [elements elementsForName:@"combobox"]) {
            ComboBoxModel *combo = [[ComboBoxModel alloc] initWithParameters:combobox andVersion:version];
            [self.comboboxes addObject:combo];
        }
        for (GDataXMLElement *cells in [elements elementsForName:@"cell"]) {
            CellModel *cell = [[CellModel alloc] initWithParameters:cells andVersion:version];
            [self.cells addObject:cell];
        }
        NSLog(@"labels: %lu, lines: %lu fields: %lu images: %lu data: %lu pagename:%@ checkboxes:%lu cells:%lu version:%@", (unsigned long)[self.labels count], (unsigned long)[self.lines count], (unsigned long)[self.fields count], (unsigned long)[self.images count], (unsigned long)[self.data count],[elements attributeForName:@"sid"].stringValue, (unsigned long)[self.checkboxes count],(unsigned long)[self.cells count], version);

}
    else if ([version isEqualToString:@"7.7"]||[version isEqualToString:@"7.6"])
    {
        NSLog(@"new version");
        for (GDataXMLElement *labels in [elements elementsForName:@"label"]) {
            LabelModel *label = [[LabelModel alloc] initWithParameters:labels andVersion:version];
            [self.labels addObject:label];
            
        }
        for (GDataXMLElement *lines in [elements elementsForName:@"line"]) {
            LineModel *line = [[LineModel alloc] initWithParameters:lines andVersion:version];
            [self.lines addObject:line];
        }
        for (GDataXMLElement *fields in [elements elementsForName:@"field"]) {
            if (![[fields attributeForName:@"sid"].stringValue isEqualToString:@"RTEDNM"] && ![[fields attributeForName:@"sid"].stringValue isEqualToString:@"SSN_PRINT"] &&  ![[fields attributeForName:@"sid"].stringValue isEqualToString:@"VE_COMMENT1"] )
            {
                TextViewModel *field = [[TextViewModel alloc] initWithParameters:fields andVersion:version];
                [self.fields addObject:field];
            }
        }
        for (GDataXMLElement *checks in [elements elementsForName:@"check"]) {
            CheckBoxModel *check = [[CheckBoxModel alloc] initWithParameters:checks andVersion:version];
            [self.checkboxes addObject:check];
        }
        NSLog(@"labels: %lu, lines: %lu fields: %lu images: %lu data: %lu pagename:%@ checkboxes:%lu version: %@", (unsigned long)[self.labels count], (unsigned long)[self.lines count], (unsigned long)[self.fields count], (unsigned long)[self.images count], (unsigned long)[self.data count],[elements attributeForName:@"sid"].stringValue, (unsigned long)[self.checkboxes count], version);
        NSLog(@"strange version");
    }
    else
    {
        NSLog(@"What version is this? %@", version);
    }
}
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
