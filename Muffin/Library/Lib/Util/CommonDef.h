
#ifndef __COMMONDEF_H__
#define __COMMONDEF_H__

// Session Type Info -by Berdo 2015-11-11
#define SESSION_TCP			0
#define	SESSION_HTTP 		1
#define SESSION_UDP			2
#define SESSION_WEBSOCKET	3

#define SESSION_TCP_STR			@"TCP"
#define SESSION_HTTP_STR		@"HTTP"
#define SESSION_UDP_STR			@"UDP"
#define SESSION_WEBSOCKET_STR	@"WEBSOCKET"

// Connection Info File -by Berdo 2015-11-11
#define CONNECTION_LISTINFO_FILE		@"connectinfo.dat"
#define LAST_CONNECTINFO_FILEPATH       @"lastconinfo.dat"
#define TEST_FORMDE_FILEPATH            @"TestConfig.ini"

// Connect Session Key Define(ITGen Define/Don't Delete) -by Berdo 2015-11-11
#define ITGLAB_MCA						@"SSN_ITGMCA"
#define ITGLAB_FOMSVR					@"SSN_ITGTEST"
#define ITGLAB_VERSVR					@"SSN_ITGVER"
#define ITGLAB_WEBAPI					@"SSN_ITGLAPWEBAPI"

// Connect Session Key Define(Customer Define) -by Berdo 2015-11-11
#define HDSEC_INVT						@"SSN_HDSEC_INVT"
#define HDSEC_GSTK						@"SSN_HDSEC_GSTK"
#define HDSEC_GFUT						@"SSN_HDSEC_GFUT"


// SessionInfo Default KeyName -by Berdo 2015-11-11
///////////////////////////////////////////////////
#define LOGIN_RESULT					@"login.result"
#define APP_NAME						@"app.name"

///////////////////////////////////////////////////

// DISPLAY DEFAULT INFO -by Berdo
//#define 	STANDARD_WIDTH_MTS 			320
//#define		STANDARD_HEIGHT_MTS			568
#define 	STANDARD_WIDTH_MTS 			540
#define	STANDARD_HEIGHT_MTS			940
#define	STANDARD_STATUSBAR_H		20
#define 	TITLE_HEIGHT    [CommonUtil calcResize:70 direction:LAYOUT_TYPE_VERTICAL mode:LAYER_TYPE_VERTICAL]
#define 	BOTTOM_HEIGHT   [CommonUtil calcResize:70 direction:LAYOUT_TYPE_VERTICAL mode:LAYER_TYPE_VERTICAL]

////////////////////////////////////////////////////////////////// -- Old..
#define MTS_DEVICE_KEY		@"DWSMTS_DEVICE_ID"

// Service Media
#define MTS_MEDIA_CODE      @"28"           // 스마트폰
#define MTS_MEDIA_APP_CODE	@"B2300"        // 금융 상품
#define MTS_MEDIA_DIRECT	@"PT"						// 다이렉트 : ITGenLabStdDev Direct(PT)

#define SERVERIP_VERSION

#define MTS_IOS_CODE        @"l"

#define HANTOO_ORGANIC      @"001"  // 조직코드 고객용
#define HANTOO_SEQ_NO       @"111"  // 일련번호 고객용

#define HANTOO_EMP_DEPT     @"80001"        // 조작자 부서코드
#define HANTOO_EMP_ID       @"999999"       // 조작자 사번

#define k_db_ver                @"db.ver"
#define SERVER_INDEX_KEY        @"server.index.key"         ///
#define DEFAULT_SERVER_INDEX    @"2"                    ///< 0 운영 1 테스트 2 (web 로컬)
#define REAL_SERVER_INDEX       @"0"
#define DEV_SERVER_INDEX        @"1"
#define DEV_SERVER_INDEX2       @"2"
#define FORMDE_USE              @"common.formde.use"
#define SERVER_CONNECT_IP       @"server.connect.ip"

