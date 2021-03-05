package src;

#if debug
inline var DOMAIN = "localhost";
#else
inline var DOMAIN = "arbochelli.me";
#end
inline var DOMAIN_URL = 'https://${DOMAIN}/';
inline var COLLECT_URL = 'https://log.${DOMAIN}/api/collect';
