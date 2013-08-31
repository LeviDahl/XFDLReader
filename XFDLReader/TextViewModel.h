//
//  TextViewModel.h
//  XFDLReader
//
//  Created by Levi on 2/10/13.
//  Copyright (c) 2013 LeviMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
@class TextViewModel;
@interface TextViewModel : NSObject
@property (strong, nonatomic) NSMutableDictionary *location;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSMutableDictionary *font;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UITextView *field;
@property (nonatomic) bool wasTextModified;
-(id) initWithParameters:(GDataXMLElement *)element andVersion:(NSString *)version;
@end
