//
//  CRFPagingController
//
//  Copyright (c) 2013, Cristian Filipov. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are
//  met:
//
//  1. Redistributions of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//
//  3. Neither the name of the Cristian Filipov nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
//  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
//  TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
//  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
//  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
//  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
//  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  // // // // // // // // // // // // // // // // // // // // // // // // //
//
//  CRFPagingCellView is the default implementation of the CRFPagingCell
//  protocol. The CRFPagingController uses a UITableViewCell instance which
//  adheres to CRFPagingCell for the trigger cell.
//
//  To customize your own CRFPagingCell, subclass UITableViewCell and implement
//  the CRFPagingCell methods to set the content of the loading and regular
//  states.
//

#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////

@protocol CRFPagingCell <NSObject>

- (void)setLoading:(BOOL)loading animated:(BOOL)animated;

@end

////////////////////////////////////////////////////////////////////////////////

@interface CRFPagingCellView : UITableViewCell <CRFPagingCell>

@property (nonatomic, strong) NSString                * moreText;
@property (nonatomic, strong) NSString                * loadingText;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@property (nonatomic, assign) BOOL                      loading;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end


