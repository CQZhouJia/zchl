//
//  CerMessageViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/4/26.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "CerMessageViewController.h"

@interface CerMessageViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
 
    NSString * TMP_UPLOAD_IMG_PATH1;
    UIImagePickerController *_picker;

}
@end

@implementation CerMessageViewController


- (IBAction)backButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backView.layer.cornerRadius = 10;
    self.photoImage.layer.cornerRadius = 5;
    self.photoImage.userInteractionEnabled = YES;
    self.photoImage.backgroundColor = Color_RGBA(246, 246, 246, 1.0);
    
    self.upphotoBtn.layer.cornerRadius = 5;
    self.boomcerbutton.layer.cornerRadius = 5;
    self.ephotobutton.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)upphotoClick:(UIButton *)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        [self showImage];
    }];
    UIAlertAction * alertAction3 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showCamera];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [alertController addAction:alertAction3];
    [self presentViewController:alertController animated:YES completion:nil];

}
#pragma mark - 显示相册照片或拍照

-(void)showCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //--bb---------------------------
        //        [picker shouldAutorotate];
        //        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //        picker.cameraViewTransform = CGAffineTransformMakeRotation(M_PI*45/180);
        //
        //        picker.cameraViewTransform = CGAffineTransformMakeScale(1.5, 1.5);
        //--bb---------------------------
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self presentViewController:picker animated:YES completion:^{
                self.view.center = CGPointMake([FlexibeFrame flexibleFloat:160], [FlexibeFrame flexibleFloat:568 + 568 / 2.0]);
            }];
        } completion:^(BOOL finished) {
        }];
    }else{
        //        [self showTextHUD:@"摄像头无法在模拟器中打开"];
        NSLog(@"摄像头无法在模拟器中打开");
    }
    
}


- (void)showImage
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.navigationBar.translucent = NO;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [imagePickerController shouldAutorotate];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            self.view.center = CGPointMake([FlexibeFrame flexibleFloat:160], [FlexibeFrame flexibleFloat:568 + 568 / 2.0]);
        }];
    } completion:^(BOOL finished) {
        
    }];
    
}


#pragma mark - <UIImagePickerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    _picker = picker;
    UIImage *image;
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else {
        //得到图片
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //图片存入相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    [self saveImage:image WithName:[NSString stringWithFormat:@"%@%@",[self generateUuidString],@".png"]];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}

-(UIImage *)imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.1);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    TMP_UPLOAD_IMG_PATH1=fullPathToFile;
    NSLog(@"%@ --- %@",TMP_UPLOAD_IMG_PATH1,fullPathToFile);
    _photoImage.image = tempImage;
    _ephotobutton.hidden = YES;
    while ([imageData length]>1024*100) {
        tempImage =  [StorageUserInfromation imageCompressForWidth:tempImage targetWidth:tempImage.size.width*0.5];
        imageData =  UIImageJPEGRepresentation(tempImage, 0.3);
    }
    [imageData writeToFile:fullPathToFile atomically:NO];
}


- (NSString *)generateUuidString
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    return uuidString;
}

#pragma mark --点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake([FlexibeFrame flexibleFloat:160], [FlexibeFrame flexibleFloat:568 / 2.0]);
    } completion:^(BOOL finished) {
        [picker dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }];
}



- (IBAction)cerButtonClick:(UIButton *)sender {
    
    if (_username.text.length == 0) {
        [self showHint:@"请输入真实姓名"];
        return;
    }
    
    if (_idcard.text.length == 0) {
        [self showHint:@"请输入身份证号"];
        return;
    }
    
    NSDictionary * dict = @{@"trueName":_username.text,@"cardNo":_idcard.text};
    if (TMP_UPLOAD_IMG_PATH1) {
        NSMutableArray * Array = [[NSMutableArray alloc]init];
        NSMutableArray * array2 = [[NSMutableArray alloc]init];
        NSMutableArray * array3 = [[NSMutableArray alloc]init];
        NSData * picData = [NSData dataWithContentsOfFile:TMP_UPLOAD_IMG_PATH1];
        UIImage * images = [UIImage imageWithData:picData];
        [Array addObject:images];
        [array2 addObject:@"licenseImg"];
        [array3 addObject:Array];
        [array3 addObject:array2];
        [self showHUDWithMessage:@"正在上传..."];
        
        [ZTHttpTool postWithImageUrl:@"Auditing/Commit" param:dict postImageArr:array3  mimeType:@"image/png" success:^(id responseObj) {
//            NSLog(@"%@",[responseObj mj_JSONObject]);
            NSLog(@"%@",responseObj[@"Msg"]);
//            if ([responseObj[@"State"] integerValue] == 0) {
//                storage.nickName = nickNameTextFiled.text;
//                storage.birthday = dateLabel.text;
//                storage.gender = [sexLabel.text isEqual:@"女"]?@"0":@"1";
//                storage.userHeadImage = [NSString stringWithFormat:@"%@", responseObj[@"Data"][@"avatar"] ];
//                [self.navigationController popViewControllerAnimated:YES];
//            }else{
//                [self showHint:responseObj[@"Msg"]];
//            }
            
            [self showHint:responseObj[@"Msg"]];
            [self hideHud];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [self hideHud];
        }];
    }

}


@end
