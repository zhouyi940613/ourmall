//
//  LrdOutputView.h
//  LrdOutputView
//
//  Created by Jay on 16/7/12.
//  Copyright © 2016年 MaBang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LrdOutputViewDelegate <NSObject>

@required
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath;

@end

typedef void(^dismissWithOperation)();

typedef NS_ENUM(NSUInteger, LrdOutputViewDirection) {
    kLrdOutputViewDirectionTop = 1,
    kLrdOutputViewDirectionDown
};

@interface LrdOutputView : UIView

@property (nonatomic, weak) id<LrdOutputViewDelegate> delegate;
@property (nonatomic, strong) dismissWithOperation dismissOperation;

//初始化方法
//传入参数：模型数组，弹出原点，宽度，高度（每个cell的高度）
- (instancetype)initWithDataArray:(NSArray *)dataArray
                           origin:(CGPoint)origin
                            width:(CGFloat)width
                           height:(CGFloat)height
                        direction:(LrdOutputViewDirection)direction;

//弹出
- (void)pop;
//消失
- (void)dismiss;

@end


@interface LrdCellModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end