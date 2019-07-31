//
//  JSBModalView.m
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/7/30.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBModalView.h"
#import "UIColor+Tool.h"
#import "JSBRequestModalModel.h"

@interface JSBModalView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

//横线
@property (nonatomic, strong) UIView *horizontalLineView;
//竖线
@property (nonatomic, strong) UIView *verticalLineView;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation JSBModalView

- (void)reloadViewWithData:(id)data {
    JSBRequestModalModel *requestModalModel = [[JSBRequestModalModel alloc] init];
    if ([data isKindOfClass:[JSBRequestModalModel class]]) {
        requestModalModel = (JSBRequestModalModel *)data;
    }
    
    self.titleLabel.text = requestModalModel.title;
    
    self.contentLabel.text = requestModalModel.content;
    
    [self.cancelButton setTitle:requestModalModel.cancelText forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorFromHexCode:requestModalModel.cancelColor] forState:UIControlStateNormal];
    
    [self.confirmButton setTitle:requestModalModel.confirmText forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorFromHexCode:requestModalModel.confirmColor] forState:UIControlStateNormal];
    
    self.cancelButton.tag = 0;
    self.confirmButton.tag = 1;
    
    [_cancelButton addTarget:self action:@selector(touchClick:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton addTarget:self action:@selector(touchClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)touchClick:(UIButton *)sender {
    if (self.buttonAction) {
        self.buttonAction(sender.tag);
    } else {
        NSLog(@"ERROR!");
    }
}

- (instancetype)initWithStyle:(modalViewStyle)style {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupTitleLabel];
        switch (style) {
            case viewWithoutCancel:
                [self setupConfirmButtonOnly];
                break;
            case viewWithCancel:
                [self setupCancelConfirm];
                break;
            default:
                break;
        }
        [self setupLineView];
        [self setupContentLabel];
    }
    return self;
}

- (void)setupCancelConfirm {
    [self setupCancelButton];
    
    self.verticalLineView = [[UIView alloc] init];
    [self addSubview:_verticalLineView];
    
    [_verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.cancelButton.mas_top);
        make.left.equalTo(self.cancelButton.mas_right);
        make.width.mas_equalTo(0.5);
    }];
    
    _verticalLineView.backgroundColor = [UIColor colorWithRed:0.91f green:0.90f blue:0.91f alpha:1.00f];
    
    [self setupConfirmButton];
}

- (void)setupCancelButton {
    self.cancelButton = [[UIButton alloc] init];
    [self addSubview:_cancelButton];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(60);
    }];
}

- (void)setupConfirmButton {
    self.confirmButton = [[UIButton alloc] init];
    [self addSubview:_confirmButton];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelButton.mas_right);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(60);
    }];
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(35);
        make.height.mas_equalTo(20);
        make.left.equalTo(self.mas_left).offset(110);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor blackColor];
}

- (void)setupContentLabel {
    self.contentLabel = [[UILabel alloc] init];
    [self addSubview:_contentLabel];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.bottom.equalTo(self.horizontalLineView.mas_top).offset(-20);
        make.left.equalTo(self.mas_left).offset(30);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
}




- (void)setupConfirmButtonOnly {
    self.confirmButton = [[UIButton alloc] init];
    [self addSubview:_confirmButton];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(60);
        make.left.equalTo(self.mas_left);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [_confirmButton setBackgroundColor:[UIColor whiteColor]];
}

- (void)setupLineView {
    self.horizontalLineView = [[UIView alloc] init];
    [self addSubview:_horizontalLineView];
    
    [_horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.confirmButton.mas_top);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    _horizontalLineView.backgroundColor = [UIColor colorWithRed:0.91f green:0.90f blue:0.91f alpha:1.00f];
}
@end
