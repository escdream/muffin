//
//  ResourceManager.h
//  SmartVIGS
//
//  Created by juyoung Kim on 11. 6. 8..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COLOR_MAX_SIZE		3
#define COLOR_KEY_SIZE		3
#define COLOR_VALUE_SIZE	9

#define BORDER_STRIKE		1.0f

#define LINEFEED			@"\r\n"
#define LINEFEED2           @"/r/n" // 라벨에서 구분자로 쓰임
#define CATEGORY_START		@"["
#define SEPARATOR_FILE		@"="
#define CATEGORY_END		@"]"
#define SEPARATOR_MAP		@"`"

#define TABSHADOWOFFSET        -1
#define BTNSHADOWOFFSET        1

//#define LARGE_X_IMAGE		// 닫기버튼 이미지 변경 => 이미지 교체 후 살리면 됩니다. -cory 2013.11.03


#define NO_COLOR 			-1
#define COLOR_TRAN			42			// 폼배경색

//THEME

//#define CID_UPSIDE					1 			// 상승색
//#define CID_DOWNTREND				2 			// 하락색
//#define CID_STEADY					3			// 보합색
//#define CID_BASIC_TEXT				4			// 기본글자색
//#define CID_SELECT_TEXT				5           // 선택글자색
//#define CID_UPSIDE_TEXT             10 			// 상승글자색
//#define CID_DOWNTREND_TEXT          11 			// 하락글자색
//#define CID_STEADY_TEXT             12			// 보합글자색
//#define CID_FORCE_TEXT              142         // 강조글자색
//
//#define CID_SUB_TEXT				13          // 보조글자색
//#define CID_OUTLINE					17			// 외부 테두리
//#define CID_INNERLINE				25			// 그리드 내부 테두리
//#define CID_TABLE_INNERLINE			73			// 테이블 내부 테두리
//#define CID_HOGATABLE_INNERLINE		72			// 호가테이블 내부 테두리
//#define CID_BASIC_BACK				28			// 기본배경색
//#define CID_HIGHLIGHT_BACK			29			// 하이라이트 배경색
//#define CID_CELL_BACK				38			// 셀배경색
//#define CID_FORM_BACK				42			// 폼바탕
//#define CID_TAB_INACTIVE_TEXT		49			// 비활성 탭 텍스트 색상
//#define CID_CELL_BLOCK_BACK			51			// 셀 블럭 배경색
//#define CID_TAB_ACTIVE_TEXT			61			// 활성 탭 텍스트 색상
//#define CID_BUTTON_TEXT				62			// 버튼 기본 글자색
//#define CID_BUTTON_DISABLE_TEXT		100			// 버튼 비활성 글자색
//#define CID_BUTTON_SELECT_TEXT		168			// 버튼 선택및실행 글자색
//#define CID_BASIC_BORLER			70          // 레이블테두리
//#define CID_COMMON_TITLE_BAR_COLOR  89          // 화면 타이틀바 배경색
//#define CID_TITLE_TEXT              63          // 타이틀 바 기본 글자색
//#define CID_BASICPOPUP_TEXT         115          // 메시지창 내용 기본 글자색
//#define CID_SEARCH_ASSET_GRID_HEADER_TEXT   65  // 기초자산 검색 리스트 헤더 텍스트 색상
//#define CID_SEARCH_ASSET_GRID_HEADER    66      // 기초자산 검색 리스트 헤더 색상
//#define CID_INTEREST_CONFIG_TEXT    173      // 관심편집글자색
//
//#define CID_BONG_UPSIDE             135         // 봉그래프 상
//#define CID_BONG_DOWNTREND          136         // 봉그래프 하
//#define CID_TABLE_SELECT_COLOR      87         // 리스트 아이템 선택 시 색상
//
//#define CID_BASIC_INPUT_TEXT		95			// 입력기본글자색
//#define CID_BASIC_INPUT_SUBTEXT		96			// 입력보조글자색
//#define CID_CHARTCOLOR11			131			// 차트색상 11
//#define CID_MAINMENU_BACKCOLOR      118         // 메인 메뉴 배경색
//#define CID_COMBO_TEXT              148			// 콤보글자색
//#define CID_ACCCOMBO_TEXT           149         // 계좌/종목 코드 글자색
//#define CID_ACCCOMBO_SUBTEXT        150         // 계좌/종목 이름 글자색
//#define CID_SCREEN_OUTLINE          178			// 분할화면 외부 테두리
//#define CID_RADIOBTN_ACTIVE_TEXT    193			// 라디오 버튼형 활성화 색상
//#define CID_RADIOBTN_INACTIVE_TEXT  179			// 라디오 버튼형 비활성화 색상
//
//#define CDI_TAB_SELECT_TEXT         190			// 라디오 버튼형 비활성화 색상
//#define CDI_TAB_NORMAL_TEXT         193			// 라디오 버튼형 비활성화 색상
//
//#define CDI_COMBOLIST_TEXT          201			// 라디오 버튼형 비활성화 색상
//
//
//#define CDI_ITEMCODE_CODE           199
//#define CDI_ITEMCODE_MARKET         201

