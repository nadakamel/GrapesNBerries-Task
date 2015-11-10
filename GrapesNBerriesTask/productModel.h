//
//  productModel.h
//  GrapesNBerriesTask
//
//  Created by Nada Kamel Abdelhady on 11/10/15.
//  Copyright © 2015 Nada Kamel Abdelhady. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface productModel : NSObject

@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)NSString *productDescription;
@property (nonatomic, strong)NSString *imageURL;
@property (nonatomic, strong)NSString *imageWidth, *imageHeight;

-(id)initWithData:(NSDictionary *)data;
@end
