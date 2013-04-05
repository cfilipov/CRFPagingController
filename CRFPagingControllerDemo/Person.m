//
//  Person.m
//  CRFPagingController
//
//  Created by vopilif on 4/3/13.
//  Copyright (c) 2013 Cristian Filipov. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (id)withName:(NSString *)name flag:(UIImage *)flag url:(NSString *)wikipediaURL blurb:(NSString *)blurb;
{
    Person *person = [[Person alloc] init];
    person.name = name;
    person.blurb = blurb;
    person.wikipediaURL = wikipediaURL;
    person.flag = flag;
    return person;
}

@end
