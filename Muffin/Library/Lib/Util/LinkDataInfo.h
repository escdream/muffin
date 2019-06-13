//
//  LinkDataInfo.h
//  SmartVIGS
//
//  Created by Kim juyoung on 11. 9. 23..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 *  LinkDataInfo.h
 *  SmartVIGS
 *
 *  Created by itgen on 11. 7. 14..
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#define     SESSION                 @"&SESSION"             // 로그인 세션
#define		USER_ID					@"&USER_ID"				// 사용자 아이디
#define		USER_PWD				@"&USER_PWD"			// 비밀번호	
#define		JUMIN_NO				@"&JUMIN_NUM"			// 주민번호
#define		USER_NAME				@"&USER_NAME"			// 사용자 명
#define		LOGIN_TYPE				@"&LOGIN_TYPE"			// 로그인타입    ( 0 , 비고객 , 1 4 시세전용 로그인 , 5 공인인증 로그인
#define		ACCOUNT_NO				@"&ACCOUNT"				// 계좌번호
#define     ACCOUNT_NAME            @"&ACCOUNT_NAME"        // 계좌번호 이름
#define     ACCOUNT_CAPTION         @"&ACCOUNT_CAPTION"     // 계좌번호 연동
#define		ACCOUNT_PWD				@"&ACCOUNT_PWD"			// 계좌비밀번호
#define     ACCOUNT_INFO            @"&ACCOUNT_INFO"
#define     USER_CERT_DN            @"&USER_CERT_DN"        // 사용자 DN값
#define     USER_CERT_PASSWORD      @"&USER_CERT_PASSWORD"  // 사용자 공인인증 비밀번호
#define     USER_CERT_STATUS        @"&USER_CERT_STATUS"    // 사용자 DN 상태
#define     USER_CERT_COUNT         @"&USER_CERT_COUNT"     // 사용사 DN 오류 카운트
#define     LOGIN_TIME              @"&LOGIN_TIME"          // 로그인 시간

#define     USER_CERT_DN2           @"&USER_CERT_DN2"        // H_FullSignAuto 처리용
#define     USER_CERT_PASSWORD2     @"&USER_CERT_PASSWORD2"  //


#define		ACCOUNT_CTL				@"&CTLACCOUNT"			// 계좌컨트롤 계좌번호 자동변경용
#define		STOCK_ITEMCODE			@"&ITEM_CODE"			// 주식종목코드
#define		ORDER_QUANTITY			@"&ORDER_QUANTITY"		// 거래수량
#define		ORDER_PRICE				@"&ORDER_PRICE"			// 거래 단가
#define		ORDER_TYPE				@"&ORDER_TYPE"			// 거래 유형
#define		ORDER_PWD				@"&ORDER_PWD"			// 이용자 비밀번호
#define		ORDER_PWD_CONFIRM		@"&ORDER_PWD_CONFIRM"	// 이용자 비밀번호 확인여부
#define		GWANSIM_GROUP			@"&GWANSIM_GROUP"		// 관심그룹
#define		GWANSIM_IMPORTED		@"&GWANSIM_IMPORTED"	// 관심 가져오기됨
#define		HOST_DATE				@"&HOST_DATE"			// 서버 날짜
#define		HOST_TIME				@"&HOST_TIME"			// 서버 시간
#define     TRADE_START_TIME        @"&TRADE_START_TIME"    // 장 시작 시간
#define     TRADE_END_TIME          @"&TRADE_END_TIME"      // 장 종료 시간
#define     WORKING_DAY             @"&WORKING_DAY"         // 현재 영업일
#define     PRE_WORKING_DAY         @"&PRE_WORKING_DAY"     // 전 영업일
#define     PREPRE_WORKING_DAY      @"&PREPRE_WORKING_DAY"  // 전전 영업일
#define     NEXT_WORKING_DAY        @"&NEXT_WORKING_DAY"    //익 영업일
#define     NEXTNEXT_WORKING_DAY    @"&NEXTNEXT_WORKING_DAY"// 익익 영업일
#define     BASKET_SERVER           @"&BASKET_SERVER"       ///< 바스켓 서버 저장 여부
#define     BASKET_REQUEST          @"&BASKET_REQUEST"      ///< 바슷켓 최초 저장
#define     INFO_HTML_URL           @"TEMP_INFO_HTML_URL"   ///< 임시 HTML URL
#define     BASE_URL                @"&BASE_URL"            ///< 기본 URL