#define SERVERIP_REAL_VER_HTTP      @"http://new.real.download.dws.co.kr/"
#define SERVERIP_DEV_VER_HTTP       @"http://new.test.download.dws.co.kr/"

// 테스트 LBS 서버
#define SERVERIP_LBS_TEST       @"190.190.158.212"
#define SERVERIP_LBS            @"210.107.75.59"
#define SERVERIP_LBS_PORT       2001
#define SERVERIP_MCA_PORT       2001

#ifndef ITGEN_LAB
#define SERVERIP_FORMDE_DEV     @"112.175.10.69"        // 폼 서버
#define SERVERIP_FORMDE_REAL	@"112.175.10.128"
#define SERVER_PORTFORM         18002
#else
#define SERVERIP_FORMDE_DEV     @"210.107.75.34"        // 폼 서버(한투) @"211.45.127.5"
#define SERVERIP_FORMDE_REAL    @"210.107.75.34"        // 폼 서버(한투)
#define SERVER_PORTFORM         9010		//(본사)(한투)
#endif
/////



//#define SYSTEM_CONNECT_WEBSOCKET_IP_TAG		@"CONN_IP_WEBSOCKET"
//#define SYSTEM_CONNECT_WEBSOCKET_IDX_TAG	@"LASTIDX_WEBSOCKET"
//#define SYSTEM_CONNECT_WEBSOCKET_PORT_TAG	@"CONN_PORT_WEBSOCKET"
//#define SYSTEM_USE_WEBSOCKET_VERSION		@"USEVERSION_WEBSOCKET"


#define HASH_KEY							@"YH_HASH_KEY"		// 해쉬키

//#define PKMODE_DEFAULT						3
//#define PKMODE_NONE							0
//#define PKMODE_SOCKETIO_TEXT				1
//#define PKMODE_SOCKETIO_BIN					2

/////

#define RESULT_SUCCESS      @"SUCCESS"
#define RESULT_FAIL         @"FAIL"
#define RESULT_CANCEL       @"CANCEL"

// 앱위변조방지
#define CODEGUARD_URL_DEV	@""	// 개발서버
#define CODEGUARD_URL_REAL	@""	// 운영서버

#define LOADING_TEST	// 로딩 테스트
//#define LOADING_TIME_CHECK	// 로딩 시간 체크
#define FORMDE_LOGTRACE		// 로그트레이서 설정

// 알림
// 알람 유형
#define ALARM_ITEMTYPE_NONE				-1
#define ALARM_ITEMTYPE_MARKET			0
#define ALARM_ITEMTYPE_CHEGYUL			1			// 체결
#define ALARM_ITEMTYPE_HOSTMESSAGE		2			// Host Message
#define ALARM_ITEMTYPE_PUSH				3			// 양뱡향 메세지

#define DESCRIPT_SYMBOL 				@"&cap;"
#define SEP                             @"^SP^"
#define SEPERATOR                       @"^ST^"
#define MESSAGE_KEY                     @"&langkey"

#define DIR_SOUND_PATH  				@"sound"
#define PUSH_OPENINFO_FILEPATH      	@"push.dat"
#define SYSTEM_CONNECT_FILEPATH     	@"connect.dat"
#define SYSTEM_CONNECT_IP_TAG       	@"CONN_IP"
#define SYSTEM_CONNECT_IDX_TAG          @"LASTIDX"
#define SYSTEM_CONNECT_PORT_TAG     	@"CONN_PORT"
#define SYSTEM_USE_VERSION              @"USEVERSION"




#define SYSTEM_SOUND_FORM           	@"caf"
#define PUSH_SOUND_FILE_NAME        	@"push_alarm.caf"
#define FILENAME_ACCOUNTORDER       	@"AccountOrder.dat"
#define FILENAME_SCRSHOTDEFAULT     	@"SNSShareScrShot.png"

// 화면 정의
#define SCR_WEB                     	@"WEB"

#define config_themedefault             @"hyundai1"
#define config_theme_yellow             @"yellow"
#define config_theme_brown              @"brown"
#define config_theme_navy               @"navy"
#define config_theme_blue               @"blue"
#define config_theme_motu               @"motu" // 모의투자용 테마