#define CID_COLOR_BAR_UP            191
#define CID_COLOR_BAR_DOWN          192
#define CID_UPSIDE					193 			// 상승색
#define CID_DOWNTREND				194 			// 하락색
#define CID_STEADY					195			// 보합색
#define CID_BASIC_TEXT				200			// 기본글자색
#define CID_SELECT_TEXT				200           // 선택글자색
#define CID_UPSIDE_TEXT             193 			// 상승글자색
#define CID_DOWNTREND_TEXT          194 			// 하락글자색
#define CID_STEADY_TEXT             195			// 보합글자색
#define CID_FORCE_TEXT              200         // 강조글자색

#define CID_SUB_TEXT				200          // 보조글자색
#define CID_OUTLINE					215			// 외부 테두리
#define CID_INNERLINE				216			// 그리드 내부 테두리
#define CID_TABLE_INNERLINE			216			// 테이블 내부 테두리
#define CID_HOGATABLE_INNERLINE		216			// 호가테이블 내부 테두리
#define CID_BASIC_BACK				221			// 기본배경색
#define CID_HIGHLIGHT_BACK			221			// 하이라이트 배경색
#define CID_CELL_BACK				221			// 셀배경색
#define CID_FORM_BACK				221			// 폼바탕
#define CID_TAB_INACTIVE_TEXT		203			// 비활성 탭 텍스트 색상
#define CID_TAB_ACTIVE_TEXT			200			// 활성 탭 텍스트 색상
#define CID_CELL_BLOCK_BACK			221			// 셀 블럭 배경색
#define CID_BUTTON_TEXT				200			// 버튼 기본 글자색
#define CID_BUTTON_DISABLE_TEXT		208			// 버튼 비활성 글자색
#define CID_BUTTON_SELECT_TEXT		200			// 버튼 선택및실행 글자색
#define CID_BASIC_BORLER			215          // 레이블테두리
#define CID_COMMON_TITLE_BAR_COLOR  219          // 화면 타이틀바 배경색
#define CID_TITLE_TEXT              201          // 타이틀 바 기본 글자색
#define CID_BASICPOPUP_TEXT         200          // 메시지창 내용 기본 글자색
#define CID_SEARCH_ASSET_GRID_HEADER_TEXT   200  // 기초자산 검색 리스트 헤더 텍스트 색상
#define CID_SEARCH_ASSET_GRID_HEADER    200      // 기초자산 검색 리스트 헤더 색상
#define CID_INTEREST_CONFIG_TEXT    200      // 관심편집글자색

#define CID_BONG_UPSIDE             193         // 봉그래프 상
#define CID_BONG_DOWNTREND          194         // 봉그래프 하
#define CID_TABLE_SELECT_COLOR      221         // 리스트 아이템 선택 시 색상

#define CID_BASIC_INPUT_TEXT		200			// 입력기본글자색
#define CID_BASIC_INPUT_SUBTEXT		200			// 입력보조글자색
#define CID_CHARTCOLOR11			221			// 차트색상 11
#define CID_MAINMENU_BACKCOLOR      221         // 메인 메뉴 배경색
#define CID_COMBO_TEXT              200			// 콤보글자색
#define CID_ACCCOMBO_TEXT           200         // 계좌/종목 코드 글자색
#define CID_ACCCOMBO_SUBTEXT        200         // 계좌/종목 이름 글자색
#define CID_SCREEN_OUTLINE          215			// 분할화면 외부 테두리
#define CID_RADIOBTN_ACTIVE_TEXT    200			// 라디오 버튼형 활성화 색상
#define CID_RADIOBTN_INACTIVE_TEXT  200			// 라디오 버튼형 비활성화 색상