#define     TERM_ID                 @"&TERM_ID"             // 터미널 ID
#define		PHONE_NUMBER			@"&PHONE_NUMBER"		// 전화번호
#define     MEDIA_TYPE              @"&MEDIA_TYPE"          // 미디어 타입 IOS 'l' ANDROID 'L'
#define		MEDIA_CODE_ORDER		@"&MEDIA_CODE"			// 매체코드
#define		MEDIA_CODE_CONN			@"&MEDIA_CODE_CONN"		// 접속매체코드
#define		CLIENT_IP               @"&CLIENT_IP"           // 접속 IP
#define     PUBLIC_IP               @"&PUBLIC_IP"           // 공인 IP
#define		APP_TYPE                @"&APP_TYPE"			// 앱유형 
#define		APP_VERSION             @"&APP_VERSION"         // 앱버전
#define     APP_NEW_VERSION         @"&APP_SERVER_VERSION"  // 앱 최신버전 ( 서버 )
#define		NOTICE_VERSION          @"&NOTICE_VERSION"         // 공지버전
#define		DEVICE_MODEL            @"&DEVICE_MODEL"        // 모델명  
#define		CONN_STATE              @"&CONN_STATE"          // 통신상태  
#define		CONN_SEVER              @"&CONN_SEVER"          // 접속상태  
#define     LAST_SCREEN_NO          @"&SCREEN_NO"           // 현재 열린 화면 번호
#define     PREV_SCREEN_NO          @"&PREV_SCREEN_NO"      // 직전에 열렸던 화면 번호
#define     TEST_MODE               @"&TEST_MODE"           // 테스트용 앱인지, 배포용앱인지 구분
#define     DUPLICATE_EXC           @"&DUP_EXC"             // 이중접속 허용구분
#define     MAC_ADDRESS             @"&MAC_ADDRESS"         // 맥 주소
#define     PUSH_ID                 @"&PUSH_ID"             // 푸쉬 아이디
#define     PUSH_ID_HEX             @"&PUSH_ID_HEX"         /// <푸쉬 아이디 헥사 값


#define		UNIQ_INFO_1				@"&UNIQ_INFO_1"           // 기기 식별자1
#define		UNIQ_INFO_2				@"&UNIQ_INFO_2"           // 기기 식별자2
#define		OS_TYPE					@"&OS_TYPE"				// OS 구분 2:iOS 1:안드
#define		OS_VERSION				@"&OS_VERSION"			// Device OS Version
#define		CUST_TYPE				@"&CUST_TYPE"			// 고객정보 (1:준회원, 2:정회원)
#define     CUST_NUM                @"&CUST_NUM"            // 고객 번호
#define     CUST_ID                 USER_ID // @"cnnctId"              // 고객 아이디
#define     OS_IPHONE_X              @"&OS_IPHONE_X"              // iphonex 구분



#define     SCREEN_FILE             @"&SCREEN_FILE"         // 메뉴코드(화면파일)
#define     SCREEN_NAME             @"&SCREEN_NAME"         // 메뉴명

#define     PERSON_CORP             @"&PERSON_CORP"         // 개인법인 구분코드 01 개인 02 법인 03 등록 단체 04 임의단체
#define     FOREIGN_TYPE            @"&FOREIGN_TYPE"        // 내외국인 구분 01 내국인
#define     AGE_65                  @"&AGE_65"              // 나이 65세 이상여부 Y 이상 N 이하
#define     BRITH_DATE              @"&BIRTH_DATE"          // 생년 월일

#define		NULL_DATA				@"" 
#define     SPACE_DATA              @" "


#define     SPIN_ID                 @"&SPIN_ID"             // OneShotPad 아이디
#define     SPIN_CERT_NO            @"&SPIN_CERT_NO"        // OneShotPad 인증서 번호
#define     SPIN_CERT_DN            @"&SPIN_CERT_DN"        // OneShotPad 인증서 번호
#define     SPIN_CERT_PASS          @"&SPIN_CERT_PASS"        // OneShotPad 인증서 번호


//#define		USER_FOLDER				@"user/"
//#define		SYSTEM_FOLDER			@"res/"//@"system/"
#define		ITEMHISTORY_ARCHIVEKEY  @"ITEMLINKDATA"
#define		MARKET_SIZE				4
#define		NEW_LINE				@"\n"

#define		MARKET_STOCK			@"주식"
#define		MARKET_ETF				@"ETF"
#define		MARKET_ELW				@"ELW"
#define		MARKET_FUTURE			@"선물"
#define		MARKET_OPTION			@"옵션"
#define		INIT_DATE_FORMAT		@"yyyyMMddHHmmss"

#define		INTR_NONAME				@"#이름없는 그룹#"

#define     DEVICE_INFO             @"&DEVICE_INFO"         // DEVICE_ID UUID