// notification 결과 코드 키.
#define NOTIFY_RESULT_TYPE                          @"type"
#define NOTIFY_RESULT_KEY                           @"result"
#define NOTIFY_RESULT_MESSAGE                       @"message"

#pragma mark -
#pragma mark - 통지 이름 정의 모음

// 메인 통지
#define NotifyUpdateProcessEnd                      @"notifyUpdateProcessEnd"
#define NotifyDownloadMasterEnd                     @"notifyDownloadMasterEnd" // escdream 2016.09.12
#define NotifyQuickMenuReset                        @"notifyQuickMenuReset"
#define NotifyFinishCertPasswordWithResult          @"notifyFinishCertPasswordWithResult"
#define NotifySSOLoginProcessEnd                    @"NotifySSOLoginProcessEnd"


// 로그인 결과 통지
#define NotifyFinishLogInWithResult                 @"notifyFinishLogInWithResult"
// 로그인 성공 / 로그아웃 통지
#define NotifyLogInOutResult                        @"notifyloginoutResult"

// 공인 인증 통지
#define NotifyFinishCopyPublicCertWithResult        @"notifyFinishCopyPublicCertWithResult"

// PDF 통지
#define NotifyExtWorkFinished                       @"NotifyExtWorkFinished"
// 관심 통지
#define NotifyInterestSearchResult                  @"notifyInterestSearchResult"
#define NotifyDropListSelectItem                    @"notifyDropListSelectItem"
#define NotifyNeedUpdateData                        @"notifyNeedUpdateData"
#define NotifyItemModifyActionResult                @"notifyItemModifyActionResult"
#define NotifyItemCellTouchEvent                    @"notifyItemCellTouchEvent"
#define NotifyInterestItemSearchResult              @"notifyInterestItemSearchResult"
#define NotifyGroupModifyActionResult               @"notifyGroupModifyActionResult"
#define NotifyTableViewCellTouchEvent               @"notifyTableViewCellTouchEvent"
#define NotifyTableViewCellTouchEventGroup          @"notifyTableViewCellTouchEventGroup"
#define NotifyInterestGrouprefresh                  @"NotifyInterestGrouprefresh"
#define NotifyInterestDataRefresh                   @"notifyInterestDataRefresh"

// 검색 통지
#define NotifyCommonSearchResult                    @"notifyCommonSearchResult"
#define NotifyElwUnderlyingAssetResult              @"NotifyElwUnderlyingAssetResult"
#define NotifyElwUnderlyingAssetWithOptionResult    @"NotifyElwUnderlyingAssetWithOptionResult"
#define NotifyCommonSearchCode                      @"notifyCommonSearchCode"
#define NotifyCommonSearchClose						@"notifyCommonSearchClose"

// 테이블 뷰 셀 스크롤 통지
#define NotifyMoveToScroll @"notfiyMoveToScroll"

#pragma mark -
#pragma mark - 세션 정보 저장 키 값
// 로그인 및 공인인증 관련
#define SIGN_DATA_SIZE                              8192
#define CERT_ISSUER_SIGN_KOREA						@"SignKorea"
#define KEYCHAIN_SHARING_GROUP_NAME					@"9HGEUUW579.com.Lab.KeySharingGroup"

// 보안 키패드 임시 저장 텍스트
#define KEY_SECURE_KEYBOARD_IDPWD                   @"IDPWD"
#define KEY_SECURE_KEYBOARD_CERTPWD                 @"CERTPWD"
#define KEY_SECURE_KEYBOARD_USERID                  @"USERID"
#define KEY_SECURE_KEYBOARD_JUMIN                   @"JUMIN"
#define KEY_SECURE_KEYBOARD_ETC                     @"ETC"
#define KEY_SECURE_KEYBOARD_ACCPWD                  @"ACCPWD"
#define KEY_SECURE_KEYBOARD_OTP                     @"OTP"
#define KEY_SECURE_KEYBOARD_CARD                    @"CARD"

