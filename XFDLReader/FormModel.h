//
//  FormModel.h
//  XFDLReader
//
//  Created by Levi on 1/23/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormModel : NSObject
@property (nonatomic, strong) NSString *form_name;
@property (nonatomic, strong) NSDictionary *labels;
@property (nonatomic, strong) NSDictionary *lines;
@property (nonatomic, strong) NSDictionary *fields;
@property (nonatomic, strong) NSDictionary *checkboxes;
@property (nonatomic, strong) NSDictionary *comboboxes;
@end
