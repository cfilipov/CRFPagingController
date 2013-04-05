//
//  CRFPagingCellCell.m
//  CRFPagingController
//
//  Created by vopilif on 4/4/13.
//  Copyright (c) 2013 Cristian Filipov. All rights reserved.
//

#import "CRFPagingCellView.h"

@implementation CRFPagingCellView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.moreText = @"Load More";
        self.loadingText = @"Loading...";
        self.textLabel.text = self.moreText;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return self;
}

- (void)setLoading:(BOOL)loading animated:(BOOL)animated;
{
    if (loading)
    {
        NSLog(@"selected");
        self.accessoryView = self.activityIndicator;
        [self.activityIndicator startAnimating];
        self.activityIndicator.alpha = 1.0f;
        self.textLabel.text = self.loadingText;
    }
    else
    {
        NSLog(@"deselected");
        self.activityIndicator.alpha = 0.0f;
        [self.activityIndicator stopAnimating];
        self.textLabel.text = self.moreText;
        self.accessoryView = nil;
    }
}

@end
