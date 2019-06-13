#ifndef SmartVIGS_CommonType_h
#define SmartVIGS_CommonType_h

// 메인 뷰 얼럿 창 종류
typedef enum enum_MainView_AlertType
{
    Alert_Logout                = 1,
    Alert_InterReg              = 2,
    Alert_ExitApp               = 3,
    Alert_Relogin               = 4,
    Alert_IntrImport            = 5,
    Alert_CallCenter            = 6,
    Alert_Login_Ask   			= 7,
    Alert_ExitAppNoLogout   	= 8,
    Alert_Reconnect             = 99,
    Alert_ChangeIDPW            = 98,
} MainViewAlertType;

typedef enum enum_DeviceModelType
{
    Ipad1                       = 0,
    Ipad2                       = 1,
    Iphone                      = 2,
    Ipod_touch                  = 3,
}DeviceModelType;

// 외부 연동 창 뷰 컨트롤러 보여주는 방식
typedef enum enum_ExternalServiceViewControllerDisplayMethod
{
    DisplayMethod_ModalViewController    = 0,
    DisplayMethod_NavigationController   = 1,
    DisplayMethod_SubView                = 2,
    DisplayMethod_NotShow				 = 3,
} ExternalServiceViewControllerDisplayMethod;

// 외부연동 모드( 뉴스, 이벤트, 스크린샷 )
typedef enum enum_ExternalMode
{
    ExternalMode_News    = 0,
    ExternalMode_Event   = 1,
    ExternalMode_ScrShot = 2,
    Externalmode_LOGIN   = 3,
} enum_ExternalMode;

typedef enum
{
    kCaptionButtonTypeScrHistory = 100,
    kCaptionButtonTypeRefresh    = 101,
    kCaptionButtonTypeFunction   = 102,
} CaptionButtonLinkType;

//current codeType
typedef enum
{
	IS_STOCK_FULL_VIEW=0,	//전체 보이게 처리 (관심종목) 주식+ELW+선물
	IS_STOCK_VIEW,           //주식 화면   only 주식
	//	IS_ETF_VIEW,
	IS_ELW_VIEW,			//ELW 화면    only ELW
	IS_STOCK_ELW_VIEW,		//주식+ELW    주식 +ELW
	IS_FUTURE_OPTION_VIEW,	//선물옵션 화면   선물+옵션
	
} codeTypeSeq;

// 시장 종류
typedef enum enum_MarketType
{
	MarketTypeStock     = 0x01,
	MarketTypeElw       = 0x02,
	MarketTypeFuture    = 0x04,
	MarketTypeOption    = 0x08,
	MarketTypeFO        = 0x12,
} MarketType;

typedef enum enum_SearchViewType
{
	SearchViewTypeStock                         = 0x0100,
	SearchViewTypeElw                           = 0x0200,
	SearchViewUnderlyingAsset                   = 0x0400,
	SearchViewTypeFuture                        = 0x0800,
	SearchViewTypeOption                        = 0x1600,
} SearchViewType;

// 관심 설정 관련
typedef enum enum_InterestPushMoveScreenType
{
	InterestPushMoveScreen_CurrentPrice = 0,
	InterestPushMoveScreen_BuyOrder     = 1,
	InterestPushMoveScreen_SellOrder    = 2,
	InterestPushMoveScreen_Max          = 3,
} InterestPushMoveScreenType;

typedef enum enum_InterestSettingItemOption
{
	settingItem_Market_AlarmColor   = 0,
	settingItem_showSingleLine      = 1,
	settingItem_signIntensity       = 2,
	settingItem_foreignerRatio      = 3,
	settingItem_breakEven           = 4,
	settingItem_earningRate         = 5,
	settingItem_purchaseQuantity    = 6,
	settingItem_averagePrice        = 7,
	settingItem_GroupMove           = 8,
	settingItem_foreignerTrade      = 9,
	settingItem_Max                 = 10,
	
} InterestSettingItemOption;

// 관심 그룹 편집 화면 인덱스
typedef enum enum_InterestEditManagerTabButtonIndex
{
	TabButton_Group     = 0,
	TabButton_Item      = 1,
	TabButton_Setting   = 2,
	TabButton_Alarm     = 3,
	TabButton_Max       = 4,
} InterestEditManagerTabButtonIndex;

// 검색 창 탭 버튼
typedef enum enum_SearchTabButtonIndex
{
	TabButton_Search_Stock      = 0,
	TabButton_Search_ELW_Asset  = 1,
	TabButton_Search_ELW        = 2,
} SearchTabButtonIndex;

// 지수 검색 탭 버튼
typedef enum enum_IndexSearchTabButtonIndex
{
	TabButton_IndexSearch_Kospi     = 0,
	TabButton_IndexSearch_Kosdaq    = 1,
	TabButton_IndexSearch_Futures   = 2,
	TabButton_IndexSearch_Max       = 2, // 선물 버튼 삭제
} IndexSearchTabButtonIndex;


#endif
