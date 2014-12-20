#ifndef __MIG_CHAT_COMM_HEAD_H__
#define __MIG_CHAT_COMM_HEAD_H__
//#include <list>
//#include <string>
#include<stdio.h>
#include<stdint.h>
#define  TOKEN_LEN 32
#define  NICKNAME_LEN 48
#define  HEAD_URL_LEN 256



enum errorcode{
	PLATFORM_ID_NOT_EXIST = 1,
	USER_ID_NOST_EXIST = 2
};

enum operatorcode
{
	PACKET_CONFIRM = 200,
	HEART_PACKET = 100,
	CHAT_ERROR = 300,
	USER_LOGIN = 1000,
	USER_LOGIN_SUCESS = 1001,
	USER_LOGIN_FAILED = 1002,
	USER_QUIT = 1010,
	USER_NOTIFICATION_QUIT = 1011,
	REQ_OPPOSITION_INFO = 1020,
	GET_OPPOSITION_INFO = 1021,
    USER_ONLINE_REQ = 1030,
    USER_ONLINE_RSP = 1031,
	TEXT_CHAT_PRIVATE_SEND = 1100,
	TEXT_CHAT_PRIVATE_RECV = 1101,
    MULTI_SOUND_SEND = 2100,
    MULTI_SOUND_RECV = 2101,
    MULTI_CHAT_SEND = 2200,
    MULTI_CHAT_RECV = 2201
};

enum msgtype
{
	ERROR_TYPE = 0,
	USER_TYPE = 1,
	CHAT_TYPE = 2,
};

#pragma pack (1)
struct PacketHead{
   int32_t packet_length;
   int32_t operate_code;
   int32_t data_length;
   int32_t current_time;
   int16_t msg_type;
   int8_t  is_zip;
   int64_t msg_id;
   int32_t reserverd;
}; //31
#pragma pack()

#define PACKET_HEAD_LENGTH (sizeof(struct PacketHead))
#define PACKET_HEAD_TO_DATA(DATA) ((uint8_t*)DATA + PACKET_HEAD_LENGTH)

//PACKET_CONFIRM = 100
#define PACKET_CONFIRM_SIZE (sizeof(PacketConfirm))
#pragma pack (1)
struct PacketConfirm
{
	int64_t platform_id;
	int64_t send_user_id;
	int64_t recv_user_id;
	int64_t session_id;
	char token[TOKEN_LEN];
};
#pragma pack()
//USER_LOGIN = 1000

#pragma pack (1)
struct UserLogin
{
    struct  PacketHead  packet_head;
            int64_t     platform_id;
            int64_t     user_id;
            int8_t      net_type;
            int8_t      user_type;
            int8_t      device;
            char        token[TOKEN_LEN];
};
#pragma pack()
#define USER_LOGIN_SIZE  (sizeof(struct UserLogin))
//USER_LOGIN_SUCESS = 1001
#define USER_LOGIN_SUCESS_SIZE  (sizeof(UserLoginSucess))
#pragma pack (1)
struct UserLoginSucess
{
    struct  PacketHead  packet_head;
	int64_t platform_id;
    int64_t user_id;
	int64_t nick_number;
	char token[TOKEN_LEN];
	char nickname[NICKNAME_LEN];
	char head_url[HEAD_URL_LEN];
};
#pragma pack()
//USER_LOGIN_FAILED = 1002
#define USER_LOGIN_FAILED_SIZE
#pragma pack (1)
struct ChatFailed{
	int64_t platform_id;
	char* error_msg;
};
#pragma pack()
//USER_QUIT = 1010

