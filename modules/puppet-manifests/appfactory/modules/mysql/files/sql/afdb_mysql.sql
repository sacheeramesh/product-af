-- Start of AF tables --
CREATE TABLE IF NOT EXISTS AF_APPLICATION (
	ID INT(11) AUTO_INCREMENT,
	APPLICATION_KEY VARCHAR(19) NOT NULL,
	APPLICATION_NAME VARCHAR(50) NOT NULL,
	TENANT_ID INT(5) NOT NULL,
	STATUS VARCHAR(10) NOT NULL DEFAULT 'PENDING',
	PRIMARY KEY(ID),
	UNIQUE (APPLICATION_KEY,TENANT_ID),
        INDEX  (APPLICATION_KEY, TENANT_ID)
);

CREATE TABLE IF NOT EXISTS AF_VERSION (
	ID INT(11) AUTO_INCREMENT,
	APPLICATION_ID INT(11) NOT NULL,
	VERSION_NAME VARCHAR(10) NOT NULL,
	STAGE VARCHAR(20) DEFAULT 'Development',
	PROMOTE_STATUS VARCHAR(20) NULL,
	AUTO_BUILD TINYINT(1) DEFAULT 1,
	AUTO_DEPLOY TINYINT(1) DEFAULT 1,
        SUBDOMAIN VARCHAR(50) NULL,
        TENANT_ID INT(5) NOT NULL,
	FOREIGN KEY(APPLICATION_ID) REFERENCES AF_APPLICATION(ID) ON UPDATE CASCADE ON DELETE RESTRICT,
	PRIMARY KEY(ID),
        UNIQUE (VERSION_NAME,APPLICATION_ID),
        INDEX (APPLICATION_ID, VERSION_NAME)
);

CREATE TABLE IF NOT EXISTS AF_REPOSITORY (
	ID INT(11) AUTO_INCREMENT,
        VERSION_ID INT(11) NOT NULL,
        IS_FORKED TINYINT(1) DEFAULT 0,
	GIT_USER_ID VARCHAR(50) NULL,
        TENANT_ID INT(5) NOT NULL,
        FOREIGN KEY(VERSION_ID) REFERENCES AF_VERSION(ID) ON UPDATE CASCADE ON
        DELETE RESTRICT,
        PRIMARY KEY(ID),
        INDEX (VERSION_ID, IS_FORKED)
);

CREATE TABLE IF NOT EXISTS AF_BUILD (
        ID INT(11) AUTO_INCREMENT,
        REPOSITORY_ID INT(11) NOT NULL,
        LAST_BUILD_ID VARCHAR(10) NULL,
        LAST_BUILD_STATUS VARCHAR(10) NULL,
        LAST_BUILD_TIME TIMESTAMP NULL,
        TENANT_ID INT(5) NOT NULL,
        FOREIGN KEY(REPOSITORY_ID) REFERENCES AF_REPOSITORY(ID) ON UPDATE CASCADE ON DELETE RESTRICT,
        PRIMARY KEY(ID),
        INDEX (REPOSITORY_ID)
);

CREATE TABLE IF NOT EXISTS AF_DEPLOY (
        ID INT(11) AUTO_INCREMENT,
        REPOSITORY_ID INT(11) NOT NULL,
        LAST_DEPLOYED_BUILD_ID VARCHAR(10) NULL,
        LAST_DEPLOY_STATUS VARCHAR(15) NULL,
        LAST_DEPLOY_TIME TIMESTAMP NULL,
        ENVIRONMENT VARCHAR(20) NULL,
        TENANT_ID INT(5) NOT NULL,
        FOREIGN KEY(REPOSITORY_ID) REFERENCES AF_REPOSITORY(ID) ON UPDATE CASCADE ON DELETE RESTRICT,
        PRIMARY KEY(ID),
        INDEX (REPOSITORY_ID)
);

CREATE TABLE IF NOT EXISTS AF_RESOURCE (
        ID INT(11) AUTO_INCREMENT,
        APPLICATION_ID INT(11) NOT NULL,
        RESOURCE_TYPE VARCHAR(50) NOT NULL,
        RESOURCE_NAME VARCHAR(50) NOT NULL,
        ENVIRONMENT VARCHAR(20) NOT NULL,
        DESCRIPTION VARCHAR(2000) NOT NULL,
        TENANT_ID INT(5) NOT NULL,
        FOREIGN KEY(APPLICATION_ID) REFERENCES AF_APPLICATION(ID) ON UPDATE CASCADE ON DELETE RESTRICT,
        INDEX (APPLICATION_ID),
        INDEX (RESOURCE_TYPE ASC, ENVIRONMENT ASC),
        PRIMARY KEY(ID)
);

CREATE TABLE IF NOT EXISTS AF_CARTRIDGE_CLUSTER (
  ID INT(11) AUTO_INCREMENT,
  CLUSTER_ID VARCHAR(100) NOT NULL,
  LB_CLUSTER_ID VARCHAR(11),
  ACTIVE_IP VARCHAR(20) NOT NULL,
  PRIMARY KEY(ID),
  TENANT_ID INT(5) NOT NULL,
  UNIQUE(CLUSTER_ID),
  INDEX (CLUSTER_ID)
);

CREATE TABLE IF NOT EXISTS AF_FAILED_APPLICATION (
        APPLICATION_KEY VARCHAR(100) NOT NULL,
        TENANT_ID INTEGER NOT NULL,   
        CREATE_START_TIME TIMESTAMP NULL,
        PRIMARY KEY(APPLICATION_KEY, TENANT_ID)
);
-- End of AF tables --

