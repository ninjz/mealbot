//
//  ViewController.m
//  mealbot
//
//  Created by Amr Adawi on 2015-06-12.
//  Copyright (c) 2015 Mealbot inc. All rights reserved.
//

#import "MBotTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MBotTableViewController ()
@property(nonatomic, strong) NSArray *recipes;
@property(nonatomic, strong) MBotAPIClient *client;

@end


@implementation MBotTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.client = [MBotAPIClient sharedClient];
    
    // testing
    [self.client getRecipesWithIngredients:@[@"eggs",@"potatoes"]
                                   success:^(NSURLSessionDataTask *task, id responseObject){
                                       NSLog(@"Success -- %@", responseObject);
                                       self.recipes = responseObject[@"results"];
                                       [self.tableView reloadData];
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       NSLog(@"Failure -- %@", error);
                                   }];
    
    // set tableviewcell height according to nib
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecipeTableViewCell" owner:self options:nil];
   
    UIView *cellView = (UIView *)nib[0];
    if (cellView) {
        self.tableView.rowHeight = cellView.bounds.size.height;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipeTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecipeTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



# pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RecipeTableViewCell";
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *recipe = self.recipes[indexPath.row];
    
    cell.recipeName.text = recipe[@"name"];
    
    // load image for cell
    [cell.recipeImage sd_setImageWithURL:[NSURL URLWithString:recipe[@"image"]]
                      placeholderImage:[UIImage imageNamed:@"beef.jpg"]
                               options:SDWebImageAllowInvalidSSLCertificates];
    
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath
                                                                                                      *)indexPath
{
//    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beef.jpg"]]; //set image for cell 0
}




@end