#define CDI_TAB_SELECT_TEXT         201			// 라디오 버튼형 비활성화 색상
#define CDI_TAB_NORMAL_TEXT         200			// 라디오 버튼형 비활성화 색상

#define CDI_COMBOLIST_TEXT          201			// 라디오 버튼형 비활성화 색상


#define CDI_ITEMCODE_CODE           200
#define CDI_ITEMCODE_MARKET         200


#define CDI_BOTTOM_MENU_COLOR       219
#define CDI_BOTTOM_MENU_LINE        214
#define CDI_BOTTOM_MENU_BACKGROUND_COLOR    222


//#define CID_CERT_COMMENT_BOLD_COLOR 67         // 공인 인증 센터 안내 문구 강조 글자 색
//#define CID_CERT_SUBTITLE_BACKCOLOR 39         // 공인 인증센터 복사 중간 제목 배경색
//#define CID_TEXTFIELD_HIGHLIGHT_COLOR   137     // 텍스트 필드 터치 시 잠깐 동안 나타나는 배경색.
//#define CID_ASSET_KOSIP_CELL_BACKGROUND   29   // 기초자산 KOSPI200 배경 색


//#define FONT_DIS					1
//#define FONT_SIZE_DETAIL			8
//#define FONT_SIZE_S					10
//#define FONT_SIZE_S2				12
//#define FONT_SIZE_M					13				// 기본폰트크기 : 13 point
//#define FONT_SIZE_L					18

// Font Unit Definitions
/** CHG KDJ 20131031 - 폰트크기 변경전
#define FTU_POPUP_TITLE				5				// 공통팝업 타이틀
#define FTU_POPUP_BUTTON			0				// 공통팝업 버튼
#define FTU_CBLST_CALC_ACNTNO		0				// 콤보리스트 계좌번호 계산
#define FTU_CBLST_CALC_ACNTSUB		-4				// 콤보리스트 계좌서브 계산
#define FTU_CBLST_ACNT				1				// 콤보리스트 계좌번호
#define FTU_CONFIG_ACNT				2				// 계좌설정
#define FTU_ACNTITEM				0				// 계좌항목
#define FTU_ACNTITEM_SUB			-2				// 계좌항목 서브
#define FTU_TICKER					0				// 티커
#define FTU_TICKER_NUMERIC			1				// 티커 수치
#define FTU_HISTORY_LIST			1				// 히스토리 목로
#define FTU_HISTORY_POPUP_TITLE		3				// 히스토리 팝업
#define FTU_HISTORY_POPUP_LABEL		0				// 히스토리 라벨
#define FTU_HISTORY_POPUP_CODE		1				// 히스토리 코드
#define FTU_HISTORY_POPUP_NAME		2				// 히스토리 코드명
#define FTU_INTEREST_TITLE			1				// 관심종목 타이틀
#define FTU_INTEREST_EDIT			2				// 관심종목 편집
#define FTU_INTEREST_LANDSCAPE		1				// 관심종목 가로모드
#define FTU_INTEREST_VIEW			2				// 관심종목 기본뷰
#define FTU_TOAST					0				// 토스트 메시지
#define FTU_LOGIN_VERSION			-2				// 로그인 버전
#define FTU_LOGIN_LABEL				1				// 로그인 라벨
#define FTU_LOGIN_DESCRIPTION		0				// 로그인 서비스명
#define FTU_LOGIN_BUTTON			0				// 로그인 버튼
#define FTU_MENU_TITLE				4				// 메뉴 타이틀
#define FTU_MENU_QUICK_BUTTON		-1				// 퀵메뉴 버튼
#define FTU_MENU_QUICK_HELP			-2				// 전체메뉴 퀵버튼
#define FTU_NAVER_MAP				-1				// 네이버 맵
#define FTU_PUSH_POPUP				0				// 푸쉬팝업
#define FTU_QUICK_MENU				0				// 퀵메뉴
#define FTU_TAB_EDIT_TITLE			4				// 탭편집 타이틀
#define FTU_TAB_EDIT_BUTTON			4				// 탭편집 버튼
#define FTU_UPDATE_LABEL			-2				// 업데이트 라벨
 **/
