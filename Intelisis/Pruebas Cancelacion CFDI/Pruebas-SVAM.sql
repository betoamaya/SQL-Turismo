/*204*/
SELECT c.MovID,
       c.UUID,
       *
FROM dbo.CFD AS c
WHERE c.MovID IN ( 'TVE138517', 'TVE138518', 'TVE138520' );
/*
MovID		UUID
================================================
TVE138517	121203F7-4B7A-4AE2-BEC7-0C6D35ADC824
TVE138518	955BDA12-D42D-43F9-932B-74E27443C32F
TVE138520	D5FD6F93-2C16-4AD1-9887-E2324562A0AB
================================================
*/
UPDATE dbo.CFD
SET UUID = '1BCA95C3-DA01-44C2-D204-59A9114F94BE'
WHERE MovID IN ( 'TVE138517', 'TVE138518', 'TVE138520' );


/*211*/
SELECT c.MovID,
       c.UUID,
       *
FROM dbo.CFD AS c
WHERE c.MovID IN ( 'TVE138521', 'TVE138522', 'TVE138523' );
/*
MovID		UUID
================================================
TVE138521	2CEF6C2E-AF0A-4D9C-9610-538FFA3DB02E
TVE138522	1C1310C1-C43C-42DE-B620-214E79609EF1
TVE138523	733465E2-40E1-4380-984F-1074C0EEEF04
================================================
*/

UPDATE dbo.CFD
SET UUID = '7C34D543-E6C9-4990-D211-3F767E0B5142'
WHERE MovID IN ( 'TVE138521', 'TVE138522', 'TVE138523' );

SELECT c.MovID, c.FechaTimbrado, c.FechaCancelacion,* FROM dbo.CFD AS c WHERE c.MovID = 'TVE138517'
