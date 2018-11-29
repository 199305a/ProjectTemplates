//
//  LSDeviceMeasureData.h
//  LSDeviceBluetooth-Library
//
//  Created by caichixiang on 2017/3/6.
//  Copyright © 2017年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBluetoothManagerProfiles.h"
#import "LSDBaseModel.h"

@interface LSDeviceMeasureData : NSObject

@property(nonatomic,strong)NSData  *sourceData;         //设备上传的源始数据
@property(nonatomic,strong)NSString *deviceId;          //设备ID
@property(nonatomic,strong)NSString *broadcastId;       //设备广播ID
@property(nonatomic,strong)NSString *measureTime;       //测量时间
@property(nonatomic,strong)NSString *measureUnits;      //测量单位
@property(nonatomic,assign)NSInteger battery;           //设备电量等级
@property(nonatomic,assign)long long utc;               //测量时间对应的UTC值
@property(nonatomic,assign)LSProtocolVer protocolVer;   //数据的协议版本
@property (nonatomic,assign) int batteryPercent;        //电量百分比,Add in version 1.0.2



/**
 * 将Dictionary数据对象转成相应的属性
 */
-(void)parse:(NSDictionary *)dict;

/**
 * 将对象属性转换成string 类型
 */
-(NSString *)toString;

@end


#pragma mark - LSSphygmometerData 血压计测量数据

@interface LSSphygmometerData : LSDeviceMeasureData

@property(nonatomic)NSUInteger userNumber;           //用户编号
@property(nonatomic)double systolic;                 //收缩压
@property(nonatomic)double diastolic;                //舒张压
@property(nonatomic)double pluseRate;                //心率
@property(nonatomic)BOOL isIrregularPulse;           //是否心率不齐
@end

#pragma mark - LSWeightAppendData 脂肪测量数据

@interface LSWeightAppendData : LSDeviceMeasureData

@property(nonatomic, assign) NSUInteger userNumber;      //用户编号
@property(nonatomic, assign) double basalMetabolism;     //基础代谢值
@property(nonatomic, assign) double bodyFatRatio;        //脂肪率
@property(nonatomic, assign) double bodywaterRatio;      //水分含量
@property(nonatomic, assign) double visceralFat;         //内脏脂肪水平
@property(nonatomic, assign) double muscleMassRatio;     //肌肉含量
@property(nonatomic, assign) double boneDensity;         //骨质密度
@property(nonatomic, assign) double voltageData;        //电压值
@property(nonatomic, assign) double imp;                //电阻值转换后的阻抗
@property(nonatomic, assign) double protein;            //蛋白质含量
@property(nonatomic, assign) double bmi;                //bmi指数

@end

#pragma mark - LSWeightData 体重测量数据

@interface LSWeightData : LSDeviceMeasureData

@property(nonatomic)NSUInteger userNumber;              //用户编号
@property(nonatomic)double weight;                      //体重数据，计算单位kg
@property(nonatomic)double resistance_1;                //测量阻抗1，电阻值，用于计算相应的脂肪数据
@property(nonatomic)double resistance_2;                //测量阻抗2，电阻值，用于计算相应的脂肪数据
@property(nonatomic)int hasAppendMeasurement;           //是否有附加的脂肪测量数据包
@property(nonatomic)double lbWeightValue;               //体重数据，计算单位LB
@property(nonatomic)double stWeightValue;               //体重数据，计算单位St,后面数据
@property(nonatomic)NSUInteger stSectionValue;          //体重数据，计算单位St,前面数据
@property(nonatomic, assign) double voltageValue;       //电压值
@property(nonatomic)LSMeasurementUnit unit;             //测量单位
@end

#pragma mark - LSHeightData 身高测量数据

@interface LSHeightData : LSDeviceMeasureData

@property(nonatomic)NSUInteger userNumber;              //用户编号
@property(nonatomic)double height;                      //身高值
@end


#pragma mark - LSKitchenScaleData 厨房秤测量数据

@interface LSKitchenScaleData : LSDeviceMeasureData

@property(nonatomic)double weight;                     //物体重量
@property(nonatomic)NSInteger sectionWeight;           //
@property(nonatomic)NSInteger time;
@end

#pragma mark - LSPedometerData 手环步数测量数据