#define FTU_ALARM_LABEL				-4				// 알람팝업라벨(9pt)
#define FTU_NETWORK_POPUP			-1				// 네트워크팝업(12pt)

#define FTU_POPUP_TITLE				12				// 공통팝업 타이틀()
#define FTU_POPUP_BUTTON			0				// 공통팝업 버튼()

#define FTU_CBLST_HEADER			0				// 콤보리스트 헤더(13pt)
#define FTU_CBLST_LABEL				0				// 콤보리스트 라벨(13pt)
#define FTU_CBLST_SELF				-2				// 콤보리스트 자신(11pt)
#define FTU_CBLST_TITLE				FTU_POPUP_TITLE	// 콤보리스트 타이틀(15pt)
#define FTU_CBLST_ACNTNO			-2				// 콤보리스트 계좌번호(11pt)
#define FTU_CBLST_ACNTTP			-6				// 콤보리스트 계좌구분(7pt)

#define FTU_CONFIG_ACNT				0				// 계좌순서설정(13pt)

#define FTU_ACNTITEM				-3				// 계좌항목(10pt)
#define FTU_ACNTITEM_SUB			-4				// 계좌항목 서브(9pt)

#define FTU_TICKER					-2				// 티커(11pt)
#define FTU_TICKER_NUMERIC			-1				// 티커 수치(12pt)

#define FTU_HISTORY_LIST			1				// 최근조회종목 목록(14pt)
#define FTU_HISTORY_POPUP_TITLE		FTU_POPUP_TITLE	// 최근조회종목 팝업(15pt)
#define FTU_HISTORY_POPUP_BUTTON	FTU_POPUP_BUTTON// 최근조회종목 라벨(13pt)
#define FTU_HISTORY_POPUP_CODE		0				// 최근조회종목 코드(13pt)
#define FTU_HISTORY_POPUP_NAME		2				// 최근조회종목 코드명(15pt)

#define FTU_INTEREST_TITLE			-1				// 관심종목 타이틀(12pt)
#define FTU_INTEREST_EDIT			0				// 관심종목 편집(13pt)
#define FTU_INTEREST_LANDSCAPE		-1				// 관심종목 가로모드(12pt)
#define FTU_INTEREST_VIEW			0				// 관심종목 기본뷰13pt)

#define FTU_TOAST					-2				// 토스트 메시지

#define FTU_LOGIN_VERSION			-4				// 로그인 버전(9pt)
#define FTU_LOGIN_LABEL				0				// 로그인 라벨(13pt)
#define FTU_LOGIN_DESCRIPTION		-2				// 로그인 서비스명(11pt)
#define FTU_LOGIN_BUTTON			0				// 로그인 버튼(13pt)
#define FTU_LOGIN_FOOTER			-2				// 로그인 하단(11pt)


#define FTU_MENU_TITLE				FTU_POPUP_TITLE	// 메뉴 타이틀(15pt)
#define FTU_MENU_QUICK_BUTTON		-2				// 퀵메뉴 버튼(11pt)
#define FTU_MENU_QUICK_HELP			-5				// 전체메뉴 퀵메뉴도움말(9pt)
#define FTU_MENU_BOTTOM				-2				// 전체메뉴 하단(11pt)

#define FTU_NAVER_MAP				-3				// 네이버 맵(10pt)

#define FTU_PUSH_POPUP				-2				// 푸쉬팝업(11pt)
#define FTU_QUICK_MENU				-1				// 퀵메뉴(12pt)

#define FTU_TAB_EDIT_TITLE			FTU_POPUP_TITLE	// 탭편집 타이틀(15pt)
#define FTU_TAB_EDIT_BUTTON			0				// 탭편집 버튼(13pt)
#define FTU_UPDATE_LABEL			-4				// 업데이트 라벨(9pt)

//#define FONT_DIS			0.62
//#define FONT_DIS_PLUS       0.58 // 폰트 단위가 + 일경우 안드로이드와 사이즈가 좀 다르다
//#define FONT_SIZE_M			15.2