#define KEY_LAST_QUICKMENU_NAME                     @"KeyLastQuickMenuName"
#define KEY_QUICKMENU                               @"KeyQuickMenu"
#define KEY_QUICKMENU_INDEX                         @"KeyQuickMenuIndex"


// 하단 외부 SNS 관련
#define EXT_SNS_MENUBAR_HEIGHT                      33
#define EXT_SNS_MENUBAR_ITEM_HEIGHT                 33
#define EXT_SNS_MENUBAR_ITEM_WIDTH                  33

#define MOBILE_APP_SHORT_URL @"[ITGenLab] 모바일웹"
#define MOBILE_TWITTER_APP_SHORT_URL @"[ITGenLab] 모바일웹"
#define MOBILE_SNS_APP_NAME @"ITGenLab ItgenStdDev "
#define MOBILE_TWITTER_APP_NAME @"ITGenLab ItgenStdDev "
#define MOBILE_APP_URL @"http://m.?.com"

// 메인 화면 히스토리 관련
// 화면 이동 히스토리 최대 갯수
#define MAX_VIEW_HISTORY_COUNT                      30
// 한번에 보여주는 화면 히스토리 갯수
#define MAX_VIEW_HISTORY_DISPLAY_COUNT              5
// 히스토리 저장 키
#define KEY_VIEW_HISTORY_DATA                       @"ViewHistoryData"

// 환결설정 관련 정의
// 환경설정 관심내려받기
#define CONFIG_MODE_INTRIMPORT                      @"INTR_IMPORT"

// 외부 연동 관련 정의
#define EXT_SNS_ITEM_COUNT                          5

// PDF 보기
#define SNS_TYPE_PDFVIEW                            @"PDFView"

#define RESULT_SUCCESS                              @"SUCCESS"
#define RESULT_FAIL                                 @"FAIL"
#define RESULT_CANCEL                               @"CANCEL"

// SNS TextImageView 에서 쓰는 View Mode -by Berdo 2012-01-19
#define KEY_SNSTEXTIMAGEVIEW_MODE                   @"KEY_SNSTEXTIMGVIEW_MODE"
#define KEY_SNSSCRSHOT_IMGPATH                      @"KEY_SNSSCRSHOT_IMGPATH"

// 검색 관련
#define COMMON_TABLEVIEW_ITEM_HEIGHT                35.f
#define LISTTABLE_HEADER_HEIGHT                     35
#define LISTTABLE_FIXED_COLUMN_WIDTH                140
#define LISTTABLE_FLEXIBLE_COLUMN_WIDTH             80

// [MainViewControler procMessage] 에서 처리되는 메세지 정의  -by Berdo
#define PRMSG_DATA_MESSAGE                          @"DATA_MESSAGE"             // 데이터 조회 에러 메시지를 하단 메뉴영역에 출력한다.

// 이후에 생성하는 procMessage 는 prefix 로 "PRMSG_" 를 붙여서 선언한다. -by Berdo 2012-01-17
#define PRMSG_SNS_SCRSHOTSHARE                      @"PRMSG_SNS_SCRSHOTSHARE"   // 스크린샷 공유 -by Berdo 2012-01-17
#define PRMSG_SNS_MESSAGESHARE                      @"PRMSG_SNS_MESSAGESHARE"   // SNS 메세지 공유 -by Gon
#define PRMSG_SNS_LOGIN                             @"PRMSG_SNS_LOGIN"          // SNS 로그인 -by Gon
#define PRMSG_CHANGE_MENU                           @"CHANGE_MENU"              // 현재 메뉴아이템을 변경한다.

#define	PRMSG_DOWNLOAD_CLOUD						@"DOWNLOAd_CLOUD"
#define	PRMSG_UPLOAD_CLOUD							@"UPLOAd_CLOUD"


// 관심 그룹 편집 마지막 화면
#define KEY_INTERESTE_EDIT_LASTVIEW             @"InterestEditLastView"

