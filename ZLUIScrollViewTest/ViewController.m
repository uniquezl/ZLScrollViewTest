//
//  ViewController.m
//  ZLUIScrollViewTest
//
//  Created by zhulin on 2018/5/23.
//  Copyright © 2018年 zhulin. All rights reserved.
//

#import "ViewController.h"


static const int PicNumber = 5;
static const int kScrollWidth = 300;

static const int kScrollHeight = 200;
@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIButton * next;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, kScrollWidth, kScrollHeight)];

    
    for (int i = 0; i < PicNumber; i++)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScrollWidth, 20, kScrollWidth, kScrollHeight)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_%02d", i + 1]];
        [self.scrollView addSubview:imageView];
    }
    
    //height set to 0 what will happen?
    self.scrollView.contentSize = CGSizeMake(PicNumber*kScrollWidth, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.delegate = self;
    
    //setup pagecontrol
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(60, 180, 50, 30)];
    self.pageControl.numberOfPages = PicNumber;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    //setup button
    self.next = [[UIButton alloc] initWithFrame:CGRectMake(200, 350, 70, 30)];
    [self.next setTitle:@"下一张" forState:UIControlStateNormal];
    [self.next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.next.backgroundColor = [UIColor blueColor];
    [self.next addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.next];
    
    [self initTimer];
   
    [self.view addSubview:self.scrollView];
    //add subview after scrollview to show in front of scrollview, or it will be hided by the scrollview
    [self.view addSubview:self.pageControl];
    
    //or call the super class method
    //[self.view bringSubviewToFront:self.pageControl];
    
}

- (void) initTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(click:) userInfo:nil repeats:YES];
    
    NSRunLoop * mainRunloop = [NSRunLoop mainRunLoop];
    [mainRunloop addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void) click: (UIButton * )sender
{
    CGPoint offSet = self.scrollView.contentOffset;
    
    if (self.pageControl.currentPage == 4)
    {
        self.pageControl.currentPage = 0;
        offSet.x = 0;
    }
    else{
        self.pageControl.currentPage++;
        offSet.x += kScrollWidth;
    }
    [self.scrollView setContentOffset:offSet animated:YES];
    if ([self.timer isValid])
    {
        [self.timer invalidate];
    }
    [self initTimer];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.pageControl.currentPage = scrollView.contentOffset.x/kScrollWidth;
    [self initTimer];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
