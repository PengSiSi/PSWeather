//
//  WeekWeatherView.m
//  PSWeather
//
//  Created by 思 彭 on 16/11/18.
//  Copyright © 2016年 思 彭. All rights reserved.
//

#import "WeekWeatherView.h"

@implementation WeekWeatherView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        [self _setSubViews];
    }
    return self;
}

- (void)_setSubViews {
   
    self.weekLabel = [[UILabel alloc]init];
    [self addSubview:self.weekLabel];
    self.weatherImgView = [[UIImageView alloc]init];
    [self addSubview:self.weatherImgView];
    self.tempLabel = [[UILabel alloc]init];
    [self addSubview:self.tempLabel];
    [self configureSubViews];
    [self layOut];
}

- (void)configureSubViews {
    
    self.weekLabel.font = [UIFont systemFontOfSize:17];
    self.weekLabel.textColor = [UIColor blackColor];
    self.weekLabel.text = @"星期";
    self.tempLabel.font = [UIFont systemFontOfSize:17];
    self.tempLabel.textColor = [UIColor blackColor];
    self.tempLabel.text = @"温度";

}

- (void)layOut {
    
    __weak typeof(self) WeakSelf = self;
    
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(WeakSelf);
        make.top.mas_equalTo(WeakSelf).offset(10);
    }];
    [self.weatherImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(WeakSelf);
        make.top.mas_equalTo(WeakSelf.weekLabel.mas_bottom).offset(10);
        make.width.height.mas_equalTo(50);
    }];
    [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(WeakSelf);
        make.top.mas_equalTo(WeakSelf.weatherImgView.mas_bottom).offset(10);
    }];
}

@end
