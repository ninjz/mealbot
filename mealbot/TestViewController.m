//
//  ViewController.m
//  mealbot
//
//  Created by Amr Adawi on 2015-06-12.
//  Copyright (c) 2015 Mealbot inc. All rights reserved.
//

#import "TestViewController.h"


@interface TestViewController ()
@property(nonatomic, strong) NSArray *recipes;

@end

const unsigned char SpeechKitApplicationKey[] = {0x45, 0x49, 0xd6, 0xb3, 0xe4, 0xeb, 0xe3, 0xb0, 0x93, 0x75, 0x14, 0x1e, 0xab, 0x8c, 0x95, 0xa7, 0x6f, 0xb6, 0x33, 0x3c, 0xed, 0xae, 0x09, 0x5f, 0xb0, 0xd7, 0x04, 0xb4, 0xee, 0xdc, 0xad, 0x33, 0x25, 0x84, 0xe7, 0x09, 0x6f, 0xca, 0xba, 0x02, 0x3f, 0xce, 0x21, 0xeb, 0x5a, 0xb6, 0x92, 0xc9, 0x6d, 0xc5, 0x05, 0x5a, 0x73, 0x0f, 0xba, 0x23, 0xe6, 0xbe, 0xd7, 0xd4, 0x9a, 0x84, 0x08, 0xc0};

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageLabel.text = @"Tap on the mic";
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.appDelegate setupSpeechKitConnection];
    // Do any additional setup after loading the view, typically from a nib.
    self.client = [MBotAPIClient sharedClient];
    
    // testing
//    [self.client getRecipesWithIngredients:@[@"cheese",@"lobster"]
//                                   success:^(NSURLSessionDataTask *task, id responseObject){
//                                       NSLog(@"Success -- %@", responseObject);
//                                       self.recipes = responseObject[@"results"];
//                                       [self.resultTableView reloadData];
//                                   }
//                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                       NSLog(@"Failure -- %@", error);
//                                   }];
//    
    
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    [self.resultTableView registerNib:[UINib nibWithNibName:@"RecipeTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecipeTableViewCell"];
    [self createRecordControllerButton];
    [self createTransition];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordButtonTapped:(id)sender {
    self.recordButton.selected = !self.recordButton.isSelected;
    
    // This will initialize a new speech recognizer instance
    if (self.recordButton.isSelected) {
        self.voiceSearch = [[SKRecognizer alloc] initWithType:SKSearchRecognizerType
                                                    detection:SKShortEndOfSpeechDetection
                                                     language:@"en_US"
                                                     delegate:self];
    }
    
    // This will stop existing speech recognizer processes
    else {
        if (self.voiceSearch) {
            [self.voiceSearch stopRecording];
            [self.voiceSearch cancel];
        }
    }
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


# pragma mark - SKRecognizer Delegate Methods

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer {
    self.messageLabel.text = @"Listening..";
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer {
    self.messageLabel.text = @"Done Listening..";
}
- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results {
    long numOfResults = [results.results count];
    
    if (numOfResults > 0) {
        // update the text of text field with best result from SpeechKit
        self.searchTextField.text = [results firstResult];
        
        NSArray *ingredients = [[results firstResult] componentsSeparatedByString:@" "];
        
        [self.client getRecipesWithIngredients:ingredients
                                       success:^(NSURLSessionDataTask *task, id responseObject){
                                           NSLog(@"Success -- %@", responseObject);
                                           self.recipes = responseObject[@"results"];
                                           [self.resultTableView reloadData];
                                       }
                                       failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           NSLog(@"Failure -- %@", error);
                                       }];
        
    }
    
    self.recordButton.selected = !self.recordButton.isSelected;
    
    if (self.voiceSearch) {
        [self.voiceSearch cancel];
    }
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion {
    self.recordButton.selected = NO;
    self.messageLabel.text = @"Connection error";
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)vocalizer:(SKVocalizer *)vocalizer willBeginSpeakingString:(NSString *)text {
    self.isSpeaking = YES;
}

- (void)vocalizer:(SKVocalizer *)vocalizer didFinishSpeakingString:(NSString *)text withError:(NSError *)error {
    if (error !=nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        if (self.isSpeaking) {
            [self.vocalizer cancel];
        }
    }
    
    self.isSpeaking = NO;
}


#pragma mark - JTMaterialTransition
-(void) didPresentControllerButtonTouch
{
    UIViewController * controller = [[ListeningViewController alloc ]initWithVoiceSearch:self.voiceSearch];
    //indicating that we are using a custom UI
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = self;
    self.voiceSearch = [[SKRecognizer alloc] initWithType:SKSearchRecognizerType
                                                detection:SKShortEndOfSpeechDetection
                                                 language:@"en_US"
                                                 delegate:self];
    [self presentViewController:controller animated:YES completion:nil];
}


-(void) createRecordControllerButton
{
    CGFloat y = 300;
    CGFloat width = 50;
    CGFloat height = width;
    CGFloat x = (CGRectGetWidth(self.view.frame) - width)/2.;
    
    self.presentControllerButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    self.presentControllerButton.layer.cornerRadius = width/2;
    self.presentControllerButton.backgroundColor = [UIColor colorWithRed:188./256. green:39./256. blue:39./256. alpha:1.];
    //[self.recordControllerButton setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    [self.presentControllerButton addTarget:self action:@selector(didPresentControllerButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.presentControllerButton];
}
-(void) createTransition
{
    self.transition = [[JTMaterialTransition alloc] initWithAnimatedView:self.presentControllerButton];
    
}
// Indicate which transition to use when you this controller present a controller
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.transition.reverse = NO;
    return self.transition;
}
// Indicate which transition to use when the presented controller is dismissed
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transition.reverse = YES;
    return self.transition;
}


@end