@interface LSPedometerData : LSDeviceMeasureData

@property(nonatomic,assign)NSUInteger userNumber;              //用户编号
@property(nonatomic,assign)NSInteger walkSteps;                //步行数据
@property(nonatomic,assign)NSInteger runSteps;                 //跑步数据
@property(nonatomic,assign)double examount;                    //运动量
@property(nonatomic,assign)double calories;                    //卡路里
@property(nonatomic,assign)NSInteger exerciseTime;             //运动时间
@property(nonatomic,assign)NSInteger distance;                 //距离
@property(nonatomic,assign)NSInteger sleepStatus;              //睡眠等级
@property(nonatomic,assign)NSInteger intensityLevel;           //抖动等级
@property(nonatomic,assign)double voltage;                     //电压值
@property (nonatomic, assign)NSInteger sportLevel;             //运动等级


@end


/********************************************************************
 * 手环测量数据对象
 ********************************************************************/


#pragma mark - LSUBaseModel 设备数据的基类

@interface LSUBaseModel : LSDeviceMeasureData

@end

#pragma mark - LSUBloodOxygen 血氧测量数据

@interface LSUBloodOxygen : LSUBaseModel

//@property (nonatomic, assign) long long utc;
@property (nonatomic, assign) int restCount;
@property (nonatomic, assign) int collectTime;
@property (nonatomic, readonly) NSArray<NSNumber *> *spo2hList;
@end

#pragma mark - LSUCaloriesData 卡路里测量数据

@interface LSUCaloriesData : LSUBaseModel

//@property (nonatomic, assign) long long utc;
@property (nonatomic, assign) int restCount;
@property (nonatomic, assign) int collectTime;
@property (nonatomic, readonly) NSArray<NSNumber *> *calorieList;
@property (nonatomic, readonly) NSData *srcData;

#pragma mark - Added in version 1.1.8
@property (nonatomic, assign) LSSportCaloriesDataType type;
@property (nonatomic, assign) LSDeviceSportMode sportMode;
@property (nonatomic, assign) LSDeviceSportSubMode subMode;

@end

#pragma mark - LSUDeviceInfo 设备信息

@interface LSUDeviceInfo : LSUBaseModel

@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *softVer;
@property (nonatomic, copy) NSString *hardVer;
@property (nonatomic, assign) BOOL isOpenHR;
@property (nonatomic, assign)  int startHour;
@property (nonatomic, assign)  int startMinute;
@property (nonatomic, assign)  int endHour;
@property (nonatomic, assign)  int endMinute;
@property (nonatomic, copy)  NSString *timeZone;
@end


#pragma mark - LSFlashInfo 设备flash数据

@interface LSFlashInfo : NSObject

@property (nonatomic, assign) int flashType;
@property (nonatomic, assign) int beginAddr;
@property (nonatomic, assign) int endAddr;
@property (nonatomic, copy) NSString *flashContent;
@end

#pragma mark - LSUGetDeviceInfo 设备设置信息数据

@interface LSUGetDeviceInfo : LSUBaseModel

@property (nonatomic, assign) BOOL isOpenPreventLost;
@property (nonatomic, strong) LSFlashInfo *flashInfo;
@property (nonatomic, strong) LSDAlarmClock *alarmClock;
@property (nonatomic, strong) LSDWeekTarget *weekTarget;
@property (nonatomic, strong) LSDMessageReminder *callReminder;
@property (nonatomic, strong) LSDHeartRate *heartRate;
@property (nonatomic, strong) LSDSedentary *sedentary;
@property (nonatomic, assign) LSGetDeviceInfoType type;//读取信息的类型
@end


#pragma mark - LSUHearRate 设备心率测量数据

@interface LSUHearRate : LSUBaseModel

//@property (nonatomic, assign) long long utc;
@property (nonatomic, assign) int restCount;
@property (nonatomic, assign) int collectTime;
@property (nonatomic, readonly) NSArray<NSNumber *> *heartRateList;
@property (nonatomic, readonly) NSData *srcData;
@end


#pragma mark - LSUHRSection 设备心率区间测量数据

@interface LSUHRSection : LSUBaseModel

//@property (nonatomic, assign) long long utc;
/**
 * 心率区间I 累计时间，单位：2秒
 * 每个单位值代表2s，如：30表示心率区间I累计时间是60s
 */