// 관심 설정 정보 저장 키
#define KEY_INTEREST_GROUPMOVE                  @"InterestGroupMove"
#define KEY_INTEREST_MARKET_ALARM_COLOR         @"InterestMarketAlarmColor"
#define KEY_INTEREST_SHOW_ITEM_SINGLELINE       @"InterestShowItemSingleLine"
#define KEY_INTEREST_SING_INTENSITY             @"InterestSignIntensity"
#define KEY_INTEREST_FOREIGNER_SHARE_RATIO      @"InterestForeignerShareRatio"
#define KEY_INTEREST_BREAKEVEN                  @"InterestBreakEven"
#define KEY_INTEREST_EARNING_RATE               @"InterestEarningRate"
#define KEY_INTEREST_PURCHASE_COUNT             @"InterestPurchaseCount"
#define KEY_INTEREST_AVERAGE_PRICE              @"InterestAveragePrice"
#define KEY_INTEREST_FOREIGNER_TRADE_PUSH       @"InterestForeignerTradePush"
#define KEY_INTEREST_FOREIGNER_MARET            @"InterestForeignerTradeMarket"
#define KEY_INTEREST_FOREIGNER_TRADE_TYPE       @"InterestForeignerTradeType"
#define KEY_INTEREST_FOREIGNER_TRADE_QYT        @"InterestForeignerTradeQyt"

#define BUTTON_TEXT_SUBSCRIBE_REQUEST			@"가입신청"
#define BUTTON_TEXT_MODIFY_INFORMATION			@"정보변경"
#define H0_HISTORY								@"H0최근종목조회"
#define GROUPKEY_HIS							@"H0" // 최근 종목 그룹키

// URL CALL define
#define URLCALL_DWMOBILE						@"mdwmobile"
#define URLCALL_MWORK							@"mdmwork"
#define URLCALL_COMPASS							@"ITGenLabcompass"

// Safe Release Macro
//#define SAFE_RELEASE(p)     \
//if(p != nil) { [p release]; p = nil; }

// 종목 시장 구분
#define MK_KOSPI_STOCK			'J'
#define MK_KOSDAQ_STOCK			'Q'
#define MK_ELW					'W'
#define MK_DOMESTIC_BOND		'B'
#define MK_ELS                  'S'
#define MK_FUND                 'D'

#define MK_ELW_LIST				'L'
#define MK_FUTURE				'F'
#define MK_OPTION				'O'
#define MK_KOSPI_INDEX			'I'
#define MK_KOSDAQ_INDEX			'K'
#define MK_OVERSEA_INDEX		'S'
#define MK_CMDFUTURE			'M'
#define MK_CFUTURE				'C'
#define MK_KOSPI_DETAIL			'A'
#define MK_KOSDAQ_DETAIL		'Z'
#define MK_MEMBER_FIRMS			'E'
#define MK_JISU_JINGHAP			'G'	// 지수종합

//#define STR_MK_KOSPI_STOCK		@"J"
//#define STR_MK_KOSDAQ_STOCK		@"Q"
//#define STR_MK_ELW              @"W"
#define STR_MK_FUTURE           @"F"
#define STR_MK_OPTION           @"O"
#define STR_MK_KOSPI_INDEX      @"I"
#define STR_MK_KOSDAQ_INDEX     @"K"
#define STR_MK_OVERSEA_INDEX    @"S"
#define STR_MK_CMDFUTURE		@"M"
#define STR_MK_CFUTURE			@"C"
#define STR_MK_JISU_JONGHAP		@"G"



#define STR_MK_KOSPI_STOCK          @"0"