#define USER_QUIT_LOGIN_SIZE  (sizeof(struct UserQuit))
#pragma pack (1)
struct UserQuit{
     struct  PacketHead     packet_head;
            int64_t         platform_id;
            int64_t         user_id;
            int64_t         session;
            char            token[TOKEN_LEN];
};
#pragma pack()
//USER_NOTIFICATION_QUIT = 1011
#define USER_NOTIFICATION_QUIT_SIZE (sizeof(UserQuitNotification))
#pragma pack (1)
struct UserQuitNotification{
    struct  PacketHead     packet_head;
	int64_t platform_id;
	int64_t user_id;
};
#pragma pack()
//REQ_OPPOSITION_INFO = 1020
#define REQ_OPPOSITION_INFO_SIZE (sizeof(struct ReqOppstionInfo))
#pragma pack (1)
struct ReqOppstionInfo {
    struct  PacketHead  packet_head;
                int64_t platform_id;
                int64_t user_id;
                int64_t oppostion_id;
                int16_t type;
                char    token[TOKEN_LEN];
};
#pragma pack()
#define OPPINFO_SIZE (sizeof( struct Oppinfo))
#pragma pack (1)
struct Oppinfo
{
	int64_t user_id;
	int64_t user_nicknumber;
	char nickname[NICKNAME_LEN];
	char user_head[HEAD_URL_LEN];

};
#pragma pack()
//GET_OPPOSITION_INFO = 1021
#define OPPSITIONINFO_SIZE (sizeof( struct OppositionInfo))
#pragma pack (1)
struct OppositionInfo {
    struct  PacketHead  packet_head;
    int64_t platform_id;
	int64_t oppo_id;
	int64_t oppo_nick_number;
	int64_t session;
	int16_t oppo_type;
	char  oppo_nickname[NICKNAME_LEN];
	char  oppo_user_head[HEAD_URL_LEN];
	//std::list<struct Oppinfo*> opponfo_list;
};
#pragma pack ()

//TEXT_CHAT_PRIVATE_SEND = 1100
#define TEXTCHATPRIVATESEND_SIZE
#pragma pack (1)
struct TextChatPrivateSend{
    struct  PacketHead  packet_head;
            int64_t platform_id;
            int64_t send_user_id;
            int64_t recv_user_id;
            int64_t session;
            char    token[TOKEN_LEN];
};
#pragma pack()
//TEXT_CHAT_PRIVATE_RECV = 1101
#define TEXTCHATPRIVATERECV_SIZE
#pragma pack (1)
struct TextChatPrivateRecv{
    struct  PacketHead  packet_head;
            int64_t platform_id;
            int64_t send_user_id;
            int64_t recv_user_id;
};
#pragma pack()
#pragma pack (1)
struct ReplyChatPrivate{
    struct  PacketHead  packet_head;
    int64_t platform_id;
    int64_t send_user_id;
    int64_t recv_user_id;
    int64_t msg_id;
    int64_t session;
    char    token[TOKEN_LEN];
};
#pragma pack()
//USER_ONLINE_REQ = 1030
#define USERONLINEREQ_SIZE
#pragma pack (1)
struct UserOnLineReq{
    struct  PacketHead  packet_head;
    int64_t platform_id;
    int64_t group_id;
    int64_t user_id;
    char    token[TOKEN_LEN];
};
#pragma pack()

//USER_ONLINE_RSP = 1031
#define USERONLINERSP_SIZE
#pragma pack (1)
struct UserOnLineRsp{
    struct  PacketHead  packet_head;
    int64_t platform_id;
    int64_t group_id;
    int64_t user_id;
    int64_t user_nicknumber;
    char  nickname[NICKNAME_LEN];
    char  user_head[HEAD_URL_LEN];
};
#pragma pack()

//MULTI_CHAT_SEND = 2200,
#define MULTICHATSEND_SIZE
#pragma pack (1)
struct MultiChatSend{
    struct PacketHead packet_head;
    int64_t platform_id;
    int64_t multi_id;
    int64_t send_user_id;
    int64_t session;
    char  token[TOKEN_LEN];
};
#pragma pack()
// MULTI_CHAT_RECV = 2201
#define MULTICHATRECV_SIZE
#pragma pack (1)
struct MultiChatRecv{
    struct PacketHead packet_head;
    int64_t platform_id;
    int64_t multi_id;
    int64_t send_user_id;
    char  nickname[NICKNAME_LEN];
};
#pragma pack()





#define FACE_REGULAR @"\\[/(([0-9]{1,2})|(10[0-4]))\\]"


#define MSG_CELL_MIN_HEIGHT 80

#define MSG_VIEW_MIN_HEIGHT 25


#define KFacialSizeWidth    20

#define KFacialSizeHeight   20

#define KCharacterWidth     8


#define VIEW_LINE_HEIGHT    24

#define VIEW_LEFT           25

#define VIEW_RIGHT          16

#define VIEW_TOP            8


#define VIEW_WIDTH_MAX      186
#define FACE_NAME_HEAD  @"[/"
#define FACE_NAME_END  @"]"

#define MSG_VIEW_LEFT   52

#define MSG_VIEW_RIGHT  270

#define MSG_VIEW_TOP    23

#define MSG_VIEW_BOTTOM 8


#define NEW_MSGVIEW

#endif
