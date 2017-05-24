//
//  LSPreMessagViewController.m
//  LSOnline
//
//  Created by jglx on 17/4/5.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "LSPreMessagViewController.h"
#import "JGEditDataTableViewCell.h"
#import "JGEditDataNickNameTableViewCell.h"
#import "JGUserImageTableViewCell.h"
#import "JG_SimulateActionSheet.h"
#import "JGSimulateActionSheetForDatePicker.h"
#import "ZCmessageTableViewCell.h"
#import "MyjianliViewController.h"

@interface LSPreMessagViewController ()<UITableViewDelegate,UITableViewDataSource,SimulateActionSheetDelegate,JGSimulateActionSheetForDatePickerDelegate,UIPickerViewDelegate,UIActionSheetDelegate,TouchTableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITextField * nickNameTextFiled;
    UILabel * sexLabel;
    UILabel * dateLabel;
    JG_SimulateActionSheet *sheet;
    JGSimulateActionSheetForDatePicker * datePicker;  //时间选择视图
    NSArray* arrays;
    NSString * userHeaderImageUrl;
    UIImageView * userHeaderImage;
    NSString * TMP_UPLOAD_IMG_PATH1;
    UIImagePickerController *_picker;

    
    
    UIActionSheet * actionSheet;  //适配ios7
  
}


@end

@implementation LSPreMessagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.touchDelegate = self;
    self.myTableView.backgroundColor = backGroundColor;
    arrays = [NSArray arrayWithObjects:@"男",@"女", nil];
    
    [self customTableViewFooter];
}

-(void)customTableViewFooter{
    UIView * myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [FlexibeFrame flexibleFloat:320], 100)];
    myView.backgroundColor = [UIColor clearColor];
    
    UIButton * myBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 30,[FlexibeFrame flexibleFloat:320]-40, 40)];
    [myBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [myBtn addTarget:self action:@selector(comformBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    myBtn.backgroundColor = RGBCOLOR(39,156,125);
    myBtn.layer.cornerRadius = 3;
    [myView addSubview:myBtn];
    self.myTableView.tableFooterView = myView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 15;
    }else{
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    if (indexPath.section == 0 && indexPath.row == 0) {
        JGUserImageTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"JGUserImageTableViewCell" owner:self options:nil] lastObject];
        if (userHeaderImageUrl) {
            [cell.userHeaderImage sd_setImageWithURL:[NSURL URLWithString:userHeaderImageUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
            
        }else{
            NSLog(@"%@",storage.userHeadImage);
            [cell.userHeaderImage sd_setImageWithURL:[NSURL URLWithString:storage.userHeadImage] placeholderImage:[UIImage imageNamed:@"default_head"]];
            userHeaderImage = cell.userHeaderImage;
        }
//        cell.userHeaderImage.image = [UIImage imageNamed:@"photo"];
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        JGEditDataNickNameTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"JGEditDataNickNameTableViewCell" owner:self options:nil] lastObject];
        if ([nickNameTextFiled.text length]!=0) {
        }else{
            cell.nickNameTextFiled.text = storage.nickName;
            nickNameTextFiled = cell.nickNameTextFiled;
        }
//        cell.nickNameTextFiled.text = @"李小娜";
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        JGEditDataTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"JGEditDataTableViewCell" owner:self options:nil] lastObject];
        cell.markName.text = @"生日";
            if ([dateLabel.text length]!=0) {
//                                cell.countentLabel.text = dateLabel.text;
            }else{
                if ([storage.birthday length] == 0) {
                    cell.countentLabel.text = @"1982-10-20";
                    
                }else{
                    cell.countentLabel.text = storage.birthday;
                }
                dateLabel = cell.countentLabel;
            }
            return cell;
        }else if (indexPath.section == 0 && indexPath.row == 3){
            JGEditDataTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"JGEditDataTableViewCell" owner:self options:nil] lastObject];

            cell.markName.text = @"性别";
            if ([sexLabel.text length]!=0) {
//                                cell.countentLabel.text = sexLabel.text;
            }else{
            if ([storage.gender integerValue] == 0) {
                cell.countentLabel.text = @"女";
        
            }else{
               cell.countentLabel.text = @"男";
                    
            }
                sexLabel = cell.countentLabel;
            }
           return cell;
    }else if (indexPath.section == 0 && indexPath.row == 4){
        
        ZCmessageTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"ZCmessageTableViewCell" owner:self options:nil] lastObject];
        cell.leftLabel.text = @"我的收获地址";
        return cell;

    }else{
        ZCmessageTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"ZCmessageTableViewCell" owner:self options:nil] lastObject];
        cell.leftLabel.text = @"我的简历";
        return cell;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 70;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) { // 性别选择
        [nickNameTextFiled resignFirstResponder];
        [datePicker dismiss:self];
        
        sheet = [JG_SimulateActionSheet styleDefault];
        sheet.delegate = self;
        //必须在设置delegate之后调用，否则无法选中指定的行
        [sheet selectRow:1 inComponent:0 animated:YES]; // selectRow 是默认指定选中哪一行
        [sheet show:self];
    }
    if (indexPath.row == 2) { // 生日选择
        [nickNameTextFiled resignFirstResponder];
        [sheet dismiss:self];
        datePicker = [JGSimulateActionSheetForDatePicker styleDefault];
        datePicker.pickerView.datePickerMode = UIDatePickerModeDate;
        datePicker.pickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        // 设置当前显示时间
        NSString *currentDateString = dateLabel.text;
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *currentDate = [dateFormater dateFromString:currentDateString];
        
        [datePicker.pickerView setDate:currentDate animated:YES];
        // 设置显示最大时间（此处为当前时间）
        [datePicker.pickerView setMaximumDate:[NSDate date]];
        datePicker.delegate = self;
        
        [datePicker show:self];
    }
    if (indexPath.row == 0 && indexPath.section == 0) { // 头像选择
        if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0) {
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
            // This code will compile on versions >= ios8.0
        }else{
            actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
            
            [actionSheet showInView:self.view];
        }
    }
    
    if (indexPath.section == 1) {
        //我的简历
        MyjianliViewController * jianPage = [[MyjianliViewController alloc] init];
        [self.navigationController pushViewController:jianPage animated:YES];
    }
}

