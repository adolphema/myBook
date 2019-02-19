select * from user_deminsion_t

select downDeminsion(1001)

SELECT * from user_deminsion_t where FIND_IN_SET(deminsion_code,downDeminsion(1001));



-- 向上递归
DROP FUNCTION IF EXISTS upDeminsion;

CREATE FUNCTION upDeminsion(deminsionCode INT)
RETURNS VARCHAR(4000)
BEGIN
DECLARE sTemp VARCHAR(4000);
DECLARE sTempChd VARCHAR(4000);

SET sTemp='$';
SET sTempChd = CAST(deminsionCode AS CHAR);
SET sTemp = CONCAT(sTemp,',',sTempChd);


SELECT parent_code INTO sTempChd FROM user_deminsion_t WHERE deminsion_code = sTempChd;
WHILE sTempChd <> 0 DO
SET sTemp = CONCAT(sTemp,',',sTempChd);
SELECT parent_code INTO sTempChd FROM user_deminsion_t WHERE deminsion_code = sTempChd;
END WHILE;
RETURN sTemp;
END;

-- 向下递归

DROP FUNCTION IF EXISTS downDeminsion;

CREATE FUNCTION downDeminsion(deminsionCode INT)
RETURNS VARCHAR(4000)
BEGIN
DECLARE sTemp VARCHAR(4000);
DECLARE sTempChd VARCHAR(4000);

SET sTemp='$';
SET sTempChd = CAST(deminsionCode AS CHAR);

WHILE sTempChd IS NOT NULL DO
SET sTemp= CONCAT(sTemp,',',sTempChd);
SELECT GROUP_CONCAT(deminsion_code) INTO sTempChd FROM user_deminsion_t WHERE FIND_IN_SET(parent_code,sTempChd)>0;
END WHILE;
RETURN sTemp;
END;