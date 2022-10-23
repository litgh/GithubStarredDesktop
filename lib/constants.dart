const String CLIENT_ID = '38285bfcab2c60022731';
// const String CLIENT_ID =
//     'ec77b1a73edfdd350b2025dd0e0de2caa1de8b5966ccca7ce653cd98c55c2f7c';
const String CLIENT_SECRET = 'df069d6bee7c7297241398f4547ca0a65380a5dc';
// const String CLIENT_SECRET =
//     'c055cc7cd779a8492d741fcbcd56f34ab66679c71f20a40a867256879724ccc1';
const String REDIRECT_URL = 'flutterGithub://login';
const String AUTHORIZATION_URL =
    'https://github.com/login/oauth/authorize?client_id=$CLIENT_ID&redirect_uri=$REDIRECT_URL&scope=user%20repo%20notifications%20';
    // 'https://gitee.com/oauth/authorize?client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URL}&response_type=code&scope=user_info';
