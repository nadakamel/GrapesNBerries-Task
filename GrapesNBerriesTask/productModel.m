//
//  productModel.m
//  GrapesNBerriesTask
//
//  Created by Nada Kamel Abdelhady on 11/10/15.
//  Copyright © 2015 Nada Kamel Abdelhady. All rights reserved.
//

#import "productModel.h"

@implementation productModel
-(id)initWithData:(NSDictionary *)data{
    self.price = [data objectForKey:@"price"];
    self.productDescription = [data objectForKey:@"productDescription"];
    self.imageURL = [[data objectForKey:@"image"] objectForKey:@"url"];
    self.imageWidth = [[data objectForKey:@"image"] objectForKey:@"width"];
    self.imageHeight = [[data objectForKey:@"image"] objectForKey:@"height"];
    
    return self;
}
@end
