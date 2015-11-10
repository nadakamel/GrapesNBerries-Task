//
//  ViewController.m
//  GrapesNBerriesTask
//
//  Created by Nada Kamel Abdelhady on 10/25/15.
//  Copyright © 2015 Nada Kamel Abdelhady. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ProductViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "productModel.h"

@interface ViewController ()
{
    CGFloat cellWidth, cellHeight;
    __block NSMutableArray *products;
    int count, from;
}
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"Products"];
    products = [NSMutableArray new];
    [self asyncGetJSONdata:10 :1];
    [self.activityIndicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Get data asyncronus
- (void) asyncGetJSONdata: (int)count :(int)from {
    // 1
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://grapesnberries.getsandbox.com/products?count=%i&from=%i", count, from]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        for (NSDictionary *dic in responseObject) {
            productModel *model = [[productModel alloc]initWithData:dic];
            [products addObject:model];
        }
        [self.myCollectionView reloadData];
        [self.activityIndicator stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    // 4
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                        message:[error localizedDescription]
                                                        delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
}

// Resize image to UIImageView boundaries
- (UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma UICollectionView Header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        HeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        header.headerLabel.text = @"Products";
        
        return header;
    }
    return nil;
}

#pragma UICollectionView
// Returns number of sections
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// Returns number of items in each section
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)products.count);
    return products.count;
}

// Content of each cell
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductViewCell *productCell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"cell_ID" forIndexPath:indexPath];
    
    productModel *model = [products objectAtIndex:indexPath.row];
    
    // Set image of each product cell
    NSString *imagePath = model.imageURL;
    NSURL *imageURL = [NSURL URLWithString:imagePath];
    CGFloat imageWidth = [model.imageWidth floatValue];
    CGFloat imageHeight = [model.imageHeight floatValue];

    CGRect rect;
    rect.size.width = imageWidth;
    rect.size.height = imageHeight;
    productCell.productImageView.frame = rect;
    [productCell.productImageView setImageWithURL:imageURL];
    
    // Set price of each product cell
    NSString *price = model.price;
    productCell.priceLabel.text = [[NSString alloc] initWithFormat:@"$ %@", price];
    
    // Set description of each product cell
    NSString *desc = model.productDescription;
    CGSize boundingSize = CGSizeMake(290, NSIntegerMax);
    CGSize descSize = [desc boundingRectWithSize:boundingSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
                                  context:nil].size;
    CGRect labelrect = productCell.descLabel.frame;
    labelrect.size.height = descSize.height;
    labelrect.size.width = imageWidth;
    productCell.descLabel.frame = labelrect;
    productCell.descLabel.text = desc;
    productCell.descLabel.numberOfLines = 0;
    

    return productCell;
}

// Adjusts size (width, height) of each cell
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    productModel *model = [products objectAtIndex:indexPath.row];
    
    // Width and Height of image of each product cell
    CGFloat imageWidth = [model.imageWidth floatValue];
    CGFloat imageHeight = [model.imageHeight floatValue];
    CGRect rect;
    rect.size.width = imageWidth;
    rect.size.height = imageHeight;
    
    // Height of label
    CGFloat priceLabelHeight = 21;
    
    // Set description of each product cell
    NSString *desc = model.productDescription;
    CGSize boundingSize = CGSizeMake(290, NSIntegerMax);
    CGSize descSize = [desc boundingRectWithSize:boundingSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
                                         context:nil].size;
    
    cellWidth = imageWidth;
    cellHeight =  priceLabelHeight + imageHeight + descSize.height;
    
    return CGSizeMake(cellWidth, cellHeight);
}

// Adjusts span between each cell
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 17, 15, 17);
}

@end














