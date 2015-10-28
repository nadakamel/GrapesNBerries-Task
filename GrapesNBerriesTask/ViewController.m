//
//  ViewController.m
//  GrapesNBerriesTask
//
//  Created by Nada Kamel Abdelhady on 10/25/15.
//  Copyright © 2015 Nada Kamel Abdelhady. All rights reserved.
//

#import "ViewController.h"
#import "ProductViewCell.h"
#import "HeaderCollectionReusableView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"Products"];
    productsImage = [[NSMutableArray alloc] init];
    productsImageWidth = [[NSMutableArray alloc] init];
    productsImageHeight = [[NSMutableArray alloc] init];
    productsPrice = [[NSMutableArray alloc] init];
    productsDesc = [[NSMutableArray alloc] init];
    [self getJSONdata:@"10" :@"1"];
    
    [self.activityIndicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// For fetching and parsing JSON data
- (void) getJSONdata: (NSString*)count :(NSString*)from {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://grapesnberries.getsandbox.com/products?count=%@&from=%@", count, from]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             products = [NSJSONSerialization JSONObjectWithData:data
                                                        options:0
                                                          error:NULL];
             
             NSLog(@"%@", products);
            
             for (int i = 0; i < products.count; i++)
             {
                 [productsImage addObject: [[[products objectAtIndex:i] objectForKey:@"image"] objectForKey:@"url"]];
                 [productsImageWidth addObject: [[[products objectAtIndex:i] objectForKey:@"image"] objectForKey:@"width"]];
                 [productsImageHeight addObject: [[[products objectAtIndex:i] objectForKey:@"image"] objectForKey:@"height"]];
                 [productsPrice addObject: [[products objectAtIndex:i] objectForKey:@"price"]];
                 [productsDesc addObject: [[products objectAtIndex:i] objectForKey:@"productDescription"]];
             }
             
             [self.myCollectionView reloadData];
             [self.activityIndicator stopAnimating];
         }
     }];
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
    
    ProductViewCell *productCell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"cell_ID"
                                                                              forIndexPath:indexPath];
    
    // Set image of each product cell
    NSString *imagePath = [productsImage objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:imagePath];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData: imageData];
    CGFloat imageWidth = [[productsImageWidth objectAtIndex:indexPath.row] floatValue];
    CGFloat imageHeight = [[productsImageHeight objectAtIndex:indexPath.row] floatValue];
    CGSize imageSize = CGSizeMake(imageWidth, imageHeight);
    UIImage *resizedImage= [self resizeImage:image imageSize:imageSize];
    productCell.productImageView.image = resizedImage;
    
    // Set price of each product cell
    NSString *price = [[productsPrice objectAtIndex:indexPath.row] stringValue];
    productCell.priceLabel.text = [[NSString alloc] initWithFormat:@"$ %@", price];
    
    // Set description of each product cell
    NSString *desc = [productsDesc objectAtIndex:indexPath.row];
    productCell.descTextView.text = desc;
    
    return productCell;
}

// Adjusts size (width, height) of each cell
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(170, 358);
}

// Adjusts span between each cell
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 10, 1, 10);
}

@end