// escdream  IPhoneX 예외 처리
#define D_FONT_DIS			   [CommonUtil calcResize:1 direction:LAYOUT_TYPE_VERTICAL mode:LAYER_TYPE_VERTICAL]  //0.8//0.62
#define D_FONT_DIS_PLUS      [CommonUtil calcResize:1 direction:LAYOUT_TYPE_VERTICAL mode:LAYER_TYPE_VERTICAL] //0.8// 0.58 // 폰트 단위가 + 일경우 안드로이드와 사이즈가 좀 다르다

#define D_FONT_SIZE_M            20//21.89




#define	COLORTABLE_FILENAME @"color_"
#define COLOR_DEFUALT		[UIColor whiteColor]
#define COLOR_FILE_TYPE		@"dat"

#define IMG_STR_ON			@"_o"
#define IMG_STR_OFF			@"_n"
#define IMG_STR_DIS			@"_d"
#define IMG_STR_EXT			@"png"


// FONT Field
//#define				FONT_NAME				([[CommonUtil getDeviceOS] floatValue] >= 8.0f) ? @"-윤고딕320" : @"YDIYGO320"
//#define				BOLD_FONT_NAME			([[CommonUtil getDeviceOS] floatValue] >= 8.0f) ? @"-윤고딕340" : @"YDIYGO340"
//
//#define				NUMERIC_FONT_NAME		([[CommonUtil getDeviceOS] floatValue] >= 8.0f) ? @"-윤고딕320" : @"YDIYGO320"
//#define				NUMERIC_BOLD_FONT_NAME	([[CommonUtil getDeviceOS] floatValue] >= 8.0f) ? @"-윤고딕340" : @"YDIYGO340"

//#define				FONT_NAME				@"AppleSDGothicNeo-Regular"
//#define				BOLD_FONT_NAME			@"AppleSDGothicNeo-Bold"

//#define				NUMERIC_FONT_NAME		@"AppleSDGothicNeo-Regular"
//#define				NUMERIC_BOLD_FONT_NAME	@"AppleSDGothicNeo-Bold"

#define                 FONT_NAME               @"Helvetica Neue-Light"//@"KBFGText-Light"
#define                 BOLD_FONT_NAME			@"Helvetica Neue–Medium" //@"KBFGText-Medium"
#define                 NUMERIC_FONT_NAME		@"KBFGText-Light"
#define                 NUMERIC_BOLD_FONT_NAME	@"KBFGText-Medium"

/*
    #define				FONT_NAME				@"HDableGothicNeo1Regular"
    #define				BOLD_FONT_NAME			@"HDableGothicNeo1Bold"
    #define				NUMERIC_FONT_NAME		@"HDableGothicNeo1Regular"
    #define				NUMERIC_BOLD_FONT_NAME	@"HDableGothicNeo1Bold"
*/

#define				SIGN_FONT_NAME			@"sign.sec.itgen.midou"

#define CTL_TABHEADER_NORMAL    @"ctl_tab_hdr_n.9.png"
#define CTL_TABHEADER_HIGH      @"ctl_tab_hdr_o.9.png"

//#define CTL_TABHEADER_ORDER_BG  @"ctl_tab_hdr_bg_n.9.png"       /** 주문폼탭용 헤더 이미지 -by cory */
#define CTL_TABHEADER_ORDER_BUY @"ctl_tab_hdr_buy_o.9.png"      
#define CTL_TABHEADER_ORDER_SEL @"ctl_tab_hdr_sell_o.9.png"
#define CTL_TABHEADER_ORDER_MOD @"ctl_tab_hdr_mod_o.9.png"


#define CTL_ACCOUNT_NORMAL      @"combo_white_n.9.png"
#define CTL_ACCOUNT_HIGH        @"combo_white_o.9.png"
#define CTL_ACCOUNT_DIS         @""

#define CTL_BUTTON_BASE         @"btn_white.9"

#define CTL_BUTTON_NORMAL       @"btn_white_n.9.png"
#define CTL_BUTTON_DIS          @"btn_disabled.9.png"
#define CTL_BUTTON_HIGH         @"btn_white_o.9.png"
#define CTL_CHECK_NORMAL        @"checkbox_n.png"
#define CTL_CHECK_HIGH          @"checkbox_o.png"
#define CTL_COMBO_NORMAL        @"combo_n.9.png"
#define CTL_COMBO_HIGH          @"combo_o.9.png"
#define CTL_COMBO_SELECTED      @"combo_o.9.png"
#define CTL_COMBO_DISABLE       @"selec_d.9.png"
#define CTL_RADIO_DOT_NORMAL	@"radio_n.png"
#define CTL_RADIO_DOT_HIGH      @"radio_o.png"
#define CTL_RADIO_BTN           @"radio_o.png"

