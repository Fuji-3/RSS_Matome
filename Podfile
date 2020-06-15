# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'RSS_Matome' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RSS_Matome
	#通信
	pod 'Alamofire'
	#Decoder
	pod 'SWXMLHash'
	#画像取得
	pod 'AlamofireImage'
	pod 'SDWebImage'
	
	#DB
	pod 'RealmSwift'
	#Linter
	pod 'SwiftLint'
	#Logger
  pod 'SwiftyBeaver'
  #ライセンス
  pod 'LicensePlist'
  #htmlReader
  pod 'HTMLReader'
  
  pod 'PageMenuKitSwift'
	#アニメーション系
  #アニメ
	pod 'Hero'
  #初期画面 or NotDataView
	pod 'SkeletonView'
  #スクロール中にナビゲーションを消す
	pod 'AMScrollingNavbar'
  #下から出てくるメニュー
	pod 'PanModal'
  #SegmentView
	pod 'XLPagerTabStrip'
  #アラート/トーストを表示をする
	pod 'SwiftMessages'
  #Progress
  pod 'PKHUD','~> 5.0'
  
	pod 'OpenGraph','~> 1.0.3'
	
	swift4_names = [
		'Alamofire','SWXMLHash','AlamofireImage','RealmSwift','SwiftLint','SwiftyBeaver', 'LicensePlist','SDWebImage','HTMLReader',
		 'RMPScrollingMenuBarController','Hero','AMScrollingNavbar','PanModal','XLPagerTabStrip','SwiftMessages', 'OpenGraph','PKHUD','PageMenuKitSwift'

	]
	post_install do |installer|
  		installer.pods_project.targets.each do |target|
    			target.build_configurations.each do |config|
      				config.build_settings['SWIFT_VERSION'] = '4.2'
    				end
  			end
		end



  target 'RSS_MatomeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RSS_MatomeUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
