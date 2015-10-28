//
//  ViewController.h
//  GrapesNBerriesTask
//
//  Created by Nada Kamel Abdelhady on 10/25/15.
//  Copyright © 2015 Nada Kamel Abdelhady. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSArray *products;
    NSMutableArray *productsImage, *productsDesc, *productsPrice, *productsImageWidth, *productsImageHeight;
    
    }

@property (nonatomic, weak) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;


- (void) getJSONdata: (NSString*)count :(NSString*)from;

- (UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size;


@end