@property (nonatomic, assign) NSUInteger hrSectionTime1;

/**
 * 心率区间II 累计时间，单位：2秒
 * 每个单位值代表2s，如：30表示心率区间I累计时间是60s
 */
@property (nonatomic, assign) NSUInteger hrSectionTime2;

/**
 * 心率区间III 累计时间，单位：2秒
 * 每个单位值代表2s，如：30表示心率区间I累计时间是60s
 */
@property (nonatomic, assign) NSUInteger hrSectionTime3;
@end

#pragma mark - LSUMeasureData A5手环步数测量数据

@interface LSUMeasureData : LSUBaseModel

@property (nonatomic, assign)  int step;
@property (nonatomic, assign)  double examount;
@property (nonatomic, assign)  double calories;
@property (nonatomic, assign)  int exerciseTime;
@property (nonatomic, assign)  int distance;
@property (nonatomic, assign)  int batteryLevel;
@property (nonatomic, assign)  int sportLevel;
@property (nonatomic, assign)  double batteryVoltage;
@end

#pragma mark - LSUSleepData A5手环睡眠测量数据

@interface LSUSleepData : LSUBaseModel

//A2 或微信手环的睡眠数据
@property (nonatomic, retain) NSNumber * sleepLevel;
//A5 手环的睡眠数据
@property (nonatomic, assign) int restCount;
@property (nonatomic, assign) int collectTime;
@property (nonatomic, readonly) NSArray<NSNumber *> *statusList;
@property (nonatomic, readonly) NSData *srcData;
@end

#pragma mark - LSStepFreqInfo 手环步频数据

@interface LSStepFreqInfo : NSObject

@property (nonatomic, assign) long long utc;
@property (nonatomic, assign) LSStepFreqStatus status;
@end


#pragma mark - LSUSportData 手环运动数据

@interface LSUSportData : LSUBaseModel

@property (nonatomic, assign) LSDeviceSportMode sportMode;
@property (nonatomic, assign) LSDeviceSportSubMode sportSubMode;
@property (nonatomic, assign)  int time;
@property (nonatomic, assign)  int step;
@property (nonatomic, assign)  double calories;
@property (nonatomic, assign)  int maxHR;
@property (nonatomic, assign)  int avgHR;
@property (nonatomic, assign)  int maxStepFreq;
@property (nonatomic, assign)  int avgStepFreq;
@property (nonatomic, readonly)  NSArray<LSStepFreqInfo *> *stepFreqList;

//new
@property (nonatomic ,assign)  NSInteger flags;                  //预留字段flags启用
@property (nonatomic, assign)  float maxSpeed;                   //运动最大速度
@property (nonatomic, assign)  float avgSpeed;                   //运动平均速度
@property (nonatomic, assign)  NSUInteger distance;              //运动距离

@end

#pragma mark - LSUSportHeartRate 手环运动心率数据

@interface LSUSportHeartRate : LSUHearRate
@property (nonatomic, assign) LSSportHartDataType type;
@property (nonatomic, assign) LSDeviceSportMode sportMode;
@property (nonatomic, assign) LSDeviceSportSubMode subMode;
@end

#pragma mark - LSUSwimData 游泳测量数据

@interface LSUSwimData : LSUBaseModel

@property (nonatomic, assign) long long startUTC;
@property (nonatomic, assign) long long endUTC;
@property (nonatomic, assign) int laps;
@end

#pragma mark - LSUVoltageModel 设备电压数据

@interface LSUVoltageModel : LSUBaseModel

@property (nonatomic,assign)int flag;
@property (nonatomic,copy) NSString *macAddress;        // MAC地址
@property (nonatomic,assign) BOOL isCharging;           //是否在充電
@property (nonatomic,assign) float voltage;             //電壓，單位：V（伏）
@end

#pragma mark - LSUSportState 运动状态数据

@interface LSUSportState : LSUBaseModel

@property (nonatomic,assign) LSFunctionTestType functionTest;//功能检测
@property (nonatomic,assign) int state;                      //开关状态
@end

#pragma mark - LSUTestDataModel 测试数据

// 用于调试设备采集数据，无太多作用
@interface LSUTestDataModel : LSUBaseModel

