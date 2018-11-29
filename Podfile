source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

inhibit_all_warnings!   #忽略所有警告

abstract_target 'CommaUser_targets' do
    # 自动布局
    pod 'SnapKit'
    # HTTP
    pod 'Alamofire'
    # 状态栏活动指示器
    pod 'AlamofireNetworkActivityIndicator'
    # 响应式编程
    pod 'RxSwift'
    pod 'RxCocoa'
    # 网络图片处理
    pod 'SDWebImage'
    # 自适应键盘高度
    pod 'IQKeyboardManagerSwift'
    # 唯一标识符
    pod 'FCUUID'
    # 刷新
    pod 'MJRefresh'
    # 富文本
    pod 'TextAttributes' , :git => 'https://github.com/ejmartin504/TextAttributes.git', :branch => 'swift4'
    #pod 'TextAttributes'
    # 自带占位的文本视图
    pod 'UITextView+Placeholder'
    # 随机数
    pod 'SwiftRandom'
    # 加密
    pod 'CryptoSwift'
    #  高德地图 - 2D地图SDK(2D地图和3D地图不能同时使用)
    pod 'AMap2DMap'
    # 高德地图 - 定位SDK
    pod 'AMapLocation'
    #  高德地图 - 搜索服务SDK
    pod 'AMapSearch'
    # 图片轮播器
    pod 'SDCycleScrollView'
    # Web视图进度条
    pod 'NJKWebViewProgress'
    # 红点
    pod 'WZLBadge'
    # 拾取器
    pod 'ActionSheetPicker-3.0'
    # 数据分析
    pod 'Fabric'
    # 崩溃分析
    pod 'Crashlytics'
    # 活动指示器
    pod 'MBProgressHUD'
    # 图表
    pod 'Charts'
    # 设备型号
    pod 'UIDeviceIdentifier', :git => 'https://github.com/squarefrog/UIDeviceIdentifier.git'
    # 网络状态
    pod 'ReachabilitySwift', '~> 4.1.0'
    # 导航栏
    pod 'KMNavigationBarTransition'
    # reveal
    pod 'Reveal-SDK', '~> 4', :configurations => ['Debug']
    # 微信
    pod 'WechatOpenSDK'
    # 阿里云
    pod 'AliyunOSSiOS'
    # Airbnb动画
    pod 'lottie-ios'
   #听云SDK
   pod 'tingyunApp'

  #WoodPeckeriOS
#   pod 'WoodPeckeriOS', :configurations => ['Debug']

    target 'CommaUser' do
    end
    target 'CommaUserDev' do
    end
    target 'CommaUserAlpha' do
    end
    target 'CommaUserBeta' do
    end
    project 'CommaUser.xcodeproj'

end


#post_install do |installer|
#    installer.pods_project.targets.each do |target|
#        target.build_configurations.each do |config|
#            config.build_settings['ENABLE_BITCODE'] = 'NO'
#            #            config.build_settings['ARCHS'] = "arm64 armv7 armv7s"
#        end
#        if target == "Mantle"
#
#        end
#    end
#end

