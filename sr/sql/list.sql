-- ///////////////////////创建系统用户table///////////////
DROP TABLE IF EXISTS suser;
CREATE TABLE IF NOT EXISTS suser  (
    sn       INTEGER,     --用户序号
    no       TEXT,        --用户名
    name     TEXT,        --姓名
    idn      TEXT,        --证件号
    pwd      TEXT,        --密码
    enrolled DATE,        --注册日期
    PRIMARY KEY(sn)
);

-- 给sn创建一个自增序号
CREATE SEQUENCE seq_suser_sn 
    START 1000 INCREMENT 1 OWNED BY suser.sn;
ALTER TABLE suser ALTER sn 
    SET DEFAULT nextval('seq_suser_sn');
-- 用户名唯一
CREATE UNIQUE INDEX idx_suser_no ON suser(no);
--///////////////////////创建客户table///////////////////////
DROP TABLE IF EXISTS client;
CREATE TABLE IF NOT EXISTS client  (
    sn       INTEGER,     --客户序号   
    name     TEXT,        --姓名
    age      INTEGER,     --年龄
    gender   CHAR(1),     --性别性别(F/M/O)
    address  TEXT,        --地址
    mphone   VARCHAR(20), --手机
    phone    VARCHAR(20), --固话
    remark   TEXT,        --备注
    img      TEXT,        --图片地址
    enrolled DATE,        --注册日期
    PRIMARY KEY(sn)
);

-- 给sn创建一个自增序号
CREATE SEQUENCE seq_client_sn 
    START 10000 INCREMENT 1 OWNED BY client.sn;
ALTER TABLE client ALTER sn 
    SET DEFAULT nextval('seq_client_sn');
-- 姓名唯一
CREATE UNIQUE INDEX idx_client_no ON client(name);

--//////////////////////////商品talbe/////////////////////
DROP TABLE IF EXISTS goods;
CREATE TABLE IF NOT EXISTS goods  (
    sn       INTEGER,     --商品序号   
    no       TEXT,        --商品编号
    name     TEXT,        --商品名称
    unit     VARCHAR(3),  --单位
    cost     NUMERIC(6,2),--成本
    prict    NUMERIC(6,2),--售价
    position TEXT,        --位置
    enrolled DATE,        --注册日期
    PRIMARY KEY(sn)
);

-- 给sn创建一个自增序号
CREATE SEQUENCE seq_goods_sn 
    START 100000 INCREMENT 1 OWNED BY goods.sn;
ALTER TABLE goods ALTER sn 
    SET DEFAULT nextval('seq_goods_sn');
-- 姓名唯一
CREATE UNIQUE INDEX idx_goods_no ON goods(no);
--//////////////////////////供应商/////////////////////////////


--//////////////////////////采购单//////////////////////////////////
DROP TABLE IF EXISTS goods_purchase;
CREATE TABLE IF NOT EXISTS goods_purchase  (
    goods_sn INTEGER,     -- 商品序号
    num      INTEGER,     -- 数量
    unit     VARCHAR(3),  -- 单位
    spec     TEXT,        -- 规格
    remark   TEXT,        -- 备注
    enrolled DATE,        --注册日期
    PRIMARY KEY(goods_sn)
);

ALTER TABLE goods_purchase 
    ADD CONSTRAINT goods_sn_fk FOREIGN KEY (goods_sn) REFERENCES goods(sn);

--//////////////////////////销售单//////////////////////////////////
DROP TABLE IF EXISTS sell;
CREATE TABLE IF NOT EXISTS sell  (
    sn        INTEGER,     -- 销售单号
    client_sn INTEGER,     -- 客户序号    
    sum       NUMERIC(10,2), --金额
    enrolled DATE,           --销售日期
    PRIMARY KEY(sn)
);
-- 给sn创建一个自增序号
CREATE SEQUENCE seq_sell_sn 
    START 1000000 INCREMENT 1 OWNED BY sell.sn;
ALTER TABLE sell ALTER sn 
    SET DEFAULT nextval('seq_sell_sn');

ALTER TABLE sell 
    ADD CONSTRAINT client_sn_fk FOREIGN KEY (client_sn) REFERENCES client(sn);
--//////////////////////////销售商品//////////////////////////////////
DROP TABLE IF EXISTS goods_sell;
CREATE TABLE IF NOT EXISTS goods_sell  (
    sell_sn   INTEGER,     -- 销售单号
    goods_sn  INTEGER,     -- 商品序号  
    num       INTEGER,     -- 数量
    unit      VARCHAR(3),  -- 单位
    mon       NUMERIC(10,2), --金额    
    PRIMARY KEY(sell_sn,goods_sn)
);

ALTER TABLE goods_sell 
    ADD CONSTRAINT sell_sn_fk FOREIGN KEY (sell_sn) REFERENCES sell(sn);
ALTER TABLE goods_sell 
    ADD CONSTRAINT goods_sn_fk FOREIGN KEY (goods_sn) REFERENCES goods(sn);
--//////////////////////////退货单//////////////////////////////////
DROP TABLE IF EXISTS goods_return;
CREATE TABLE IF NOT EXISTS goods_return  (
    client_sn   INTEGER,   -- 客户序号
    goods_sn  INTEGER,     -- 商品序号  
    num       INTEGER,     -- 数量
    unit      VARCHAR(3),  -- 单位
    mon       NUMERIC(10,2), --金额
    enrolled DATE,           --退货日期
    PRIMARY KEY(client_sn,goods_sn)
);

ALTER TABLE goods_return 
    ADD CONSTRAINT client_sn_fk FOREIGN KEY (client_sn) REFERENCES client(sn);
ALTER TABLE goods_return 
    ADD CONSTRAINT goods_sn_fk FOREIGN KEY (goods_sn) REFERENCES goods(sn);
