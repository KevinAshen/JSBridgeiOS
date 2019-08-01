//
//  JSBModalView.h
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/7/30.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBBaseView.h"

typedef NS_ENUM(NSInteger, modalViewStyle) {
    viewWithoutCancel,
    viewWithCancel
};


NS_ASSUME_NONNULL_BEGIN

@interface JSBModalView : JSBBaseView

typedef void(^ButtonClick)(NSInteger tag);
@property (nonatomic, copy) ButtonClick buttonAction;

- (instancetype)initWithStyle:(modalViewStyle)style;

@end

NS_ASSUME_NONNULL_END