#pragma mark -UIActionSheet Delegate-
// This code will compile on versions<8.0


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            
            [self showImage];
            break;
        case 1:
            [self showCamera];
            break;
        default:
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [FlexibeFrame flexibleFloat:320], 15)];
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}

-(void)comformBtnClick:(UIButton *)sender{
    
    [nickNameTextFiled resignFirstResponder];
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    NSString * sexStr;
    if ([storage.gender integerValue] == 0) {
        sexStr = @"女";
    }else{
        sexStr = @"男";
    }
    if (TMP_UPLOAD_IMG_PATH1==nil && [nickNameTextFiled.text isEqual:storage.nickName]&& [dateLabel.text isEqual:storage.birthday]&&[sexLabel.text isEqual:sexStr]) {
        [self showTextHUD:@"未作任何修改"];
        return;
    }
    NSLog(@"%@",storage.userID);
    
    //更新年龄
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDate=[dateFormatter dateFromString:[NSString stringWithFormat:@"%@",dateLabel.text]];
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
//    NSInteger unitFlags = NSCalendarUnitYear;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger unitFlags = NSCalendarUnitYear;

    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:birthDate];
    
    //现在
    NSDate *now = [NSDate date];
    
    NSDateComponents *comps2 = [calendar components:unitFlags fromDate:now];
    
    NSUInteger userAge = comps2.year - comps.year;
    
    storage.age = [NSString stringWithFormat:@"%ld",(unsigned long)userAge];
    //*****************************
    
//    NSDictionary * dict = @{@"nickName":nickNameTextFiled.text,@"birthday":dateLabel.text,@"sex":sexLabel.text};
    NSLog(@"%@ ---- %@ ---  %@",nickNameTextFiled.text,dateLabel.text,sexLabel.text);
      NSDictionary * dict = @{@"nickName":nickNameTextFiled.text,@"birthday":dateLabel.text,@"sex":sexLabel.text};
    if (TMP_UPLOAD_IMG_PATH1) {
        NSMutableArray * Array = [[NSMutableArray alloc]init];
        NSMutableArray * array2 = [[NSMutableArray alloc]init];
        NSMutableArray * array3 = [[NSMutableArray alloc]init];
        NSData * picData = [NSData dataWithContentsOfFile:TMP_UPLOAD_IMG_PATH1];
        UIImage * images = [UIImage imageWithData:picData];
        [Array addObject:images];
        [array2 addObject:@"logo"];
        [array3 addObject:Array];
        [array3 addObject:array2];
        [self showHUDWithMessage:@"正在上传..."];
        
        [ZTHttpTool postWithImageUrl:@"UserCenter/EditUserInfo" param:dict postImageArr:array3  mimeType:@"image/png" success:^(id responseObj) {
            NSLog(@"%@",[responseObj mj_JSONObject]);
            NSLog(@"%@",responseObj[@"Msg"]);
            if ([responseObj[@"State"] integerValue] == 0) {
                storage.nickName = nickNameTextFiled.text;
                storage.birthday = dateLabel.text;
                storage.gender = [sexLabel.text isEqual:@"女"]?@"0":@"1";
                storage.userHeadImage = [NSString stringWithFormat:@"%@", responseObj[@"Data"][@"avatar"] ];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showHint:responseObj[@"Msg"]];
            }
            [self hideHud];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [self hideHud];
        }];
    }else{
        [self showHUDWithMessage:@"正在上传..."];
        [ZTHttpTool postWithUrl:@"UserCenter/EditUserInfo" param:dict success:^(id responseObj) {
            if ([responseObj[@"State"] integerValue] == 0) {
                NSLog(@"%@",[responseObj mj_JSONObject]);
                NSLog(@"%@",responseObj[@"Msg"]);
                storage.nickName = nickNameTextFiled.text;
                storage.birthday = dateLabel.text;
                storage.gender = [sexLabel.text isEqual:@"女"]?@"0":@"1";
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showHint:responseObj[@"Msg"]];
            }
            [self hideHud];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [self hideHud];
        }];
    }


}

-(void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [nickNameTextFiled resignFirstResponder];
}

#pragma SelfActionSheet
-(void)actionCancle{
    [sheet dismiss:self];
}
-(void)actionDone{
    [sheet dismiss:self];
    NSUInteger index = [sheet selectedRowInComponent:0];
    NSLog(@"done with index of %ld",index);
    sexLabel.text = [arrays objectAtIndex:index];
}
-(void)actionCancle2{
    [datePicker dismiss:self];
}
-(void)actionDone2{
    [datePicker dismiss:self];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *showtimeNew = [formatter1 stringFromDate:datePicker.pickerView.date];
    dateLabel.text = showtimeNew;
}


#pragma mark pickerView --男女 

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrays.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrays objectAtIndex:row];
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
    userHeaderImage.image = tempImage;
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

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