#define STR_MK_KOSDAQ_STOCK         @"1"
#define STR_MK_KONEX_STOCK          @"N"
#define STR_MK_KOTC_STOCK           @"9"
#define STR_MK_ELW                  @"n"
#define STR_MK_UPJONG               @"U"
#define STR_MK_UPJONG5              @"5"
#define STR_MK_UPJONG6              @"6"
#define STR_MK_UPJONG7              @"7"
#define STR_MK_UPJONG_KOSPI         @"5"
#define STR_MK_UPJONG_KOSDAQ        @"6"
#define STR_MK_UPJONG_KOSPI200      @"7"
#define STR_MK_INDEX_FUTURE         @"2"
#define STR_MK_INDEX_FUTURE_KOSDAQ150 @"Z"
#define STR_MK_INDEX_FUTURE_SPR     @"d"
#define STR_MK_INDEX_OPTION         @"3"
#define STR_MK_MINI_INDEX_FUTURE	@"f"
#define STR_MK_MINI_INDEX_OPTION	@"o"
#define STR_MK_V_INDEX_FUTURE       @"L"
#define STR_MK_S_INDEX_FUTURE       @"K"
#define STR_MK_STOCK_FUTURE         @"S"
#define STR_MK_COM_FUTURE           @"C"
#define STR_MK_EXCHANGE             @"E"
#define STR_MK_PREEMPTIVRIGHT       @"4"
#define STR_MK_RETIRE               @"X" //

#define STR_MK_INDEX_KRX300         @"r"
#define STR_MK_INDEX_Q150_OPTION    @"Q"

#define MULTILOGIN_POPUP_USE				//

// 구글지도 API 키
#define GOOGLE_MAP_API_KEY      @"AIzaSyCBV_XjePj7jV7TmFs4PMyIsbQ36CH2c38"
// 네이버 지도 오픈 API 키
#define NAVER_MAP_API_KEY		@"793a9b288572242b871d7e18bb83f4c4"

// 화면크기 관련
#define SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height-20)
#define SCREEN_HEIGHT_DIFF      ([UIScreen mainScreen].bounds.size.height-480)

#define NSEUCKREncoding             (0x80000000 + kCFStringEncodingDOSKorean)

#define	NULL_DATA					@""
#define SPACE_DATA                  @" "

// 이미지 리사이징
#define MAX_RESOLUTION  480
#define MIN_RESOLUTION  360

#define FILE_EXT_HWP    @"hwp"
#define FILE_EXT_PDF    @".pdf"

// AppType -by Berdo 2013-08-27
typedef enum enum_AppType
{
	APPTYPE_MABLE_KBSEC         = 1,
    
} AppType;