@property(nonatomic, strong) NSData* uploadData;
@end

//Added in version 1.0.6 build-1
#pragma mark - LSScaleMeasureData

@interface LSScaleMeasureData:LSUBaseModel

@property (nonatomic, assign) NSUInteger restCount;         //传输完本数据包后设备中的剩余数据条目
@property (nonatomic, assign) LSMeasurementUnit unit;       //单位
@property (nonatomic, assign) LSMeasureDataType type;       //数据包中包含有哪些数据
@property (nonatomic, assign) float weight;                 //体重，单位为0.010kg,可自行根据unit单位来转换
@property (nonatomic, assign) NSUInteger userNumber;        //UserNumber
@property (nonatomic, assign) NSUInteger timeZone;          //timezone
@property (nonatomic, assign) NSDate *date;                 //date
@property (nonatomic, assign) float bmi;                    //bmi,单位:0.1
@property (nonatomic, assign) float bfp;                    //bfp,单位:0.1
@property (nonatomic, assign) NSUInteger bm;                //bm
@property (nonatomic, assign) float mp;                     //mp,单位:0.1
@property (nonatomic, assign) float mm;                     //mm,单位:0.010kg
@property (nonatomic, assign) float ffm;                    //ffm,单位:0.010kg
@property (nonatomic, assign) float slm;                    //slm,单位:0.010kg
@property (nonatomic, assign) float bwm;                    //bwm,单位:0.010kg
@property (nonatomic, assign) float imp;                    //imp,单位:Ω
@end

#pragma mark - LSScaleUserData

@interface LSScaleUserData : LSUBaseModel

@property (nonatomic ,assign) NSUInteger userNumber;    //用户编号
@property (nonatomic ,assign) LSUserGender gender;      //用户性别
@property (nonatomic ,assign) NSUInteger age;           //年龄
@property (nonatomic ,assign) NSUInteger height;        //身高 ，单位cm(0.01m)
@property (nonatomic ,assign) double weight;            //体重
@property (nonatomic ,assign) BOOL isAthlete;           //是否是运动员
@property (nonatomic ,assign) NSUInteger athleteLevel;  //运动等级
@end

#pragma mark - Added in version 1.1.3 LSHeartbeatData

@interface LSHeartbeatData :NSObject
@property(nonatomic ,assign)NSUInteger timeOffset;      //心跳数据的时间偏移量
@property(nonatomic ,assign)NSUInteger value;           //心跳数据值
@end

@interface LSDeviceHeartbeatData :LSUBaseModel
@property(nonatomic ,assign)NSUInteger flag;                //数据包flag位
@property(nonatomic ,assign)NSUInteger unsentDataCount;     //未发送的数据条数
@property(nonatomic ,assign)NSUInteger currentSendDataCount;//当前发送的数据条数
@property(nonatomic ,strong)NSArray<LSHeartbeatData *> * heartbeatDatas;//心跳数据集合
@end

#pragma mark - Added in version 1.1.4 LSBloodGlucoseData 血糖仪测量数据

@interface LSBloodGlucoseData:LSUBaseModel
@property(nonatomic,assign)NSUInteger flag;             //数据包标志位
@property(nonatomic,assign)float concentration;         //浓度值
@property(nonatomic,assign)NSUInteger dataNumebr;       //数据序号
@end

#pragma mark - Added in version 1.1.8 - LSUWalkingData 健走运动数据

@interface LSUWalkingData : LSUSportData
@property (nonatomic,assign) LSWalkingSubModeType walkingSubMode;  //运动子模式
@end

#pragma mark - Added in version 1.1.8 - LSURunningData 跑步运动数据

@interface LSURunningData : LSUSportData
@property (nonatomic, assign) LSRunningSubModeType runningSubMode; //运动子模式
@end


#pragma mark - Added in version 1.1.8 - LSURideData 骑行运动数据

@interface LSURideData : LSUSportData
//运动子模式
@property (nonatomic,assign) LSSportBallSubModeType sportSubMode;
@end

#pragma mark - Added in version 1.2.1 - LSRemoteControlInfo 远程控制操作信息

@interface LSRemoteControlInfo : LSUBaseModel

@property(nonatomic,assign)LSRemoteControlCmd controlCmd;  //远程操作指令类型

@end

