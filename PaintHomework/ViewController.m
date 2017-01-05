#import "ViewController.h"
#import "PaintView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISlider  *lineWidthSlider;
@property (weak, nonatomic) IBOutlet UIButton  *clearDraw;
@property (weak, nonatomic) IBOutlet UIButton  *saveDraw;
@property (weak, nonatomic) IBOutlet PaintView *PView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取 slider 值, 加载 pathArray
    self.PView.lineWidth = self.lineWidthSlider.value;
    self.PView.pathArray = [NSMutableArray array];
}


//设置清空按钮点击事件
- (IBAction)clearDidTouched:(UIButton *)sender {
    [self.PView clear];
}


#pragma mark 设置滑动 slider 事件
- (IBAction)sliderValueChanged:(UISlider *)sender {
    /*
     效果:
     1. 设定下一步笔迹宽度
     2. 设定之前所有笔迹宽度
     
     设定之前笔迹宽度步骤:
     1. 准备遍历笔迹数组
     2. 创建笔迹曲线实例, 接收数组传出来的成员
     3. 设置实例曲线的线宽
     4. 标记重绘
     */
    self.PView.lineWidth = self.lineWidthSlider.value;
    
    for (int i = 0; i < self.PView.pathArray.count; i ++) {
        UIBezierPath *path = self.PView.pathArray[i];
        [path setLineWidth:self.lineWidthSlider.value];
    }
    
    [self.PView setNeedsDisplay];
}


#pragma mark 设置保存按钮点击事件
- (IBAction)saveDidTouched:(UIButton *)sender {
    
    UIGraphicsBeginImageContext(self.PView.bounds.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.PView.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image,
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   NULL);
}

#pragma mark 设置保存图片后的提示
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
                                            contextInfo:(void *)contextInfo
{
    //设置提示框的信息
    NSString *msg = nil;
    if (error != NULL) {
        msg = @"保存失败";
    }else{
        msg = @"保存成功";
    }
    
    //设置提示框的显示
    UIAlertController *alertVC = [UIAlertController
                                  alertControllerWithTitle:@"保存图片"
                                                   message:msg
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    //设置提示框Action
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"确定"
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *_Nonnull action)
                                               {
                                                   NSLog(@"确定");
                                               }
                               ];
    
    //添加提示框 Action 到提示框 VC
    [alertVC addAction:okAction];
    
    [self presentViewController:alertVC
                       animated:YES
                     completion:nil];
}


//设置隐藏顶部 bar
-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
