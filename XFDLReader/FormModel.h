//
//  FormModel.h
//  XFDLReader
//
//  Created by Levi on 1/23/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@class FormModel;
@interface FormModel : NSObject
@property (nonatomic, strong) NSString *form_name;
@property (nonatomic, strong) NSString *page_orientation;
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSDictionary *checkboxes;
@property (nonatomic, strong) NSDictionary *comboboxes;
- (id) initWithParameters:(GDataXMLElement *) elements;

@end
@interface PageModel : NSObject
@property (nonatomic, strong) NSMutableArray *pages;
@end