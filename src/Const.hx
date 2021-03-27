package src;

#if debug
inline final DOMAIN = "localhost";
#else
inline final DOMAIN = "arbochelli.me";
#end
inline final DOMAIN_URL = 'https://${DOMAIN}/';
inline final COLLECT_URL = 'https://log.${DOMAIN}/api/collect';
inline final FEED_URL = DOMAIN_URL + "static/yt-rss.xml";
