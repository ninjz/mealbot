//
//  RecipeCollectionViewCell.h
//  mealbot
//
//  Created by caL_ on 2015-06-16.
//  Copyright (c) 2015 Mealbot inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;

@end
