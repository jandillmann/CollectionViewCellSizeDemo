//
//  JDViewController.m
//  CollectionViewCellSizeDemo
//
//  Created by Jan Dillmann on 02.05.14.
//  Copyright (c) 2014 JD. All rights reserved.
//

#import "JDViewController.h"
#import "JDCollectionViewCell.h"

#import "RZCellSizeManager.h"
#import "MBFaker.h"

#define MAX_CELLS 100
#define MAX_WORDS  50


@interface JDViewController ()

@property (strong, nonatomic) RZCellSizeManager* sizeManager;
@property (strong, nonatomic) NSArray* dataArray;

- (void)reloadCells;

@end


@implementation JDViewController

@synthesize sizeManager;
@synthesize dataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureData];
    [self configureSizeManager];
    [self configureView];
}

- (void)configureData
{
    NSMutableArray* data = [NSMutableArray array];
    int cellCount = arc4random_uniform(MAX_CELLS);

    for (int i = 0; i < cellCount; i++) {
        int wordCount = arc4random_uniform(MAX_WORDS);

        [data addObject:[MBFakerLorem words:wordCount]];
    }

    self.dataArray = data;
}

- (void)configureSizeManager
{
    self.sizeManager = [[RZCellSizeManager alloc] init];

    [self.sizeManager registerCellClassName:@"JDCollectionViewCell"
                               withNibNamed:@"JDCollectionViewCell"
                         forReuseIdentifier:@"Cell"
                     withConfigurationBlock:^(JDCollectionViewCell *cell, NSString *text) {
                         [cell.textLabel setText:text];
                     }];

}

- (void)configureView
{
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                   target:self
                                                                                   action:@selector(reloadCells)];
    [self.navigationItem setRightBarButtonItem:refreshButton];

    UINib *collectionViewCellNib = [UINib nibWithNibName:@"JDCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:collectionViewCellNib forCellWithReuseIdentifier:@"Cell"];
}

- (void)reloadCells
{
    [self configureData];

    [self.sizeManager invalidateCellSizeCache];

    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [dataArray objectAtIndex:indexPath.row];

    JDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    [[cell textLabel] setText:text];

    return (UICollectionViewCell *)cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [dataArray objectAtIndex:indexPath.row];

    return [self.sizeManager cellSizeForObject:text indexPath:indexPath cellReuseIdentifier:@"Cell"];
}

@end
