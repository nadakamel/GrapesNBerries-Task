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

#define CELL_IDENTIFIER @"cell_ID"
#define HEADER_IDENTIFIER @"HeaderView"

@interface ViewController ()
{
    int productsFrom, productsCount;
    CGFloat cellWidth, cellHeight;
    __block NSMutableArray *products;
}
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    products = [NSMutableArray new];
    productsFrom = 1, productsCount = 10;
    [self asyncGetJSONdata];
    [self.activityIndicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) asyncGetJSONdata {
    // 1
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://grapesnberries.getsandbox.com/products?count=%i&from=%i", productsCount, productsFrom]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        for(int i = 0; i < productsCount; i++)
        {
            NSDictionary *dic = [responseObject objectAtIndex:i];
            productModel *model = [[productModel alloc]initWithData:dic];
            [products addObject:model];
        }
        
//        for (NSDictionary *dic in responseObject) {
//            productModel *model = [[productModel alloc]initWithData:dic];
//            [products addObject:model];
//        }
        [self.myCollectionView reloadData];
        [self.activityIndicator stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    // 4
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Products Data"
                                                        message:[error localizedDescription]
                                                        delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
}

#pragma UICollectionView Header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        HeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_IDENTIFIER forIndexPath:indexPath];
        
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

// Dynamic loading of data.
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [products count] - 1 ) {
        productsFrom+=10;
        [self asyncGetJSONdata];
    }
}

// Content of each cell
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductViewCell *productCell = [collectionView  dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
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














