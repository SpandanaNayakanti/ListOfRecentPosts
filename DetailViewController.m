//
//  DetailViewController.m
//  LoginApp
//
//  Created by Spandana Nayakanti on 12/17/16.
//  Copyright © 2016 Spandana. All rights reserved.
//

#import "DetailViewController.h"
#import "UserPostsTableViewCell.h"

@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *arr;
    UIActivityIndicatorView *spinner;

}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"User Posts";
    spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    // Do any additional setup after loading the view.
    arr=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self webServiceCall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -Fetching User Posts From Server

-(void)webServiceCall{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSDictionary *headers = @{@"Accept": @"application/json"};
    defaultConfigObject.HTTPAdditionalHeaders = headers;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *url =
    [NSURL URLWithString:@"https://api.app.net/posts/stream/global"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"1" forHTTPHeaderField:@"X-ADN-Pretty-JSON"];
    [request setValue:@"Bearer AQAAAAAADpU9zB-etb6a7aKpa91aF_NdBgILGnoXpRjUJp64V8r28CTmJT3QYcIfVW3Jz8kqfYCj-SXT1rRBqSLOop1PiWxMag" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"json" forHTTPHeaderField:@"Data-Type"];
    
    [[session
      dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response,
                                                      NSError *httperror) {
          
          NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
          
          NSMutableDictionary *json = [[NSMutableDictionary alloc]init];
          if (data) {
              json = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingAllowFragments
                                                       error:&httperror];
          }
          arr=[json objectForKey:@"data"];
          [spinner stopAnimating];
          [_TVForUserPosts reloadData];
          NSLog(@"statusCode %ld json %@",(long)statusCode,json);
          
          
          
          
          // "created_at" = "2016-09-05T11:37:08Z";
          
      }] resume];
    
    
    
    
    
    
    
    
}
#pragma mark -TableView  Data Source Methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"userposts";
    UserPostsTableViewCell  *cell = [_TVForUserPosts dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    cell.imgViewForUserAvatar.layer.cornerRadius=cell.imgViewForUserAvatar.frame.size.width/2;
    cell.imgViewForUserAvatar.clipsToBounds=YES;
    cell.lblForUserName.text=[[[arr objectAtIndex:indexPath.row] valueForKey:@"user"] valueForKey:@"username"];
    cell.lblForUserPostText.text=[[arr objectAtIndex:indexPath.row] valueForKey:@"text"];
    
    if ([[[[arr objectAtIndex:indexPath.row] valueForKey:@"user"]valueForKey:@"avatar_image"]valueForKey:@"url"]) {
        
        
        
        NSURL *url =  [NSURL URLWithString:[[[[arr objectAtIndex:indexPath.row] valueForKey:@"user"]valueForKey:@"avatar_image"]valueForKey:@"url"]];
        __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(cell.imgViewForUserAvatar.bounds.size.width/2,cell.imgViewForUserAvatar.bounds.size.height/2);
        activityIndicator.hidesWhenStopped = YES;
        [activityIndicator startAnimating];
        [cell.imgViewForUserAvatar addSubview:activityIndicator];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UserPostsTableViewCell *updateCell = (id)[_TVForUserPosts cellForRowAtIndexPath:indexPath];
                        if (updateCell)
                            [cell.imgViewForUserAvatar setImage:image];
                        [activityIndicator stopAnimating];
                        [activityIndicator removeFromSuperview];
                        
                    });
                }
            }
        }];
        [task resume];
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //calculating text size dynamically for increasing cell height
    
    CGSize constraintSize = {230.0, 20000};
    NSString *commentsString=[[arr objectAtIndex:indexPath.row] valueForKey:@"text"];
    
    NSString *text = commentsString;
    CGFloat width = constraintSize.width;
    UIFont *font = [UIFont fontWithName:@"Verdana" size:17.0f];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:text
     attributes:@
     {
     NSFontAttributeName: font
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize neededSize = rect.size;
    
    return MAX(45, neededSize.height +63);
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
