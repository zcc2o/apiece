//
//  ZCCComposeViewController.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/8.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCComposeViewController.h"
#import "ZCCComposePicsListCollectionView.h"
#import "ZCCCommon.h"
#import "AFNetworking.h"
#import "ZCCPersonInfoModel.h"
@interface ZCCComposeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UIView *tabBarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabbarToBottomDistants;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;

- (IBAction)pictureBtnClicked:(id)sender;

- (IBAction)keyBoardBtnClicked:(id)sender;

@property (weak, nonatomic)ZCCComposePicsListCollectionView *picsCollectionView;

@property (nonatomic, strong)NSMutableArray *picsArray;

@property (weak, nonatomic) IBOutlet UIButton *keyboardBtn;

@end

@implementation ZCCComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationTheFrameAboutKyebord:) name:UIKeyboardDidChangeFrameNotification object:nil];
}


- (void)addViews{
    
    UICollectionViewFlowLayout *collectionVFL = [[UICollectionViewFlowLayout alloc] init];
    
    collectionVFL.itemSize = CGSizeMake((SCREENWIDTH*1.0 - 4)/ 3 , (SCREENWIDTH*1.0 - 4) / 3);
    
    collectionVFL.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    
    collectionVFL.minimumLineSpacing = 1;
    collectionVFL.minimumInteritemSpacing = 1;
    
    ZCCComposePicsListCollectionView *picCollectionView = [[ZCCComposePicsListCollectionView alloc] initWithFrame:CGRectMake(0, 200, SCREENWIDTH, (SCREENWIDTH*2.0 / 3)) collectionViewLayout:collectionVFL];
    
    [self.view insertSubview:picCollectionView belowSubview:_tabBarView];
    
    self.picsCollectionView = picCollectionView;
    
    self.picsCollectionView.hidden = YES;
    
    UIBarButtonItem *quitBtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(quitBtnClicked)];
    [quitBtn setImage:[[UIImage imageNamed:@"cancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.navigationItem.leftBarButtonItem = quitBtn;
    
    
    
    UIBarButtonItem *submitBtn = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(submitBtnClicked)];
    self.navigationItem.rightBarButtonItem = submitBtn;
    
    _contentTextView.text = @"请输入话题内容";
    
    _contentTextView.textColor = [UIColor lightGrayColor];
    
    _contentTextView.delegate = self;
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    textView.text = @"";
    
    _contentTextView.textColor = [UIColor blackColor];
    
    return YES;
}

//点击textView跳出键盘时 工具条往上移

- (void)notificationTheFrameAboutKyebord:(NSNotification *)notification{
    
    NSLog(@"%@",notification);
    
    
    
    NSLog(@"键盘选中状态%d",self.keyboardBtn.selected);
    
    CGFloat duration = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    NSValue *keyBoardValue = notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    
    CGRect keyboardRect = keyBoardValue.CGRectValue;
    
    if(keyboardRect.origin.y<700){
        self.keyboardBtn.selected = true;
    }else{
        self.keyboardBtn.selected = false;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.tabbarToBottomDistants.constant = SCREENHEIGHT - keyboardRect.origin.y;
        
    }];
    
}


//打开相册
- (IBAction)pictureBtnClicked:(id)sender {
    
    self.picsCollectionView.hidden = NO;
    
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePickerVC.delegate = self;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}
//打开相册点击图片后 就把图片传到self.picsCollectionView上去
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"%@",info);
    
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    [self.picsArray addObject:image];
    
    self.picsCollectionView.picsArray = _picsArray;
}


- (IBAction)keyBoardBtnClicked:(id)sender {
    self.keyboardBtn.selected = !self.keyboardBtn.selected;
    NSLog(@"键盘选中状态%d",self.keyboardBtn.selected);
    
    if (self.keyboardBtn.selected) {
        [self.contentTextView becomeFirstResponder];
    }else{
        [self.contentTextView resignFirstResponder];
    }
    
}



- (void)submitBtnClicked{
    
    [self submitTalk];
    
}

- (void)submitTalk{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    ZCCPersonInfoModel *personInfoModel = [ZCCPersonInfoModel sharedZCCPersonInfoModel];
    
    [mgr.requestSerializer setValue:personInfoModel.accesstoken forHTTPHeaderField:@"accesstoken"];
    
    NSString *apiStr = [NSString stringWithFormat:@"%@/index.php/talkto/index/sendTalk",HTTPHEAD];
    
    NSDictionary *parameters = @{@"talkContent":_contentTextView.text};
    
    [mgr POST:apiStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for(int i = 0; i<_picsArray.count; i++){
            
            UIImage *image = _picsArray[i];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            [formData appendPartWithFileData:imageData name:@"uploadFile[]" fileName:[NSString stringWithFormat:@"%d.jpg",i] mimeType:@"image/jpg"];
            
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"1"]){
            NSLog(@"发布成功");
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}


- (void)quitBtnClicked{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)picsArray{
    
    if(_picsArray == nil){
        _picsArray = [NSMutableArray array];
    }
    return _picsArray;
}

@end
