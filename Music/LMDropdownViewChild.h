//
//  LMDropdownViewChild.h
//  WunHunt
//
//  Created by thanhhaitran on 9/18/15.
//  Copyright (c) 2015 libreteam. All rights reserved.
//

#import "LMDropdownViewChild.h"

typedef enum : NSUInteger {
    LMDropdownViewStateWillOpen,
    LMDropdownViewStateDidOpen,
    LMDropdownViewStateWillClose,
    LMDropdownViewStateDidClose,
} LMDropdownViewState;

@protocol LMDropdownViewDelegate;

@interface LMDropdownViewChild : NSObject

@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat closedScale;
@property (nonatomic, assign) CGFloat blurRadius;
@property (nonatomic, assign) CGFloat blackMaskAlpha;
@property (nonatomic, strong) UIView *menuContentView;
@property (nonatomic, strong) UIColor *menuBackgroundColor;

@property (nonatomic, assign, readonly) LMDropdownViewState currentState;
@property (nonatomic, assign) id <LMDropdownViewDelegate> delegate;

- (BOOL)isOpen;
- (void)showInView:(UIView *)view withFrame:(CGRect)frame;
- (void)hide;

@end


@protocol LMDropdownViewDelegate <NSObject>

@optional

- (void)dropdownViewDidTapBackgroundButton:(LMDropdownViewChild *)dropdownView;

@end