#define CTL_RADIO_BTN_L_NORMAL  @"tab_pv_left_n.9.png"
#define CTL_RADIO_BTN_L_HIGH    @"tab_pv_left_o.9.png"
#define CTL_RADIO_BTN_C_NORMAL  @"form_tap_middle_n.9.png"
#define CTL_RADIO_BTN_C_HIGH    @"form_tap_middle_o.9.png"
#define CTL_RADIO_BTN_R_NORMAL  @"tab_pv_right_n.9.png"
#define CTL_RADIO_BTN_R_HIGH    @"tab_pv_right_o.9.png"

//
//#define CTL_RADIO_BTN_L_NORMAL  @"form_radio_btn_left_n.9.png"
//#define CTL_RADIO_BTN_L_HIGH    @"form_radio_btn_left_o.9.png"
//#define CTL_RADIO_BTN_C_NORMAL  @"form_tap_middle_n.9.png"
//#define CTL_RADIO_BTN_C_HIGH    @"form_tap_middle_o.9.png"
//#define CTL_RADIO_BTN_R_NORMAL  @"form_radio_btn_right_n.9.png"
//#define CTL_RADIO_BTN_R_HIGH    @"form_radio_btn_right_o.9.png"


#define CTL_RADIO_LIST_L_NORMAL  @"btn_round_beige_n.9.png"
#define CTL_RADIO_LIST_L_HIGH    @"btn_round_yellow_n.9.png"
#define CTL_RADIO_LIST_C_NORMAL  @"btn_round_beige_n.9.png"
#define CTL_RADIO_LIST_C_HIGH    @"btn_round_yellow_n.9.png"
#define CTL_RADIO_LIST_R_NORMAL  @"btn_round_beige_n.9.png"
#define CTL_RADIO_LIST_R_HIGH    @"btn_round_yellow_n.9.png"


#define CTL_RADIO_LIST_NORMAL   @"bt_nomal_n.9.png"
#define CTL_RADIO_LIST_HIGH     @"bt_nomal_o.9.png"

#define CTL_HISTORY_NORMAL      @"order_comhist_n.9.png"
#define CTL_HISTORY_HIGH        @"order_comhist_o.9.png"
#define CTL_MIC_NORMAL          @"ctl_item_voice_n.png"
#define CTL_MIC_HIGH            @"ctl_item_voice_o.png"
#define CTL_EDIT_BASIC          @"inputbox_n.9.png"
#define CTL_EDIT_BASIC_WHITE    @"inputbox_white_n.9.png"
#define CTL_EDIT_DISABLE        @"output.9.png"
#define CTL_CALENDAR_BASIC_NORMAL    @"inputbox_schedule_n.9.png"
#define CTL_CALENDAR_BASIC_HIGH      @"inputbox_schedule_o.9.png"
#define CTL_CALENDAR_DISABLE_NORMAL  @"inputbox_schedule_d.9.png"

#define CTL_TAB_SLIDELEFT_GREY	@"btn_prev_n.png"//@"tabarr02.png"
#define CTL_TAB_SLIDERIGHT_GREY	@"btn_next_n.png"//@"tabarr01.png"
#define CTL_TAB_HEADER_TOP		@"ctl_tab_hdr_top.9.png"
#define CTL_TAB_HEADER_NORMAL	@"tab_menu_n.9.png"
#define CTL_TAB_HEADER_HIGH		@"tab_menu_o.9.png"
#define CTL_TAB_HEADER_S		@"order_tab_o.9.png"
#define CTL_TAB_HEADER_B		@"order_tab2_o.9.png"
#define CTL_TAB_HEADER_C		@"order_tab3_o.9.png"
#define CTL_TAB_HEADER_O		@"order_tab4_o.9.png"
#define CTL_TAB_HEADER_L_NORMAL	@"tab_left_n.9.png"
#define CTL_TAB_HEADER_L_HIGH	@"tab_left_o.9.png"
#define CTL_TAB_HEADER_C_NORMAL	@"tab_middle_n.9.png"
#define CTL_TAB_HEADER_C_HIGH	@"tab_middle_o.9.png"
#define CTL_TAB_HEADER_R_NORMAL	@"tab_right_n.9.png"
#define CTL_TAB_HEADER_R_HIGH	@"tab_right_o.9.png"

