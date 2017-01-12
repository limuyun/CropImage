//
//  ViewController.m
//  CropImage
//
//  Created by limuyun on 2017/1/10.
//  Copyright © 2017年 biiway. All rights reserved.
//

#import "ViewController.h"
#import "CropImageController.h"
#import "UIImage+Crop.h"
@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *headButton;
@property (nonatomic, strong) UIImagePickerController * pickerController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnClick:(UIButton *)sender {
    
    UIAlertController * con = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction * camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        [con addAction:camera];
    }
    UIAlertAction * photo = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [con addAction:photo];
    [con addAction:cancel];
    [self presentViewController:con animated:YES completion:nil];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    [picker dismissViewControllerAnimated:YES completion:^{
         UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        CropImageController * con = [[CropImageController alloc] initWithImage:image delegate:self];
        [self.navigationController pushViewController:con animated:YES];
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = image.size.height * (width/image.size.width);
    UIImage * orImage = [image resizeImageWithSize:CGSizeMake(width, height)];
    CropImageController * con = [[CropImageController alloc] initWithImage:orImage delegate:self];
    con.ovalClip = YES; 
    [self.navigationController pushViewController:con animated:YES];
}
#pragma mark -- CropImageDelegate
- (void)cropImageDidFinishedWithImage:(UIImage *)image {
    [_headButton setBackgroundImage:image forState:UIControlStateNormal];
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIStatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
@end