// Base App Delegate Message Table
typedef enum enum_SendMessageType
{
	MSG_MAINVIEWCON_LOAD_UICONTROLLER                   = 0,
	MSG_MAINVIEWCON_UNLOAD_UICONTROLLER                 = 1,
	MSG_MAINVIEWCON_LOADPRESENMODAL_UICONTROLLER        = 2,
	MSG_MAINVIEWCON_POSTLINK_DATA                       = 3,
	MSG_MAINVIEWCON_PROCESSMSG                          = 4,
	MSG_MAINVIEWCON_OPENSCREEN                          = 5,
	MSG_MAINVIEWCON_CLOSESESSION                        = 6,
	MSG_MAINVIEWCON_PROCESSTRANMSG                      = 7,
	MSG_MAINVIEWCON_CHECKCERT                           = 9,
	MSG_MAINVIEWCON_OPENSCREENEX                        = 10,
	MSG_MAINVIEWCON_LOAD_IMAGEPICKER                    = 20,
	MSG_MAINVIEWCON_LOAD_FILEEXPLORER                   = 21,
	MSG_MAINVIEWCON_CTL_REQMESSAGE                      = 22,
	MSG_EVENT_CLICKBACKGROUND                           = 30, // 터치에 관련된 이벤트
	MSG_MAINVIEWCON_PROFILE                             = 31,
    MSG_MAINVIEWCON_SETTITLEBUTTON                      = 32,
    MSG_MAINVIEWCON_SETTITLERADIO                       = 33,
    MSG_MAINVIEWCON_TITLE_UPDATE                        = 34,
    MSG_MAINVIEWCON_MULTILOGIN_EXIT                     = 35, // 멀티로그인 리시브 이벤트
    MSG_MAINVIEWCON_MULTILOGIN_MESSAGE                  = 36, // 멀티로그인 리시브 메시지 이벤트
    MSG_MAINVIEWCON_CHECK_UICONTROLLER                  = 37, // 팝업컨트롤러 체크
    MSG_MAINVIEWCON_TITLETEXT_UPDATE                    = 38,
    
    
	MSG_UPDATE_APP                                      = 12,
	MSG_FINISH_UPDATE                                   = 13,
	MSG_CREATE_FORMFLOAT                                = 14, // 플로팅 컨트롤
	MSG_UPDATE_START                                    = 80, // 버전처리 시작
	MSG_UPDATE_PROGRESS                                 = 16, // 프로세스바 시작
	MSG_BLOCK_UPDATE                                    = 17,
    MSG_RECEIVE_MCAINIT                                 = 19, // MCAINIT
    MSG_UPDATE_MASTER_PROGRESS                          = 15, // 마스터 다운로드...
    
    
	MSG_FORM_HEIGHT                                     = 40, // 폼 사이즈
	MSG_FORM_TOP_SCROLL                                 = 41, // 스크롤 탑으로 이동
	MSG_FORM_CAPTION_INFO                               = 42, // 캡션의 도움말 버튼
	MSG_MAINVIEWCON_LOGIN                               = 43, // 로그인
	MSG_MAINVIEWCON_RELOGIN                             = 44,   // 재로그인
	MSG_MAINVIEWCON_DOWNLOAD                            = 45, // 다운로드 프로그래스바
	MSG_FORM_MOVEHOME_FLAG                              = 46, // 홈으로 이동 여부 플래그
	MSG_MASTER_LOAD                                     = 47, // 마스터 로드
    MSG_MASTER_LOAD_BEGIN                               = 48, // 마스터 로드 종료
    MSG_MASTER_LOAD_END                                 = 49, // 마스터 로드 종료
    MSG_FORE_MASTER_LOAD                                = 65, // escdream 2018.07.11 added

    
	MSG_FORM_SAVE_BASKET                                = 50, // 장바구니 저장
	MSG_FORM_LOAD_BASKET                                = 51, // 장바구니 조회
	MSG_FORM_DELETE_BASKET                              = 52, // 장바구니 삭제
	MSG_SNS_UPDATE_FACEBOOK                             = 53, // 페이스북
	MSG_SNS_UPDATE_TWITTER                              = 54, // 트위터
	MSG_SNS_POST_KAKAOTALK                              = 55, // 카카오톡
	MSG_SNS_POST_KAKAOSTORY                             = 56, /// 카카오 스토리
	MSG_REALPROC_DATA                                   = 58, ///< 실시간 응답
	MSG_FORM_PUSH                                       = 59, ///< 푸쉬 관련
    MSG_JANGREAL_DATA                                   = 57, // JANGREAL 관련
	
    
    
    MSG_SNS_LOGIN_FACEBOOK                              = 81,
    MSG_SNS_LOGIN_KAKAO                                 = 82,
    MSG_SNS_LOGIN_NAVER                                 = 83,
    
	MSG_FDS_START                                       = 60, ///< FDS 처리
	MSG_MAINVIEWCON_ADDNETWORKVIEW                      = 70,   ///< 망전환 뷰 추가
	MSG_MAINVIEWCON_CLEARNETWORKVIEW                    = 71,   ///< 망전환 뷰 삭제
	MSG_MAINVIEWCON_ADDWAITCURSOR                       = 97,
	MSG_MAINVIEWCON_CLEARWAITCURSOR                     = 98,
	MSG_MAINVIEWCON_REMOVEWAITCURSOR                    = 99,
	MSG_MAINVIEWCON_CATEGORY_NONE                       = 100, ///< 뷰 전체를 기본으로 돌린다.
    
    MSG_MAINVIEWCON_MENU_TYPE                           = 101,
    
    MSG_MAINVIEWCON_RATATE                              = 200,
    MSG_MAINVIEWCON_RATATE_PORTATE                      = 201,
    MSG_MAINVIEWCON_RATATE_LANDSCAPE                    = 202,
    

    MSG_FORM_DEBUG_LOG_INFO                             = 900, // debug message
    
    
    MSG_UPDATE_FILE_RESTART_MAIN                        = 6000, // 포어
    
    
    MSG_MAINVIEWCON_MESSAGE_RECV_SSAN8882               = 5000,
    MSG_MAINVIEWCON_MESSAGE_RECV_SSAM8882               = 5001,
    MSG_MAINVIEWCON_MESSAGE_RECV_SFQN3000               = 5002,
    MSG_MAINVIEWCON_MESSAGE_RECV_SFQM3001               = 5003,
    
}SendMessageType;