#define CTL_TAB_HEADER_BLUE_HIGH	@"tab_middle_blue_o.9.png"
#define CTL_TAB_HEADER_BLUE         @"tab_middle_blue_o.9.png"
#define CTL_TAB_HEADER_RED_HIGH     @"tab_left_red_o.9.png"
#define CTL_TAB_HEADER_RED          @"tab_left_red_o.9.png"
#define CTL_TAB_HEADER_GREEN_HIGH	@"tab_right_green_o.9.png"
#define CTL_TAB_HEADER_GREEN        @"tab_right_green_o.9.png"
#define CTL_TAB_HEADER_VIOLET_HIGH	@"tab_right_violet_o.9.png"
#define CTL_TAB_HEADER_VIOLET       @"tab_right_violet_o.9.png"

//#define CTL_TAB_FIRST_NORMAL    @"tab_left_n.9.png"
//#define CTL_TAB_MID_NORMAL      @"tab_mid_n.9.png"
//#define CTL_TAB_LAST_NORMAL     @"tab_right_n.9.png"
#define CTL_TAB_HEADER_BG       @"tabbg.9.png"//@"title_bar101.png"//@"tab_bg_right.9.png"

#define CTL_TAB_HEADER_BG       @"tabbg.9.png"

#define CTL_COMBO_LIST			@"select01_n.9.png"//@"combo_list.9.png"
#define CTL_HISTORY_POPUP       @"pop_whitebg.9.png"//@"ctl_itm_his_bg_n.9.png"

#define CLOSE_FORMBUTTON_NORMAL @"bottom_btn_close_n.png"
#define CLOSE_FORMBUTTON_HIGH   @"bottom_btn_close_o.png"

#define STR_COMPONENT_NINE      @".9"

#define IMGDIC_NORMAL           @"normal"
#define IMGDIC_ACTIVE           @"active"
#define IMGDIC_DISABLE          @"disable"



#define GET_RESOURCE_COLOR(color) [[ResourceManager sharedManager] getColorfromIndex:color]



@interface ResourceManager : NSObject
{
	// THEME
	NSString				*ENCODING;
	// FONTName
	NSString				*m_sFontName;
    NSString				*m_sFontBoldName;
    NSString                *m_sNumericFontName;
	NSString                *m_sNumericFontBoldName;
    
	// Color Field
	NSMutableArray			*m_ColorList;
	NSInteger				mMaxPos;
	
	UIColor					*m_FormBgColor;
	UIColor					*m_WhiteColor;
	
	NSMutableDictionary		*m_dicImage;
	
    CGFloat                 m_defaultFontSize;
    
    CGFloat                 m_baseFontSize;

}

@property (nonatomic , strong ) UIColor  *m_FormBgColor;
//@property (nonatomic , strong ) NSString  *m_sTheme;
@property (nonatomic , strong ) NSString  *m_sFontName;
@property (nonatomic , strong ) NSString  *m_sFontBoldName;
@property (nonatomic , strong ) NSString  *m_sNumericFontName;
@property (nonatomic , strong ) NSString  *m_sNumericFontBoldName;
@property (nonatomic , strong ) UIFont    *m_defaultFont;
@property (nonatomic , strong ) UIFont    *m_defaultFontBold;
@property (nonatomic , strong ) UIFont    *m_defaultNumericFont;
@property (nonatomic , strong ) UIFont    *m_defaultNumericFontBold;
@property (nonatomic , strong ) UIFont    *m_defaultSignFont;
@property (nonatomic , strong ) NSString  *m_FontTheme;
@property (nonatomic , assign ) CGFloat   m_fLineHeight;


//+ (id)					alloc;
+ (ResourceManager *)	sharedManager;
+ (void)                exitManager;
- (id)					init;
- (void)				initProperty;
- (void)				setDefaultInstance;
- (void)                clearProperty;
- (void)                reloadProperty;

#pragma mark color methods
- (BOOL)				loadColorTable;
- (void)				initColorList;
//- (void)				setTheme:(NSString*) theme;

