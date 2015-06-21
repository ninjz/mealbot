//
//  MBotCollectionViewController.m
//  mealbot
//
//  Created by caL_ on 2015-06-16.
//  Copyright (c) 2015 Mealbot inc. All rights reserved.
//

#import "MBotCollectionViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MBotCollectionViewController ()
@property(nonatomic, strong) NSArray *recipes;
@end

@implementation MBotCollectionViewController

static NSString * const reuseIdentifier = @"RecipeCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.collectionViewLayout = [KRLCollectionViewGridLayout new];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecipeCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [[MBotAPIClient sharedClient] getRecipesWithIngredients:@[@"eggs", @"potatoes"]
                                                    success:^(NSURLSessionDataTask *task, id responseObject){
                                                        NSLog(@"Success -- %@", responseObject);
                                                        self.recipes = responseObject[@"results"];
                                                        [self.collectionView reloadData];
                                                    }
                                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                        NSLog(@"Failure -- %@", error);
                                                    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.recipes count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell
    RecipeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *recipe = self.recipes[indexPath.row];
    
    cell.recipeName.text = recipe[@"name"];
    
    // load image for cell
    [cell.recipeImage sd_setImageWithURL:[NSURL URLWithString:recipe[@"image"]]
                        placeholderImage:[UIImage imageNamed:@"beef.jpg"]
                                 options:SDWebImageAllowInvalidSSLCertificates];
    
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark <KRLCollectionViewDelegateGridLayout>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat inset = (section + 1) * 10;
    return UIEdgeInsetsMake(inset, inset, inset, inset);
//    return UIEdgeInsetsMake(0.0f, inset, 0.0f, inset);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section{
    return (section + 1) * 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section{
    return (section + 1) * 10;
}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceLengthForHeaderInSection:(NSInteger)section {
//    return (section + 1) * 20;
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceLengthForFooterInSection:(NSInteger)section {
    return (section + 1) * 30;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout aspectRatioForItemsInSectionAtIndex:(NSInteger)section{
    return 1 + section;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
                                  numberItemsPerLineForSectionAtIndex:(NSInteger)section {
    return 2 + (section * 1);
}


@end