typedef enum enum_ReceiveMessageType
{
	RECV_MAINVIEWCON_MAINMODE                    = 0,        // 메인모드
	RECV_MAINVIEWCON_TOPCON                      = 1,        // 메인뷰에서 탑컨트롤 뷰
	RECV_MAINVIEWCON_TOPMODALCON                 = 2,        // 메인뷰에서 모달 탑 컨트롤 뷰
	RECV_MAINVIEWCON_SCREENVIEW                  = 3,        // 스크린 뷰
	RECV_MAINVIEWCON_TITLE_RECT                  = 4,        // 타이틀 높이
	RECV_MAINVIEWCON_VIEW                        = 5,        // 메인 뷰
	RECV_MAINVIEWCON_MAINTRAN                    = 6,        // 메인 TRANSACTION
	RECV_MAINVIEWCON_UPDATEPROCESS               = 7,        // 업데이트 프로세서
	RECV_MAINVIEWCON_SCREENRECT                  = 8,        // 스크린 사이즈
	RECV_APPDELEGATE_DBPATH                      = 9,        ///< 디비 경로
	RECV_APPDELEGATE_NEWPUSHCOUNT                = 10,      ///< 새롭게 읽은 푸시 카운트
	RECV_APPDELEGATE_NEWPUSHCOUNT_RESET          = 11,       ///<
    
    RECV_APPDELEGATE_NETWORK_RECONNECT           = 12,
    
    
}ReceiveMessageType;


typedef enum enum_MainViewRectType
{
	MVRECTINFO_TITLE        = 0,
	MVRECTINFO_BOTTOM       = 1,
	MVRECTINFO_SCREEN       = 2,
	
}MainViewRectType;

#define STR_OPEN_DIALOG @"openDialog"
#define STR_OPEN_SCREEN @"openScreen"
#define STR_OPEN_POPUP  @"openPopup"
#define STR_OPEN_FRAMEPOPUP @"openFramePopup"
#define STR_OPEN_POPOVER @"openPopOver"
#define STR_START_LOGINOUT @"StartLogOut"
#define STR_GET_FDS @"GetFDSDATA"
#define STR_PICKER_CHANGE @"PICKER_CHANGE"
#define STR_PICKER_COUNT_TEXT  @"PICKER_COUNTTEXT"
#define STR_MAIN_CONFIG @"MAIN_CONFIG"
#define STR_START_LOGIN     @"START_LOGIN"
#define STR_SCREEN_CAPTION  @"SCREEN_CAPTION"
#define STR_OPEN_URL        @"OPEN_URL"
#define STR_MAIN_CONFIG     @"MAIN_CONFIG"
#define STR_BASKET_COUNT    @"BASKET_COUNT"
#define STR_HISTORY_ITEM_COUNT  @"HISTORY_ITEM_COUNT"
#define STR_SHOW_BOTTOM     @"showbottom"
#define STR_DATA_MESSAGE    @"DATA_MESSAGE"
#define STR_SHOW_FAV_GLOBAL @"showEditInterestDialog"
#define STR_SHOW_ADDCERTIFY @"showAddCertifyDialog"
#define STR_CLOSE_ADDCERTIFY @"closeAddCertifyDialog"
#define STR_REQUEST_FAKE     @"requestFakeCheckKey"

#endif
