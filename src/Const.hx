package src;

inline final DOMAIN = #if debug "localhost"; #else "arbochelli.me"; #end
inline final SHORT_DOMAIN = #if debug "a.localhost"; #else "aa.art.br"; #end
inline final DOMAIN_URL = 'https://${DOMAIN}/';
inline final SHORT_DOMAIN_URL = 'https://${SHORT_DOMAIN}/';
inline final COLLECT_URL = 'https://log.${SHORT_DOMAIN}/api/collect';
inline final FEED_URL = DOMAIN_URL + "static/yt-rss.xml";
