//
//  ViewController.h
//  GrapesNBerriesTask
//
//  Created by Nada Kamel Abdelhady on 10/25/15.
//  Copyright © 2015 Nada Kamel Abdelhady. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

- (UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size;
- (void) asyncGetJSONdata: (int)count :(int)from;
@end

