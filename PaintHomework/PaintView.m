#import "PaintView.h"

@implementation PaintView

#pragma mark 重写 drawRect 方法, 实现自定义重绘操作
- (void) drawRect: (CGRect) rect {
    
    /*
     步骤:
     1. 准备遍历笔迹数组
     2. 创建笔迹曲线实例, 接收数组传出的成员
     3. 设置笔迹曲线颜色, 拐角, 结尾点的 style
     4. 完成曲线绘制
     */
    
    for (int i = 0; i < _pathArray.count; i ++) {
        UIBezierPath * path = _pathArray[i];
        [path setLineJoinStyle:kCGLineJoinRound];
        [path setLineCapStyle :kCGLineCapRound ];
        [path stroke];
    }
}

#pragma mark 笔迹开始创建时的设置
- (void) touchesBegan: (NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    /*
     步骤:
     1. 创建触摸点
     2. 取得触摸点位置
     3. 初始化 Bezier 曲线, 从触摸点开始创建.
     4. 设置曲线线宽
     5. 把该曲线添加到笔迹数组
     */
    
    UITouch *touch        = touches.anyObject;
    CGPoint pointLocation = [touch locationInView: touch.view];
    UIBezierPath *path    = [[UIBezierPath alloc]init];
    [path moveToPoint : pointLocation ];
    [path setLineWidth: self.lineWidth];
    NSLog(@"path lineWidth: %f",path.lineWidth);
    [_pathArray addObject: path];
}

#pragma mark 笔记创建过程中的设置
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    /*
     步骤:
     1. 创建触摸点
     2. 取得触摸点位置
     3. 取得笔迹数组的最新添加进去的笔迹曲线, 并让它连接该触摸点位置
     4. 即时显示笔迹: 用setNeedsDisplay标记需要重绘, 异步调用 drawRect 完成重绘
     */
    
    UITouch *touch        = touches.anyObject;
    CGPoint pointLocation = [touch locationInView:touch.view];
    [_pathArray.lastObject addLineToPoint: pointLocation];
    [self setNeedsDisplay];
}

//清屏按钮的设置, 清除所有存储的笔迹, 标记重绘
-(void)clear{
    [_pathArray removeAllObjects];
    [self setNeedsDisplay];
}

//保存按钮的设置
-(void)save{
    
}

@end
