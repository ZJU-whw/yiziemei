function encodeAesString(data){
    var key_show = '7DWxxYrl6VzCX5aZ'; // 密钥 长度16
    var iv_show = 'Ghqwhpy3kIDmWx8l'; // 密钥 长度16
    var key = CryptoJS.enc.Utf8.parse(key_show);
    var iv = CryptoJS.enc.Utf8.parse(iv_show);
    var encrypted =CryptoJS.AES.encrypt(data,key,{
        iv:iv,
        mode:CryptoJS.mode.CBC,
        padding:CryptoJS.pad.Pkcs7
    });
    //返回的是base64格式的密文（ajax提交时报错，这里前后加上逗号处理）
    return "," + encrypted + ","
}

// encrypted 为是base64格式的密文
function decodeAesString(encrypted,key,iv){
    var key = CryptoJS.enc.Utf8.parse(key);
    var iv = CryptoJS.enc.Utf8.parse(iv);
    var decrypted =CryptoJS.AES.decrypt(encrypted,key,{
        iv:iv,
        mode:CryptoJS.mode.CBC,
        padding:CryptoJS.pad.Pkcs7
    });
    return decrypted.toString(CryptoJS.enc.Utf8);
}