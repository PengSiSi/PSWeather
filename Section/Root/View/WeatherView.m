//
//  WeatherView.m
//  PSWeather
//
//  Created by 思 彭 on 16/11/17.
//  Copyright © 2016年 思 彭. All rights reserved.
//

#import "WeatherView.h"

@implementation WeatherView

- (void)awakeFromNib {

    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setSubViews];
    }
    return self;
}

- (void)_setSubViews {
    
    self.weatherLabel = [[UILabel alloc]init];
    [self addSubview:self.weatherLabel];
    self.weatherImgView = [[UIImageView alloc]init];
    [self addSubview:self.weatherImgView];
    self.firstView = [[WeekWeatherView alloc]init];
    [self addSubview:self.firstView];
    self.twoView = [[WeekWeatherView alloc]init];
    [self addSubview:self.twoView];
    self.threeView = [[WeekWeatherView alloc]init];
    [self addSubview:self.threeView];
    self.contentlabel = [[UILabel alloc]init];
    [self addSubview:self.contentlabel];
    [self _configureSubViews];
    [self _layOut];
}

- (void)_configureSubViews {
    
    self.weatherLabel.font = [UIFont systemFontOfSize:20];
    self.weatherLabel.textColor = [UIColor blackColor];
    self.weatherLabel.text = @"温度";
    self.contentlabel.font = [UIFont systemFontOfSize:17];
    self.contentlabel.textColor = [UIColor grayColor];
    self.contentlabel.numberOfLines = 0;
    self.contentlabel.textAlignment = NSTextAlignmentCenter;
}

- (void)_layOut {
    
    __weak typeof(self) WeakSelf = self;
    
    CGFloat bottomWidth = K_SCREEN_WIDTH / 3;
    [self.weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(WeakSelf.mas_centerX);
        make.top.mas_equalTo(WeakSelf).offset(40);
    }];
    [self.weatherImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(WeakSelf.mas_centerX);
        make.width.height.mas_equalTo(80);
        make.top.mas_equalTo(WeakSelf.weatherLabel.mas_bottom).offset(10);
    }];
    
    [self.contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.weatherImgView.mas_bottom).offset(40);
        make.left.mas_equalTo(WeakSelf);
        make.right.mas_equalTo(WeakSelf);
    }];
    
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.contentlabel.mas_bottom).offset(90);
        make.width.mas_equalTo(bottomWidth);
        make.bottom.mas_equalTo(WeakSelf.mas_bottom);
//        make.height.mas_equalTo(100);
        make.left.mas_equalTo(WeakSelf.mas_left);
    }];
    [self.twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.contentlabel.mas_bottom).offset(90);
        make.width.mas_equalTo(bottomWidth);
//        make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(WeakSelf.mas_bottom);
        make.left.mas_equalTo(WeakSelf.firstView.mas_right);
    }];

    [self.threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.contentlabel.mas_bottom).offset(90);
        make.width.mas_equalTo(bottomWidth);
//        make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(WeakSelf.mas_bottom);
        make.left.mas_equalTo(WeakSelf.twoView.mas_right);
    }];
}

- (void)setModel:(WeatherModel *)model {
    
    _model = model;
    self.weatherLabel.text = model.today.curTemp;
    self.firstView.weekLabel.text = ((TodayModel *)(self.model.forecast[1])).week;
    self.firstView.tempLabel.text = [NSString stringWithFormat:@"%@ ~ %@",((TodayModel *)(self.model.forecast[1])).lowtemp,((TodayModel *)(self.model.forecast[1])).hightemp];
    
    self.twoView.weekLabel.text = ((TodayModel *)(self.model.forecast[2])).week;
    self.twoView.tempLabel.text = [NSString stringWithFormat:@"%@ ~ %@",((TodayModel *)(self.model.forecast[1])).lowtemp,((TodayModel *)(self.model.forecast[1])).hightemp];
    self.threeView.weekLabel.text = ((TodayModel *)(self.model.forecast[3])).week;
    self.threeView.tempLabel.text = [NSString stringWithFormat:@"%@ ~ %@",((TodayModel *)(self.model.forecast[1])).lowtemp,((TodayModel *)(self.model.forecast[1])).hightemp];
    NSDictionary *indexDic = self.model.today.index[0];
    self.contentlabel.text = [NSString stringWithFormat:@"%@ :\n%@",indexDic[@"name"],indexDic[@"details"]];
    
    NSString *type = ((TodayModel *)(self.model.forecast[1])).type;
    NSString *type1 = ((TodayModel *)(self.model.forecast[2])).type;
    NSString *type2 = ((TodayModel *)(self.model.forecast[3])).type;
    self.firstView.weatherImgView.image = [self getWeatherImagePicWithType:type];
    self.twoView.weatherImgView.image = [self getWeatherImagePicWithType:type1];
    self.threeView.weatherImgView.image = [self getWeatherImagePicWithType:type2];
    self.weatherImgView.image = [self getWeatherImagePicWithType:self.model.today.type];
}

- (UIImage *)getWeatherImagePicWithType: (NSString *)type {
    
    if ([type isEqualToString:@"晴"]) {
        return  [UIImage imageNamed:@"sun1"];
    }else if ([type isEqualToString:@"多云"]){
        return  [UIImage imageNamed:@"cloud1"];
    }else if ([type rangeOfString:@"雨"].length > 0){
        if ([type isEqualToString:@"小雨"]) {
            return  [UIImage imageNamed:@"rain1"];
        }else{
            return  [UIImage imageNamed:@"heavyrain1"];
        }
    }else if ([type rangeOfString:@"雪"].length > 0){
        return  [UIImage imageNamed:@"snow1"];
    }
    return  [UIImage imageNamed:@"cloud1"];
}

@end
