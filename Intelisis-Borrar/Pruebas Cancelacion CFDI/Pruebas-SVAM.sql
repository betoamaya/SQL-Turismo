/*204*/
SELECT c.MovID,
       c.UUID,
       *
FROM dbo.CFD AS c
WHERE c.MovID IN ( 'TVE138517', 'TVE138518', 'TVE138520', 'TVE138531', 'TVE138534', 'TVE138535', 'TVE138535' );
/*
MovID		UUID
================================================
TVE138517	121203F7-4B7A-4AE2-BEC7-0C6D35ADC824
TVE138518	955BDA12-D42D-43F9-932B-74E27443C32F
TVE138520	D5FD6F93-2C16-4AD1-9887-E2324562A0AB
TVE138531	83E00BEB-A2E9-4F12-87B5-238A4C34AC01
TVE138534	8C8FB1AB-92A5-4002-AB43-6637ADC64E7D
TVE138535	DEC11554-31F8-49BD-9810-AA0ED009C26D
TVE138535	1BCA95C3-DA01-44C2-D204-59A9114F94BE
================================================
*/
UPDATE dbo.CFD
SET UUID = '1BCA95C3-DA01-44C2-D204-59A9114F94BE'
WHERE MovID IN ( 'TVE138517', 'TVE138518', 'TVE138520', 'TVE138531', 'TVE138534', 'TVE138535', 'TVE138535' );


/*211*/
SELECT c.MovID,
       c.UUID,
       *
FROM dbo.CFD AS c
WHERE c.MovID IN ( 'TVE138521', 'TVE138522', 'TVE138523', 'TVE138530', 'TVE138536', 'TVE138537', 'TVE138536',
                   'TVE138538', 'TVE138563', 'TVE138578'
                 );
/*
MovID		UUID
================================================
TVE138521	2CEF6C2E-AF0A-4D9C-9610-538FFA3DB02E
TVE138522	1C1310C1-C43C-42DE-B620-214E79609EF1
TVE138523	733465E2-40E1-4380-984F-1074C0EEEF04
TVE138530	FC5CBE9D-462A-4D79-8E8B-39D94D6612A3
TVE138536	01F10647-94C3-4559-B718-E1F4D92F4C63
TVE138537	1644F308-9305-408F-92F5-B714325B675A
TVE138537	7C34D543-E6C9-4990-D211-3F767E0B5142
TVE138538	5C13E537-4ABE-405E-94D2-6514217B78E3
TVE138563	D7FEFBFA-541E-4C10-80D7-E9042C5E5927
TVE138578	A346DBFC-C397-4855-88F1-92B35AE5A3D9
================================================
*/
UPDATE dbo.CFD
SET UUID = '7C34D543-E6C9-4990-D211-3F767E0B5142'
WHERE MovID IN ( 'TVE138521', 'TVE138522', 'TVE138523', 'TVE138530', 'TVE138536', 'TVE138537', 'TVE138536',
                 'TVE138538', 'TVE138563', 'TVE138578'
               );

			   /*OK*/


UPDATE dbo.CFD SET UUID = '5C13E537-4ABE-405E-94D2-6514217B78E3' WHERE MovID = 'TVE138538';
UPDATE dbo.CFD SET UUID = 'D7FEFBFA-541E-4C10-80D7-E9042C5E5927' WHERE MovID = 'TVE138563';
UPDATE dbo.CFD SET UUID = 'A346DBFC-C397-4855-88F1-92B35AE5A3D9' WHERE MovID = 'TVE138578';