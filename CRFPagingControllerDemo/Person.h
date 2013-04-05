//
//  Person.h
//  CRFPagingController
//
//  Created by vopilif on 4/3/13.
//  Copyright (c) 2013 Cristian Filipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, strong)   NSString * name;
@property (nonatomic, strong)   NSString * blurb;
@property (nonatomic, strong)   NSString * wikipediaURL;
@property (nonatomic, strong)   UIImage  * flag;

+ (id)withName:(NSString *)name flag:(UIImage *)flag url:(NSString *)wikipediaURL blurb:(NSString *)blurb;

@end
