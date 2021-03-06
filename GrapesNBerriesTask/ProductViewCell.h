//
//  ProductViewCell.h
//  GrapesNBerriesTask
//
//  Created by Nada Kamel Abdelhady on 10/25/15.
//  Copyright © 2015 Nada Kamel Abdelhady. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) IBOutlet UIImageView *productImageView;


@end
