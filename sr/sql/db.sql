DROP DATABASE IF EXISTS srdb;

DROP ROLE IF EXISTS srdbo; 

-- 创建一个登陆角色（用户），用户名srdbo, 缺省密码pass
CREATE ROLE srdbo LOGIN
  ENCRYPTED PASSWORD 'md568cefad35fed037c318b1e44cc3480cf' -- password: pass
  NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE;

CREATE DATABASE srdb WITH OWNER = srdbo ENCODING = 'UTF8';