- (UIColor *)			getUpColor;
- (UIColor *)			getDownColor;
- (UIColor *)			getSteadyColor;
- (UIColor *)			getBasicTextColor;
- (UIColor *)			getBasicBackGroundColor;
- (UIColor *)           getPopupBasicBackgroundColor;
- (UIColor *)			getCellBackGroundColor;
- (UIColor *)           getInputDisableTextColor;
- (UIColor *)           getHelpTextColor;
- (UIColor *)           getTitleTextColor; 
- (UIColor *)           getPopupMessageTextColor; 
- (UIColor *)			getColorfromIntColor:(NSString *)intColor;
- (UIColor *)			getColorfromIndex:(NSInteger)nColorIndex;
- (UIColor *)			getColorfromFullColortext:(NSString *)ColorText;	// ColorText  ex) "000:154152123" 
- (void)				setFormBgColor:(NSString *)color;
- (UIColor *)			getFormBgColor;
- (NSString*)           makeStringKeyfromColor:(NSInteger)key;
- (CGRect)              getTextRectofSize:(CGSize)size forResource:(NSString *)name ofType:(NSString *)extension;
//-( CGRect)              getTextMarginOfResource:(NSString *)name ofType:(NSString *)extension;

#pragma mark image methods
//- (void)                setCacheImage:(UIImage*)image name:(NSString*)imageName;
- (void)				removeImage:(NSString *)ImageName;
- (UIImage*)            getUIImage:(NSString *)imageName imageOfSize:(CGSize)imgaeSize;
- (UIImage*)            getUIImage:(NSString *)imageName imageOfSize:(CGSize)imgaeSize isCache:(BOOL)isCache;
- (UIImage*)            getUICacheImage:(NSString *)imageName imageOfSize:(CGSize)imgaeSize;
- (void)                cleanImageCache;
//- (NSMutableDictionary*)getStateUIImage:(NSString *)imageName imageOfSize:(CGSize)imageSize
- (NSString*)           getImageFileName:(NSString*)imageName stateString:(NSString*)strState;
- (CGSize)              getUIImageSize:(NSString *)imageName;


#pragma mark font methods
- (NSString*)			getDefaultFontName;
- (NSString*)			getDefaultFontBoldName;
- (NSString*)           getNumericFontName;
- (NSString*)           getNumericFontBoldName;

- (UIFont*)				getDefaultFont;
- (UIFont*)             getDefaultFontBold;
- (UIFont*)				getDefaultNumericFont;
- (UIFont*)				getDefaultNumericFontBold;
- (NSInteger)           getFontsizeWithUnit:(NSInteger)Unit;
- (UIFont*)				getFontWithSize:(float)size;
- (UIFont*)				getFontWithUnit:(NSInteger)Unit;
- (UIFont*)				getFontBoldWithUnit:(NSInteger)Unit;
- (NSInteger)			getDefaultFontSize;
- (UIFont*)				getFontSizeInWithUnit:(NSString*)data width:(NSInteger)width Unit:(NSInteger)type;
- (UIFont*)				getFontBoldSizeInWithUnit:(NSString*)data width:(NSInteger)width Unit:(NSInteger)type;
- (UIFont*)             getNumericFontWithUnit:(NSInteger)Unit;
- (UIFont*)             getNumericFontBoldWithUnit:(NSInteger)Unit;
- (UIFont*)             getNumericFontSizeInWithUnit:(NSString*)data width:(NSInteger)width Unit:(NSInteger)type;
- (UIFont*)             getNumericFontBoldSizeInWithUnit:(NSString*)data width:(NSInteger)width Unit:(NSInteger)type;
- (UIFont*)             getNumbericFontWithSize:(CGFloat)size;
- (UIFont*)             getSignFontWithUnit:(NSInteger)nUnit;


- (UIFont*)getFontSizeInWithUnit:(NSString*)data size:(CGSize)size Unit:(NSInteger)type;
- (UIFont*)getFontBoldSizeInWithUnit:(NSString*)data  size:(CGSize)size Unit:(NSInteger)type;


- (NSArray *)           getFontSizeInfo:(CGFloat)dis_minus  :(CGFloat)dis_plus;
- (UIFont*)getFontBoldWithSize:(CGFloat)ftSize;
- (UIFont*)getFontBoldWithFont:(UIFont *) font;

- (CGSize) calcTextWidth:(NSString *) sText :(UIFont *)aFont;
@end
