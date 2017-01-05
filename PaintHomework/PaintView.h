#import <UIKit/UIKit.h>

@interface PaintView : UIView

@property (nonatomic, assign) CGFloat lineWidth;

//保存所有笔迹的数组
@property (nonatomic, strong) NSMutableArray *pathArray;

- (void) clear; //清空的方法
- (void) save ; //保存的方法

@end
