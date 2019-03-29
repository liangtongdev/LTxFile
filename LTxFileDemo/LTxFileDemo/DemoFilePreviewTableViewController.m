//
//  DemoFilePreviewTableViewController.m
//  LTxFileDemo
//
//  Created by liangtong on 2019/3/29.
//  Copyright © 2019 LIANGTONG. All rights reserved.
//

#import "DemoFilePreviewTableViewController.h"
#import <LTxFile/LTxFile.h>

@interface DemoFilePreviewTableViewController ()

@end

@implementation DemoFilePreviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* identifier = cell.reuseIdentifier;
    
    LTxFilePreviewViewController* previewVC = [[LTxFilePreviewViewController alloc] init];
    if ([identifier isEqualToString:@"local pdf file"]) {
        previewVC.filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"filePreview_local" ofType:@"pdf"]];
    }else if ([identifier isEqualToString:@"local video"]) {
        previewVC.filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"filePreview_local" ofType:@"MOV"]];
    }else if ([identifier isEqualToString:@"local html"]) {
        previewVC.filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"filePreview_local" ofType:@"html"]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:previewVC animated:true];
    });
}


@end
