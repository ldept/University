
-- CREATE TABLES
CREATE TABLE IF NOT EXISTS Member (
    id bigint PRIMARY KEY,
    password varchar(128) NOT NULL,
    is_leader BOOLEAN NOT NULL DEFAULT FALSE,
    last_activity timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS Authority (
    id bigint PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS Project (
    id bigint PRIMARY KEY,
    authority_id bigint,
    FOREIGN KEY (authority_id) REFERENCES Authority(id) 
);

CREATE TABLE IF NOT EXISTS Action (
    id bigint PRIMARY KEY,
    type varchar(10),
    upvotes bigint,
    downvotes bigint,
    member_id bigint,
    project_id bigint,
    FOREIGN KEY (member_id) REFERENCES Member(id),
    FOREIGN KEY (project_id) REFERENCES Project(id)
);

CREATE TABLE IF NOT EXISTS Vote (
    action_id bigint,
    member_id bigint,
    vote bigint,
    FOREIGN KEY (action_id) REFERENCES Action(id),
    FOREIGN KEY (member_id) REFERENCES Member(id)
);

-- BEHIND-THE-SCENES FUNCTIONS
CREATE OR REPLACE FUNCTION is_unique(ide bigint) RETURNS BOOLEAN
AS $X$
BEGIN
    IF ide NOT IN (
    SELECT id FROM Member UNION
    SELECT id FROM Action UNION
    SELECT id FROM Project UNION
    SELECT id FROM Authority) THEN RETURN TRUE;
    ELSE RETURN FALSE;
    END IF;
END
$X$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_passwd_correct(mem bigint, passwd varchar(128)) RETURNS BOOLEAN
AS $X$
BEGIN
    IF (SELECT COUNT(*) FROM Member WHERE id = mem AND password = crypt(passwd,password)) = 1
    THEN RETURN TRUE;
    ELSE RETURN FALSE;
    END IF;
END
   -- RETURN (SELECT COUNT(*) FROM Member WHERE id = mem AND password = crypt(passwd,password))::BOOLEAN;
$X$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION is_not_frozen(mem bigint, t timestamp) RETURNS BOOLEAN
AS $X$
DECLARE last_time TIMESTAMP;
BEGIN
    last_time = (SELECT last_activity FROM member WHERE id = mem);
    IF t BETWEEN last_time AND last_time + interval '1 year'
    THEN RETURN TRUE;
    ELSE RETURN FALSE;
    END IF; 
END
$X$ LANGUAGE plpgSQL;


-- API FUNCTIONS
CREATE OR REPLACE FUNCTION leader(t timestamp, passwd varchar(128), mem bigint) RETURNS BOOLEAN
AS $X$
BEGIN
    IF is_unique(mem) THEN
    BEGIN
        INSERT INTO Member VALUES (mem,crypt(passwd, gen_salt('bf')), TRUE, t);
        RETURN TRUE;
    END;
    ELSE RETURN FALSE;
    END IF;
END
$X$ LANGUAGE plpgSQL;


-- MEMBER FUNCTIONS

-- These need to have optional <AUTHORITY> argument
-- IF project(id) exists then cool,
-- IF NOT then authority must not be NULL and we need to add a project (and authority if it does not exist) 
CREATE OR REPLACE FUNCTION support(t timestamp, mem bigint, passwd varchar(128), act bigint, pro bigint, auth bigint DEFAULT NULL) RETURNS BOOLEAN
AS $X$
DECLARE
    add_auth BOOLEAN := FALSE; --DEFAULT FALSE;
    add_pro BOOLEAN := FALSE;--DEFAULT FALSE;
BEGIN
    IF auth IS NOT NULL
    THEN
        BEGIN
            IF is_unique(act) AND mem <> act AND act <> pro AND mem <> pro AND mem <> auth AND act <> auth AND pro <> auth
            THEN 
                BEGIN
                    IF pro NOT IN (SELECT id FROM project) 
                        THEN IF is_unique(pro)
                            THEN
                                BEGIN
                                    IF auth NOT IN (SELECT id FROM authority)
                                        THEN IF is_unique(auth) THEN add_auth = TRUE;
                                            ELSE RETURN FALSE; END IF;--INSERT INTO authority VALUES (auth);
                                    END IF;
                                    add_pro = TRUE;--INSERT INTO project VALUES (pro,auth);
                                END;
                            ELSE RETURN FALSE; 
                            END IF;
                    END IF;
                    IF mem IN (SELECT id FROM member)
                    THEN
                        IF (is_passwd_correct(mem,passwd) AND is_not_frozen(mem,t))
                        THEN UPDATE Member SET last_activity = t WHERE id = mem;
                        ELSE RETURN FALSE;
                        END IF;
                    ELSE IF is_unique(mem) 
                        THEN INSERT INTO member VALUES (mem, crypt(passwd, gen_salt('bf')), FALSE, t);
                        ELSE RETURN FALSE;
                        END IF;
                    END IF;
                    IF add_auth THEN INSERT INTO authority VALUES (auth); END IF;
                    IF add_pro THEN INSERT INTO project VALUES (pro,auth); END IF;
                    INSERT INTO Action VALUES (act,'support',0,0,mem,pro);
                    RETURN TRUE;
                END;
            ELSE RETURN FALSE;
            END IF;
        END;
    ELSE 
        BEGIN
            IF is_unique(act) AND mem <> act AND act <> pro AND mem <> pro
            THEN 
                BEGIN
                    IF pro NOT IN (SELECT id FROM project) THEN RETURN FALSE; END IF;
                    IF mem IN (SELECT id FROM member)
                        THEN
                            IF (is_passwd_correct(mem,passwd) AND is_not_frozen(mem,t))
                            THEN UPDATE Member SET last_activity = t WHERE id = mem;
                            ELSE RETURN FALSE;
                            END IF;
                        ELSE IF is_unique(mem) 
                            THEN INSERT INTO member VALUES (mem, crypt(passwd, gen_salt('bf')), FALSE, t);
                            ELSE RETURN FALSE;
                            END IF;
                    END IF;

                    INSERT INTO Action VALUES (act,'support',0,0,mem,pro);
                    RETURN TRUE;
                END;
            ELSE RETURN FALSE;
            END IF;
        END;
    END IF;
END
$X$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION protest(t timestamp, mem bigint, passwd varchar(128), act bigint, pro bigint, auth bigint DEFAULT NULL) RETURNS BOOLEAN
AS $X$
DECLARE
    add_auth BOOLEAN := FALSE; --DEFAULT FALSE;
    add_pro BOOLEAN := FALSE;--DEFAULT FALSE;
BEGIN
    IF auth IS NOT NULL
    THEN
        BEGIN
            IF is_unique(act) AND mem <> act AND act <> pro AND mem <> pro AND mem <> auth AND act <> auth AND pro <> auth
            THEN 
                BEGIN
                    IF pro NOT IN (SELECT id FROM project) 
                        THEN IF is_unique(pro)
                            THEN
                                BEGIN
                                    IF auth NOT IN (SELECT id FROM authority)
                                        THEN IF is_unique(auth) THEN add_auth = TRUE;
                                            ELSE RETURN FALSE; END IF;--INSERT INTO authority VALUES (auth);
                                    END IF;
                                    add_pro = TRUE;--INSERT INTO project VALUES (pro,auth);
                                END;
                            ELSE RETURN FALSE; 
                            END IF;
                    END IF;
                    IF mem IN (SELECT id FROM member)
                    THEN
                        IF (is_passwd_correct(mem,passwd) AND is_not_frozen(mem,t))
                        THEN UPDATE Member SET last_activity = t WHERE id = mem;
                        ELSE RETURN FALSE;
                        END IF;
                    ELSE IF is_unique(mem) 
                        THEN INSERT INTO member VALUES (mem, crypt(passwd, gen_salt('bf')), FALSE, t);
                        ELSE RETURN FALSE;
                        END IF;
                    END IF;
                    IF add_auth THEN INSERT INTO authority VALUES (auth); END IF;
                    IF add_pro THEN INSERT INTO project VALUES (pro,auth); END IF;
                    INSERT INTO Action VALUES (act,'protest',0,0,mem,pro);
                    RETURN TRUE;
                END;
            ELSE RETURN FALSE;
            END IF;
        END;
    ELSE 
        BEGIN
            IF is_unique(act) AND mem <> act AND act <> pro AND mem <> pro
            THEN 
                BEGIN
                    IF pro NOT IN (SELECT id FROM project) THEN RETURN FALSE; END IF;
                    IF mem IN (SELECT id FROM member)
                        THEN
                            IF (is_passwd_correct(mem,passwd) AND is_not_frozen(mem,t))
                            THEN UPDATE Member SET last_activity = t WHERE id = mem;
                            ELSE RETURN FALSE;
                            END IF;
                        ELSE IF is_unique(mem) 
                            THEN INSERT INTO member VALUES (mem, crypt(passwd, gen_salt('bf')), FALSE, t);
                            ELSE RETURN FALSE;
                            END IF;
                    END IF;

                    INSERT INTO Action VALUES (act,'protest',0,0,mem,pro);
                    RETURN TRUE;
                END;
            ELSE RETURN FALSE;
            END IF;
        END;
    END IF;
END
$X$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION upvote(t timestamp, mem bigint, passwd varchar(128), act bigint) RETURNS BOOLEAN
AS $X$
BEGIN
    IF mem <> act
    THEN 
        BEGIN
            IF (mem,act) IN (SELECT member_id,action_id FROM Vote) THEN RETURN FALSE; END IF;
            IF act NOT IN (SELECT id FROM action) THEN RETURN FALSE; END IF;
            IF mem IN (SELECT id FROM member)
            THEN
                IF (is_passwd_correct(mem,passwd) AND is_not_frozen(mem,t))
                THEN UPDATE Member SET last_activity = t WHERE id = mem;
                ELSE RETURN FALSE;
                END IF;
            ELSE IF is_unique(mem) 
                THEN INSERT INTO member VALUES (mem, crypt(passwd, gen_salt('bf')), FALSE, t);
                ELSE RETURN FALSE;
                END IF;
            END IF;

            UPDATE Action SET upvotes = upvotes + 1 WHERE id = act;
            INSERT INTO Vote VALUES (act,mem,1);
            RETURN TRUE;
        END;
    ELSE RETURN FALSE;
    END IF;
END
$X$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION downvote(t timestamp, mem bigint, passwd varchar(128), act bigint) RETURNS BOOLEAN
AS $X$
BEGIN
    IF mem <> act
    THEN 
        BEGIN
            IF (mem,act) IN (SELECT member_id,action_id FROM Vote) THEN RETURN FALSE; END IF;
            IF act NOT IN (SELECT id FROM action) THEN RETURN FALSE; END IF;
            IF mem IN (SELECT id FROM member)
            THEN
                IF (is_passwd_correct(mem,passwd) AND is_not_frozen(mem,t))
                THEN UPDATE Member SET last_activity = t WHERE id = mem;
                ELSE RETURN FALSE;
                END IF;
            ELSE IF is_unique(mem) 
                THEN INSERT INTO member VALUES (mem, crypt(passwd, gen_salt('bf')), FALSE, t);
                ELSE RETURN FALSE;
                END IF;
            END IF;

            UPDATE Action SET downvotes = downvotes + 1 WHERE id = act;
            INSERT INTO Vote VALUES (act,mem,0);
            RETURN TRUE;
        END;
    ELSE RETURN FALSE;
    END IF;
END
$X$ LANGUAGE plpgSQL;

-- LEADER FUNCTIONS

CREATE TYPE projects_of_authorities AS (
    pro bigint,
    auth bigint
);
CREATE OR REPLACE FUNCTION leader_check(t timestamp, mem bigint, passwd varchar(128), auth bigint DEFAULT NULL) RETURNS BOOLEAN
AS $X$
BEGIN
    IF mem IN (SELECT id FROM member WHERE id = mem AND is_leader = TRUE)
                AND is_passwd_correct(mem,passwd) AND is_not_frozen(mem,t) THEN
                RETURN TRUE;
    ELSE RETURN FALSE;
    END IF;
END
$X$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION projects(t timestamp, mem bigint, passwd varchar(128), auth bigint DEFAULT NULL) RETURNS SETOF projects_of_authorities
AS $X$
DECLARE
    pro_rows projects_of_authorities%rowtype;
BEGIN
    IF auth IS NULL THEN
            BEGIN       
                UPDATE member SET last_activity = t WHERE id = mem;
                FOR pro_rows IN SELECT id, authority_id FROM project ORDER BY $1 
                LOOP
                    RETURN NEXT pro_rows;
                END LOOP;
                RETURN;
            END;
    ELSE
        BEGIN
            UPDATE member SET last_activity = t WHERE id = mem;
            FOR pro_rows IN SELECT id, authority_id FROM project WHERE authority_id = auth ORDER BY $1
            LOOP
                RETURN NEXT pro_rows;
            END LOOP;
            RETURN;
        END;
    END IF;
END
$X$ LANGUAGE plpgSQL;

CREATE TYPE actions_of_projects AS(
    id bigint,
    typ varchar(10),
    pro_id bigint,
    auth_id bigint,
    upvote_num bigint,
    downvote_num bigint
);
/*CREATE OR REPLACE FUNCTION actions(t timestamp, mem bigint, passwd varchar(128),
    typ varchar(10) DEFAULT NULL, pro_auth bigint DEFAULT NULL) RETURNS SETOF actions_of_projects
AS $X$
DECLARE
    act_rows actions_of_projects%rowtype;
BEGIN
    IF is_passwd_correct(mem,passwd) AND mem IN (SELECT id FROM member WHERE id = mem AND is_leader = TRUE) THEN
        IF typ IS NULL THEN
            IF pro_auth IS NULL THEN
            BEGIN
                UPDATE member SET last_activity = t WHERE id = mem;
                FOR act_rows IN SELECT act.id,act.type,pro.id,pro.authority_id,act.upvotes, act.downvotes
                                         FROM action act JOIN project pro ON (project_id = pro.id)
                                         ORDER BY $1
                LOOP
                    RETURN NEXT act_rows;
                END LOOP;
                RETURN;
            END;
            ELSE IF pro_auth IN (SELECT id FROM project) THEN
                BEGIN
                    UPDATE member SET last_activity = t WHERE id = mem;
                    FOR act_rows IN SELECT act.id,act.type,pro.id,pro.authority_id,act.upvotes, act.downvotes
                                            FROM action act JOIN project pro ON (project_id = pro.id) WHERE pro.id = pro_auth
                                            ORDER BY $1
                    LOOP
                        RETURN NEXT act_rows;
                    END LOOP;
                    RETURN;
                END;
                ELSE IF pro_auth IN (SELECT id FROM authority) THEN
                BEGIN
                    UPDATE member SET last_activity = t WHERE id = mem;
                    FOR act_rows IN SELECT act.id,act.type,pro.id,pro.authority_id,act.upvotes, act.downvotes
                                            FROM action act JOIN project pro ON (project_id = pro.id)
                                            WHERE pro.authority_id = pro_auth ORDER BY $1
                    LOOP
                        RETURN NEXT act_rows;
                    END LOOP;
                    RETURN;
                END;
                END IF;
            END IF;
        ELSE IF pro_auth IS NULL THEN
            BEGIN
                UPDATE member SET last_activity = t WHERE id = mem;
                FOR act_rows IN SELECT act.id,act.type,pro.id,pro.authority_id,act.upvotes, act.downvotes
                                         FROM action act JOIN project pro ON (project_id = pro.id)
                                         WHERE act.type LIKE typ ORDER BY $1 
                LOOP
                    RETURN NEXT act_rows;
                END LOOP;
                RETURN;
            END;
            ELSE IF pro_auth IN (SELECT id FROM project) THEN
                BEGIN
                    UPDATE member SET last_activity = t WHERE id = mem;
                    FOR act_rows IN SELECT act.id,act.type,pro.id,pro.authority_id,act.upvotes, act.downvotes
                                            FROM action act JOIN project pro ON (project_id = pro.id) WHERE pro.id = pro_auth
                                            AND act.type LIKE typ ORDER BY $1
                    LOOP
                        RETURN NEXT act_rows;
                    END LOOP;
                    RETURN;
                END;
                ELSE IF pro_auth IN (SELECT id FROM authority) THEN
                BEGIN
                    UPDATE member SET last_activity = t WHERE id = mem;
                    FOR act_rows IN SELECT act.id,act.type,pro.id,pro.authority_id,act.upvotes, act.downvotes
                                            FROM action act JOIN project pro ON (project_id = pro.id)
                                            WHERE pro.authority_id = pro_auth AND act.type LIKE typ  ORDER BY $1
                    LOOP
                        RETURN NEXT act_rows;
                    END LOOP;
                    RETURN;
                END;
                END IF;
            END IF;
        END IF;
    END IF;
END
$X$ LANGUAGE plpgSQL;
*/
CREATE TYPE troll AS(
    mem bigint,
    balance bigint,
    active BOOLEAN
);
-- RETURNS A LIST OF ALL TROLLS (MEMBERS WITH SUM OF DOWNVOTES BIGGER THAN UPVOTES)
-- SORTED: BALANCE DESC, MEMBER ASC
CREATE OR REPLACE FUNCTION trolls(t timestamp) RETURNS SETOF troll
AS $X$
DECLARE
    troll_row troll%rowtype;
    balance bigint;
    active BOOLEAN;
    act action;
    memb member;
    sum_upvotes bigint;
    sum_downvotes bigint;
BEGIN
    FOR memb IN (SELECT * FROM member)
    LOOP
        sum_downvotes = 0;
        sum_upvotes = 0;
        FOR act IN (SELECT * FROM Action)
        LOOP
            IF act.member_id = memb.id THEN
            BEGIN
                sum_upvotes = sum_upvotes + act.upvotes;
                sum_downvotes = sum_downvotes + act.downvotes;
            END;
            END IF;
        END LOOP;
    balance = sum_downvotes - sum_upvotes;
    IF balance <= 0 THEN CONTINUE;
    ELSE
    BEGIN
        active = is_not_frozen(memb.id,t);
        troll_row.mem := memb.id;
        troll_row.balance := balance;
        troll_row.active := active;
        RETURN NEXT troll_row;
    END;
    END IF;

    END LOOP;
    
END
$X$ LANGUAGE plpgSQL;

CREATE TYPE mem_vote AS(
    id bigint,
    upvote_sum bigint,
    downvote_sum bigint
);
CREATE OR REPLACE FUNCTION votes(t timestamp,mem bigint,passwd varchar(128),act_pro bigint DEFAULT NULL) RETURNS SETOF mem_vote
AS $X$
DECLARE
    mem_vote_rows mem_vote%rowtype;
BEGIN
    IF mem = act_pro THEN RETURN; END IF;
    IF act_pro IS NULL THEN
        BEGIN
            UPDATE member SET last_activity = t WHERE id = mem;
            FOR mem_vote_rows IN 
                SELECT mem.id, sum(case when vote = 1 then 1 else 0 end) as UPVOTES, 
                sum(case when vote = 0 then 1 else 0 end) as DOWNVOTES 
                FROM member mem LEFT JOIN vote ON (mem.id = member_id) GROUP BY mem.id 
            LOOP
                RETURN NEXT mem_vote_rows;
            END LOOP;
            RETURN;
        END;
    ELSE
        BEGIN
            UPDATE member SET last_activity = t WHERE id = mem;
            FOR mem_vote_rows IN 
                SELECT mem.id, sum(case when vote = 1 then 1 else 0 end) as UPVOTES, 
                sum(case when vote = 0 then 1 else 0 end) as DOWNVOTES 
                FROM member mem LEFT JOIN vote ON (mem.id = member_id) JOIN action act ON(action_id = act.id) 
                WHERE act.id = act_pro OR act.project_id = act_pro GROUP BY mem.id 
            LOOP
                RETURN NEXT mem_vote_rows;
            END LOOP;
            RETURN;
        END;
    END IF;

END
$X$ LANGUAGE plpgSQL;