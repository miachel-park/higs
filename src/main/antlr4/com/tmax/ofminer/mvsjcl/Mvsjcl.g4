
grammar Mvsjcl;

//*******************************************************//
//*********************** PARSER  ***********************//
//*******************************************************//

//program
//	: jclUnit
//	;

jclUnit
	: jcl
	| error
	;
	
jcl 
	: jobs '//'? EOF
	| preJobGroup jobs '//'? EOF 
	;

preJobGroup
	: preJobStatement+
	;

preJobStatement
	: jes2CommandStatement
	| jes2MessageStatement
	| jes2PriorityStatement
	| jes2SignOffStatement
	| jes2UnknownStatement
	| ddStatement data
	;

jobs
	: job+
	;


job
	: jobStatement sccStatement* outStepGroup? jobSteps?
	//| outStepGroup? jobSteps
	;

sccStatement
	: '#' 'SCC' ',' 'COND' '=' sccCondValue 
	;
	
sccCondValue
	: '(' Identifier '-'? Identifier? ',' reserve ',' '*'? '-'? (Identifier|reserve)('.' (Identifier|reserve))* ')'
	;

outStepGroup
	: outStepStatement+
	;

outStepStatement
	: ddStatement //JOBCAT JOBLIB IMAGELIB
	| commandStatement
	| jclCommandStatement
	| procedureCx //Instream procedure
	| controlCx
	| includeStatement
	| jclLibStatement //cataloged procedure
	| setStatement
	| outputStatement
	| xmitCx
	//| ifCx
	| delimeterStatement
	// JES2 JECL
    | jes2CommandStatement
	| jes2JobParameterStatement
	| jes2LogonIdStatement
	| jes2MessageStatement
	| jes2NetAccountStatement
	| jes2NotifyStatement
	| jes2OutputStatement
	| jes2PasswordStatement
	| jes2RouteStatement
	| jes2SetupStatement
	| jes2SignOffStatement
	| jes2XeqStatement
	| jes2XmitStatement
	| sccStatement
	| jes2PriorityStatement
	;

jobSteps
	: (jobStep|caStep|inStep)+
	;
	
//When Procedure step is added. 	
jobStep
	//: jobScheduleIdStatement? executionStatement executionStatement? statements? 
	: jobScheduleIdStatement? executionStatement statements?
	;
	
caStep
	: jobScheduleIdStatement? '/c' executionStatement statements?
	;
	
inStep
	: jobScheduleIdStatement? '//i' executionStatement statements?
	;

statements
	: statement+
	;
	
statement
	: ddStatement
	| includeStatement
	| outputStatement
	| jclLibStatement
	| controlCx
	| xmitCx
	| setStatement
	| commandStatement
	| jclCommandStatement
	| procedureCx
	| ifCx
	| jobScheduleIdStatement
	| jobScheduleEndStatement
	| sccStatement
	| delimeterStatement
	| pendStatement
//JES2 JECL
	| jes2JobParameterStatement
	| jes2MessageStatement
	| jes2NetAccountStatement
	| jes2NotifyStatement
	| jes2OutputStatement
	| jes2RouteStatement
	| jes2SignOffStatement
	| jes2XeqStatement
	| jes2UnknownStatement
	;
	
//----------JobStatement----------//
jobStatement returns [int job_id, String job_name, int jcl_id, String job_name,
	String addrspc, String bytes, String cards, String ccsid,
	String job_class, String cond, String group, String jeslog, 
	String lines, String memlimit, String msgclass, String msglevel, String notify,
	String pages, String password, String perform, String prty, String rd, String region, String restart, String seclabel,
	String schenv, String time, String typerun, String user]
	: '//' jobStatementID 'JOB' jobPositionParameters? (','? jobKeyParameters)? //15.05.28 changed ',' -> ','?
	//: '//' jobStatementID 'JOB' jobPositionParameters? (',' jobKeyParameters)? //15.06.11 added 
	//| '//' jobStatementID 'JOB' jobKeyParameters //15.06.11 added
	;

jobStatementID
	: Identifier
	| '%'? 'JOBNAME'
	| 'DUMMY'
	;


//----------JobStatement PositionParameters----------//
jobPositionParameters
	: ','? jobPositionParameter (',' jobPositionParameter)*
	;

jobPositionParameter
	: '\'' (Identifier|reserve|'/'|'-'|'.'|','|'#'|'\\'|'DUMMY'|'%')* '\'' //15.05.28 '%' added
	| '(' (Identifier|reserve|'/'|'-'|'.'|','|'#'|'\\'|'DUMMY'|'%')* ')'
	| (Identifier|reserve|'/'|'-'|'.'|','|'#'|'\\'|'DUMMY'|'%')+ //15.05.28 added
	//| reserve //15.05.28 removed
	;
	



//----------JobStatement KeyParameters----------//
jobKeyParameters
	: jobKeyParameter (','  jobKeyParameter)*
	;
	
jobKeyParameter
	: jobAddRspcKey
	| jobBytesKey
	| jobCardsKey
	| jobCcsidKey
	| jobClassKey
	| jobCondKey
	| jobGroupKey
	| jobJesLogKey
	| jobLinesKey
	| jobMemLimitKey
	| jobMsgClassKey
	| jobMsgLevelKey
	| jobNotifyKey
	| jobPagesKey
	| jobPassWordKey
	| jobPerformKey
	| jobPrtyKey
	| jobRdKey
	| jobRegionKey
	| jobRestartKey
	| jobSecLabelKey
	| jobSchEnv
	| jobTimeKey
	| jobTypRunKey
	| jobUserKey
	;
	
jobAddRspcKey
	: 'ADDRSPC' '=' jobAddRspcKeyValue
	| 'ADDRSPC' '='
	;
	
jobAddRspcKeyValue
	: Identifier
	;
	
jobBytesKey
	: 'BYTES' '=' jobBytesKeyValue
	| 'BYTES' '='
	;

jobBytesKeyValue
	: Identifier
	| '(' Identifier? (',' 'CANCEL')? ')'
	| '(' Identifier? (',' 'DUMP')? ')'
	| '(' Identifier? (',' 'WARNING')? ')'
	;
	
jobCardsKey
	: 'CARDS' '=' jobCardsKeyValue
	| 'CARDS' '='
	;

jobCardsKeyValue
	: Identifier
	| '(' Identifier? (',' 'CANCEL')? ')'
	| '(' Identifier? (',' 'DUMP')? ')'
	| '(' Identifier? (',' 'WARNING')? ')'
	;

jobCcsidKey
	: 'CCSID' '=' jobCcsidKeyValue
	| 'CCSID' '='  
	;
	
jobCcsidKeyValue
	: Identifier
	;

jobClassKey
	: 'CLASS' '=' jobClassKeyValue
	| 'CLASS' '='
	;
	
jobClassKeyValue
	: Identifier
	;

jobCondKey
	: 'COND' '=' jobCondKeyValue
	| 'COND' '='
	;

jobCondKeyValue
	: '('? '(' Identifier ',' (Identifier|reserve) ')' (',' '(' Identifier ',' (Identifier|reserve) ')')* ')'?
	;

jobGroupKey
	: 'GROUP' '=' jobGroupKeyValue
	| 'GROUP' '='
	;
	
jobGroupKeyValue
	: Identifier
	;

jobJesLogKey
	: 'JESLOG' '=' jobJesLogKeyValue
	| 'JESLOG' '=' 
	;
	
jobJesLogKeyValue
	: '(' 'SPIN' ',' '\''? Identifier '\''? ')'
	| 'NOSPIN'
	| 'SUPPRESS'
	;

jobLinesKey
	: 'LINES' '=' jobBytesKeyValue
	| 'LINES' '='
	;

jobLinesKeyValue
	: Identifier
	| '(' Identifier? (',' 'CANCEL')? ')'
	| '(' Identifier? (',' 'DUMP')? ')'
	| '(' Identifier? (',' 'WARNING')? ')'
	;

jobMemLimitKey
	: 'MEMLIMIT' '=' jobMemLimitKeyValue
	| 'MEMLIMIT' '='
	;
	
jobMemLimitKeyValue
	: Identifier
	;

jobMsgClassKey
	: 'MSGCLASS' '=' jobMsgClassKeyValue
	| 'MSGCLASS' '='
	;
	
jobMsgClassKeyValue
	: Identifier
	;

jobMsgLevelKey
	: 'MSGLEVEL' '=' jobMsgLevelKeyValue
	| 'MSGLEVEL' '='
	;
	
jobMsgLevelKeyValue
	: Identifier
	| '(' Identifier? (',' Identifier)+ ')'
	;

jobNotifyKey
	: 'NOTIFY' '=' jobNotifyKeyValue
	| 'NOTIFY' '='  
	;

jobNotifyKeyValue
	: Identifier '.'? Identifier?
	;
	
jobPagesKey
	: 'PAGES' '=' jobPagesKeyValue
	| 'PAGES' '='
	;
	
jobPagesKeyValue
	: Identifier
	| '(' Identifier? (',' 'CANCEL')? ')'
	| '(' Identifier? (',' 'DUMP')? ')'
	| '(' Identifier? (',' 'WARNING')? ')'
	;
	
jobPassWordKey
	: 'PASSWORD' '=' jobPassWordKeyValue
	| 'PASSWORD' '='
	; 
	
jobPassWordKeyValue
	: '('? Identifier (',' Identifier)? ')'?
	;

jobPerformKey
	: 'PERFORM' '=' jobPerformKeyValue
	| 'PERFORM' '='
	;
	
jobPerformKeyValue
	: Identifier
	;

jobPrtyKey
	: 'PRTY' '=' jobPrtyKeyValue
	| 'PRTY' '='
	;
	
jobPrtyKeyValue
	: Identifier
	;

jobRdKey
	: 'RD' '=' jobRdKeyValue
	| 'RD' '='
	;
	
jobRdKeyValue
	: Identifier
	; 

jobRegionKey
	: 'REGION' '=' jobRegionKeyValue
	| 'REGION' '='
	;
	
jobRegionKeyValue
	: Identifier
	;
 
jobRestartKey
	: 'RESTART' '=' jobRestartKeyValue
	| 'RESTART' '='
	;

jobRestartKeyValue
	: '('? '*' (',' Identifier)? ')'?
	| '('? Identifier (',' Identifier)? ')'?
	| '('? Identifier '.' Identifier (',' Identifier)? ')'?
	;

jobSecLabelKey
	: 'SECLABEL' '=' jobSecLabelKeyValue
	| 'SECLABEL' '='
	;
	
jobSecLabelKeyValue
	: Identifier
	;
	
jobSchEnv
	: 'SCHENV' '=' jobSchEnvValue
	| 'SCHENV' '='
	;
	
jobSchEnvValue
	: Identifier
	| Identifier ('_' Identifier)*
	;
	
jobTimeKey
	: 'TIME' '=' jobTimeKeyValue
	| 'TIME' '='
	; 

jobTimeKeyValue
	: '(' Identifier? (',' Identifier)? ')'
	| Identifier
	;

jobTypRunKey
	: 'TYPRUN' '=' jobTypRunKeyValue
	| 'TYPRUN' '='
	;
	
jobTypRunKeyValue
	: reserve
	| Identifier 
	;

jobUserKey
	: 'USER' '=' jobUserKeyValue
	| 'USER' '=' 
	;
	
jobUserKeyValue
	: Identifier
	;
	

//----------Execution Statement----------//	
executionStatement returns [int id, String step_Name, int jcl_id, int job_id, int proc_id,
	int parent_proc_id, int program_id, String proc_type, 
	String acct, String addrspc, String ccsid, String cond,
	String dynamnbr, String memlimit, String parm, String perform, String pgm, String proc,
	String rd, String region, String rlstmout, String time, String macro]
	: '//' stepName? 'EXEC' execPositionParameter? ','? execKeyParameters? 
	;
	
stepName
	//: (Identifier|reserve|'\\')+ ('.' (Identifier|reserve))* //15.06.02 because of REXX '\\'
	: (Identifier|reserve) ('.' (Identifier|reserve))*
	;


//----------Execution Statement Position Parameter----------//
execPositionParameter
	: Identifier
	| 'SORT' // 15.05.28 added
	//| reserve
	;
	
//----------Execution Statement Key Parameter----------//
execKeyParameters
	: execKeyParameter (',' execKeyParameter)*
	;

execKeyParameter
	: execAcctKey
	| execAddrspcKey
	| execCcsidKey
	| execCondKey
	| execClasKey
	| execDynamnbrKey
	| execMemLimitKey
	| execParmKey
	| execPerformKey
	| execPgmKey
	| execProcKey
	| execRdKey
	| execRegionKey
	| execRlstMoutKey
	| execTimeKey
	//GE additional parameter
	| execOrgKey
	| execPtrKey
	| execJobNameKey
	| execUidKey
	| execUtProcKey
	| execSystemKey
	| execCopsKey
	| execClasKey
	| execInclpmsKey
	| execPlibKey
	| execMacroKey
	;
	
execAcctKey
	: 'ACCT'('.' Identifier)? '=' execAcctKeyValue
	| 'ACCT'('.' Identifier)? '=' 
	;
	
execAcctKeyValue
	: '('? 
	    (Identifier 
	    | '\'' Identifier? '=' Identifier? '\'' 
	    | '\'' Identifier? '.' Identifier? '\''
	   	| '\'' Identifier? ('/' Identifier?)* '\'')
	    (',' 
	   	((Identifier 
	   	| '\'' Identifier? '=' Identifier? '\'' 
	   	| '\'' Identifier? ('.' Identifier?)* '\''
	   	| '\'' Identifier? ('/' Identifier?)* '\'')))*
	    ')'?
	;
	
execAddrspcKey
	: 'ADDRSPC' ('.' Identifier)? '=' execAddrspcKeyValue
	| 'ADDRSPC' ('.' Identifier)? '='
	;
	
execAddrspcKeyValue
	: Identifier
	;

execCcsidKey
	: 'CCSID' '=' execCcsidKeyValue
	| 'CCSID' '='
	;
	
execCcsidKeyValue
	: Identifier
	;

execCondKey
	: 'COND' '=' execCondKeyValue
	| 'COND' '='
	| 'COND' ('.' Identifier) '=' execCondKeyValue
	| 'COND' ('.' Identifier) '='
	;
	
execCondKeyValue
	: '(' Identifier (',' (Identifier|reserve))+ ')'
	| Identifier
	| '(' execCondKeyValue ',' Identifier ')'
	| '(' execCondKeyValue (',' execCondKeyValue)* ')'
	| '(' Identifier ( ',' ( (Identifier|reserve) | (Identifier|reserve)('.' (Identifier|reserve))+ ) )+ ')'
	;

execCopsKey
	: 'COPS' '=' execCopsKeyValue
	| 'COPS' '='
	;
	
execCopsKeyValue
	: Identifier
	; 

execClasKey
	: 'CLAS' '=' execClasKeyValue
	| 'CLAS' '='
	;
	
execClasKeyValue
	: Identifier
	| '\'' Identifier '\''
	| '\''? '*' '\''?
	;
	
execInclpmsKey
	: 'INCLPMS' '=' execInclpmsKeyValue
	| 'INCLPMS' '='
	;
	
execInclpmsKeyValue
	: Identifier | reserve
	; 
	
execDynamnbrKey
	: 'DYNAMNBR' ('.' Identifier)? '=' execDynamnbrKeyValue
	| 'DYNAMNBR' ('.' Identifier)? '='
	;
	
execDynamnbrKeyValue
	: Identifier
	;
	
execMemLimitKey
	: 'MEMLIMIT' '=' execMemLimitKeyValue
	| 'MEMLIMIT' '='
	;
	
execMemLimitKeyValue
	: Identifier
	;
	
execParmKey
	: 'PARM' '='  execParmKeyValue
	| 'PARM' '='
	;

execParmKeyValue
	: '\'' (Identifier|reserve|'.'|','|'('|')'|'-'|'*'|'/'|'='|'_'|';'|'\\'|Unicode)* '\'' // 15.05.28 '\\' added
	| '(' (Identifier|'('Identifier')'|'\'' ((Identifier|reserve)('.'(Identifier|reserve))*) '\''|'\'' '\''
		|reserve|','|'-'|'*'|'/'|'='|';'|'\''| Identifier '(' (Identifier|'*'+) (',' (Identifier|'*'+))*')')* ')'
		// 15.05.31 Identifier '(' (Identifier|'*'+) (',' (Identifier|'*'+))*')  ,  '\''added
	| Identifier
	| reserve
	; 

/*
execParmKeyValue
	: '\'' execParmKeySubValue (','? execParmKeySubValue)* '\''
	| '\'' '\'' execParmKeySubValue+ '\'' '\''
	| execParmKeySubValue
	;

execParmKeySubValue
	: '/'? Identifier '(' Identifier? ')'
	| '('? (Identifier|reserve) ')'? 
	| Identifier '=' Identifier
	| Identifier ('.' Identifier)+
	;
	*/
	
execPerformKey
	: 'PERFORM' ('.'Identifier)? '=' execPerformKeyValue
	| 'PERFORM' ('.'Identifier)? '='
	;
	
execPerformKeyValue
	: Identifier
	;
	
execPgmKey
	: 'PGM' '=' execPgmKeyValue
	| 'PGM' '='
	;
	
execPgmKeyValue
	: (Identifier|reserve)
	| '*' ('.' (Identifier|reserve))*
	;
	
execProcKey
	: 'PROC' '=' execProcKeyValue
	| 'PROC' '='
	;
	
execProcKeyValue
	: Identifier
	;

execRdKey
	: 'RD' ('.' Identifier)? '=' execRdKeyValue
	| 'RD' ('.' Identifier)? '='
	;
	
execRdKeyValue
	: Identifier
	;
	
execRegionKey
	: 'REGION' ('.' Identifier)* '=' execRegionKeyValue
	| 'REGION' ('.' Identifier)* '='
	;
	
execRegionKeyValue
	: Identifier
	;
	
execRlstMoutKey
	: 'RLSTMOUT' '=' execRlstMoutKeyValue
	| 'RLSTMOUT' '='
	;
	
execRlstMoutKeyValue
	: Identifier
	;
	
execTimeKey
	: 'TIME' ('.' Identifier)? '=' execTimeKeyValue
	| 'TIME' ('.' Identifier)? '='
	;
	
execTimeKeyValue
	: '(' Identifier? (',' Identifier)? ')'
	|  Identifier
	;
	
execOrgKey
	: 'ORG' '=' execOrgKeyValue
	| 'ORG' '=' 
	;
	
execOrgKeyValue
	: Identifier
	| '\'' Identifier '\''
	;
	
execPtrKey
	: 'PTR' '=' execPtrKeyValue
	| 'PTR' '='
	;
	
execPtrKeyValue
	: Identifier
	| '\'' Identifier '\''
	;
	
execJobNameKey
	: 'JOBNAME' '=' execJobNameKeyValue
	| 'JOBNAME' '='
	;
	
execJobNameKeyValue
	: Identifier
	| '\'' Identifier '\''
	;

execUidKey
	: 'UID' '=' execUidKeyValue
	| 'UID' '='
	;
	
execUidKeyValue
	: '\'' Identifier '\''
	| '\'' (Identifier|reserve|'.'|','|'('|')'|'-'|'*'|'/'|'='|'_'|';'|'\\'|Unicode)* '\''
	;
	
execUtProcKey
	: 'UTPROC' '=' execUtProcKeyValue
	| 'UTPROC' '='
	;
	
execUtProcKeyValue
	: '\'' Identifier? '\''
	;
	
execSystemKey
	: 'SYSTEM' '=' execSystemKeyValue
	| 'SYSTEM' '='
	;
	
execSystemKeyValue
	: Identifier
	;
	
execPlibKey
	: 'PLIB' '=' execPlibKeyValue
	| 'PLIB' '='
	;
	
execPlibKeyValue
	/*
	 * By Yoon. ex) PLIB='G1IT00AP.USER.PROCLIB'
	 */
	: '\'' (Identifier|reserve) ( '.'  (Identifier|reserve) )* '\''
	| (Identifier|reserve) ( '.'  (Identifier|reserve) )*
	; 

execMacroKey
	: (Identifier|reserve|'SYSIN')('.'(Identifier|reserve))* '=' execMacroKeyValue
	| (Identifier|reserve|'SYSIN') '='
	;
	
execMacroKeyValue
	: (reserve|Identifier) ('.' (Identifier|reserve))* ('(' (Identifier|'-')+ ')')?
	| '\'' (Identifier|reserve) (('.'|',') (Identifier|reserve))* ('(' (Identifier|'-')+ ')')? '\'' 
	| '\'' '('? (Identifier|'-'|'*'|'?')+ ')'? '\''
	| '\'' '\''+ '('? Identifier+ ')'? '\''+ '\'' // 15.06.02 revised by david
	| '('? '\'' (Identifier|reserve) '=' (Identifier|reserve) '\'' ')'?
	| '\'' ('/' ( Identifier|Identifier(('_'|'.')Identifier)+) )* '\'' 
	| '(' Identifier (',' Identifier)* ')'
	| ddSpaceKeyValue
	| '*'
	;

//----------DDStatement----------//
ddStatement returns [int id, String step_Name, int jcl_id, int job_id, 
	int step_id, String dd_name, String accode, String amp, String avgrec, String blksize,
	String blksizelimit, String burst, String ccsid, String chars, String chkpt, String cntl,
	String copies, String dataclas, String dcb, DdDCBKeyContext dcb_Ob, 
	String ddname, String dest, String disp,
	String dlm, String dsid, String dataset_name, String dsntype, String expdt, String fcb,
	String filedata, String flash, String free, String hold, String keylen, String keyoff,
	String label, String lgstream, String like, String lrecl, String mgmtclas, String modify,
	String outlim, String output, String path, String pathdisp, String pathmode, String pathopts, 
	String protect, String qname, String recfm, String recorg, String refdd, String retpd, String rls, 
	String secmodel, String segment, String space, String spin, String storclas, String subsys, 
	String sysout, String term, String ucs, String unit, String unit, String volume]
	: '//' ddStatementID? 'DD' ddPositionParameters? cData ('/*')*
	|'//' ddStatementID? 'DD' ddPositionParameters (',' ddKeyParameters) cData ('/*')* // DLM 15.06.05
	| '//' ddStatementID? ('DD' (ddPositionParameters ',')? ddKeyParameters) ('/*')*
	| '//' ddStatementID? 'DD' ddPositionParameters ('/*')*
	//| '//' ddStatementID 'DD' ('DATA' |'*') ('/*')*
	| '//' ddStatementID? 'DD'
	| cData ('/*')*
	;


//----------DDStatement PositionParameters----------//
ddPositionParameters
	: ddPositionParameter (',' ddPositionParameter)*
	| ddPositionParameter+
	;
	
ddPositionParameter
	: 'DUMMY' 
	| 'DYNAM'
	| 'DATA'
	| '*'
	| Identifier // 15.05.31 added
	;




ddStatementID
	: (Identifier|reserve) '.' (Identifier|reserve|'SYSIN')
	| (Identifier|reserve)
	| 'SYSIN'
	| 'JOBLIB'
	| 'JOBCAT'
	| 'IMAGELIB'
	;		

//----------DDStatement KeyParameters----------//
ddKeyParameters
	: ddKeyParameter (',' ddKeyParameter)* ','?  
	;
	
ddKeyParameter
	: ddAccodeKey
	| ddAmpKey
	| ddAvgRecKey
	| ddBlkSizeKey
	| ddBlkSizeLimitKey
	| ddBurstKey
	| ddCcsidKey
	| ddCharsKey
	| ddChkptKey
	| ddCntlKey
	| ddCopiesKey
	| ddDataClassKey
	| ddDCBKey
	| ddDSORGKey
	| ddNameKey
	| ddDestKey
	| ddDispKey
	| ddDlmKey
	| ddDsidKey
	| ddDsnameKey
	| ddDsnTypeKey
	| ddExpdtKey
	| ddFcbKey
	| ddFileDataKey
	| ddFlashKey
	| ddFreeKey
	| ddHoldKey
	| ddKeyLenKey
	| ddKeyOffKey
	| ddLabelKey
	| ddLgstreamKey
	| ddLikeKey
	| ddLreclKey
	| ddMgmtclasKey
	| ddModifyKey
	| ddOutlimKey
	| ddOutputKey
	| ddPathKey
	| ddPathDispKey
	| ddPathModeKey
	| ddPathOptsKey
	| ddProtectKey
	| ddQnameKey
	| ddRecfmKey
	| ddRecorgKey
	| ddRefddKey
	| ddRetpdKey
	| ddRlsKey
	| ddSecModelKey
	| ddSegmentKey
	| ddSpaceKey
	| ddSpinKey
	| ddStorClasKey
	| ddSubsysKey
	| ddSysOutKey
	| ddTermKey
	| ddUcsKey
	| ddUnitKey
	| ddVolumeKey
	| ddBufNoKey
	/*
	 * 14. 12. 08
	 */
	| ddTrtchKey
	;

ddAccodeKey
	: 'ACCODE' '=' ddAccodeKeyValue 
	| 'ACCODE' '='
	;
	
ddAccodeKeyValue
	: Identifier
	;
	
ddAmpKey
	: 'AMP' '=' ddAmpKeyValue
	| 'AMP' '='
	;
	
ddAmpKeyValue
	:  '(' '\''? ddAmpKeySubParameter (',' ddAmpKeySubParameter)* '\''? ')'
	| ddAmpKeySubParameter
	;
	
ddAmpKeySubParameter
	: '\'' Identifier '=' Identifier '\''
	| '\'' ddKeyParameter '\''
	| Identifier '=' Identifier
	| Identifier
	;

ddAvgRecKey
	: 'AVGREC' '=' ddAvgRecKeyValue
	| 'AVGREC' '='
	;
	
ddAvgRecKeyValue
	: Identifier
	;

ddBlkSizeKey
	: 'BLKSIZE' '=' ddBlkSizeKeyValue
	| 'BLKSIZE' '='
	;
	
ddBlkSizeKeyValue
	: Identifier
	;

ddBlkSizeLimitKey
	: 'BLKSZLIM' '=' ddBlkSizeLimitKeyValue
	| 'BLKSZLIM' '='
	;
	
ddBlkSizeLimitKeyValue
	: Identifier
	;
	
ddBurstKey
	: 'BURST' '=' ddBurstKeyValue
	| 'BURST' '='
	;
	
ddBurstKeyValue
	: Identifier
	;
	
ddCcsidKey
	: 'CCSID' '=' ddCcsidKeyValue
	| 'CCSID' '='
	;
	
ddCcsidKeyValue
	: Identifier
	;
	
ddCharsKey
	: 'CHARS' '=' ddCharsKeyValue
	| 'CHARS' '='
	;
	
ddCharsKeyValue
	: '(' Identifier (',' Identifier)* ')'
	;

ddChkptKey
	: 'CHKPT' '=' ddChkptKeyValue
	| 'CHKPT' '='
	;
	
ddChkptKeyValue
	: Identifier
	;
	
ddCntlKey
	: 'CNTL' '=' ddCntlKeyValue
	| 'CNTL' '='
	;
	
ddCntlKeyValue
	: '*' '.' Identifier ('.' Identifier)*
	;
	
ddCopiesKey
	: 'COPIES' '=' ddCopiesKeyValue
	| 'COPIES' '='
	;
	
ddCopiesKeyValue
	: Identifier
	| '(' Identifier? ',' '(' Identifier (',' Identifier)* ')' ')'
	;

ddDataClassKey
	: 'DATACLAS' '=' ddDataClassKeyValue
	| 'DATACLAS' '='
	;
	
ddDataClassKeyValue
	: Identifier
	; 

ddDCBKey returns [int id, int dd_Id, String dd_Name, int jcl_id, int job_id, int step_id,
	String bfaln, String bftek, String blksize, String bufin,
	String bufl, String bufmax, String bufno, String bufoff, String bufout, String bufsize, String cpri, String cylofl,
	String den, String diagns, String dsorg, String eropt, String func, String gncp, String intvl, String ipltxid, 
	String keylen, String limct, String lrecl, String mode_parm, String ncp, String ntm,  String optcd,
	String pci, String prtsp, String recfm, String reserve_parm, String rkp, String stack, String thresh, String trtch,
	String dcb_Key_Name]
	: 'DCB' '=' ddDCBKeyValue
	;
	
ddDCBKeyValue
	: 
	 dcbSubparameter
	| '(' dcbSubparameter (',' dcbSubparameter)* ')'
	/*
	 * DCB=(SYS2.DSCB,RECFM=FB,LRECL=4096),
	 */ 
	| '(' ddDCBKeyId (',' dcbSubparameter)* ')'
	| ddDCBKeyId
	;
	
ddDCBKeyId
	: Identifier ('.' Identifier)*
	/*
	 * DCB=*.SORTIN
	 */
	| '*' ('.' Identifier)*
	;

ddDSORGKey
	: 'DSORG' '=' ddDSORGKeyValue
	| 'DSORG' '='
	;
	
ddDSORGKeyValue
	: Identifier
	; 

ddNameKey
	: 'DDNAME' '=' ddNameKeyValue
	;
	
ddNameKeyValue
	: Identifier
	| 'SYSIN'
	;
	
ddDestKey
	: 'DEST' '=' ddDestKeyValue
	| 'DEST' '='
	;
	
ddDestKeyValue
	: '(' '\''? Identifier '\''? ',' '\''? Identifier '\''? ')'
	| '\'' Identifier '\''
	| Identifier
	;
	
ddDispKey
	: 'DISP' '=' ddDispKeyValue
	| 'DISP' '=' 
	;
	
ddDispKeyValue
	: '(' (Identifier|reserve)? (',' (Identifier|reserve)?)? (',' (Identifier|reserve)?)? ')'
	| Identifier
	| reserve
	;
	
ddDlmKey
	: 'DLM' '=' ddDlmKeyValue
	| 'DLM' '=' 
	;
	
ddDlmKeyValue
	: (Identifier | '#')*
	;
	
ddDsidKey
	: 'DSID' '=' ddDsidKeyValue
	| 'DSID' '=' 
	;

ddDsidKeyValue
	: Identifier
	| '(' Identifier ',' Identifier? ')'
	;
	
ddDsnameKey
	: 'DSN' '=' ddDsnameKeyValue
	| 'DSN' '='
	| 'DSNAME' '=' ddDsnameKeyValue
	;
	
ddDsnameKeyValue
	// DSN=G1JR00FP.FOCEXEC.DATA97(RESLVPMA) 
	: (Identifier|reserve) ('.'(Identifier|reserve|'DUMMY'|(Identifier?'#'Identifier)))* '(' (Identifier|'-'|reserve)* ')'
	// DSN=SYSD.CA7.BATCHO#1
	//| (Identifier|reserve|'\\')+ ('.'(Identifier|reserve|'DUMMY'|(Identifier?'#'Identifier)|('?')+|('\\'))+)*
	// 15.05.31  
	| (Identifier|reserve) ('.'(Identifier|reserve|'DUMMY'|(Identifier?'#'Identifier)))*
	// DSN='G1JPPMAP.PMSPROD.PARMLIB(G1JP29P1)'
	| '\'' Identifier ('.' (Identifier|reserve))* ('(' Identifier ')')? '\'' ('(' Identifier ')')?
	| '*' ( '.' (Identifier|reserve) )*
	| Identifier
	;
	
ddDsnTypeKey
	: 'DSNTYPE' '=' ddDsnTypeKeyValue
	| 'DSNTYPE' '=' 
	;
	
ddDsnTypeKeyValue
	: Identifier
	;
	
ddExpdtKey
	: 'EXPDT' '=' ddExpdtKeyValue
	| 'EXPDT' '='
	;
	
ddExpdtKeyValue
	: Identifier
	| Identifier '/' Identifier
	;
	
ddFcbKey
	: 'FCB' '=' ddFcbKeyVlaue
	| 'FCB' '='
	;
	
ddFcbKeyVlaue
	: Identifier
	| '(' Identifier (',' Identifier)? ')'
	;
	
ddFileDataKey
	: 'FILEDATA' '=' ddFileDataKeyValue
	| 'FILEDATA' '='
	;
	
ddFileDataKeyValue
	: reserve
	;
	
ddFlashKey
	: 'FLASH' '=' ddFlashKeyValue
	| 'FLASH' '='
	;
	
ddFlashKeyValue
	: Identifier
	| '(' Identifier (',' Identifier)? ')'
	;
	
ddFreeKey
	: 'FREE' '=' ddFreeKeyValue
	| 'FREE' '='
	;
	
ddFreeKeyValue
	: Identifier
	;

ddHoldKey
	: 'HOLD' '=' ddHoldKeyValue
	| 'HOLD' '='
	;
	
ddHoldKeyValue
	: Identifier
	;
	
ddKeyLenKey
	: 'KEYLEN' '=' ddKeyLenKeyValue
	| 'KEYLEN' '='
	;
	
ddKeyLenKeyValue
	: Identifier
	;
	
ddKeyOffKey
	: 'KEYOFF' '=' ddKeyOffKeyValue
	| 'KEYOFF' '='
	;
	
ddKeyOffKeyValue
	: Identifier
	;

//TODO mvsana
ddLabelKey
	: 'LABEL' '=' ddLabelKeyValue
	| 'LABEL' '='
	;
	
ddLabelKeyValue
	: '(' ((Identifier|'?'|'*')+)? ( ',' (Identifier|ddKeyParameter)?)+ ')' 
	// '(' (Identifier|'?')? ( ',' (Identifier|ddKeyParameter)?)+ ')' //15.05.31 added
	| Identifier
	| ddKeyParameter
	;
	   
ddLgstreamKey
	: 'LGSTREAM' '=' ddLgstreamKeyValue
	| 'LGSTREAM' '=' 
	;
	
ddLgstreamKeyValue
	: Identifier ('.' Identifier)*
	;
	
ddLikeKey
	: 'LIKE' '=' ddLikeKeyValue
	| 'LIKE' '='
	;
	
ddLikeKeyValue
	: Identifier ('.' (Identifier|reserve)?)*
	;
	
ddLreclKey
	: 'LRECL' '=' ddLreclKeyValue
	| 'LRECL' '=' 
	;
	
ddLreclKeyValue
	: Identifier
	| '\\'+
	;
	
ddMgmtclasKey
	: 'MGMTCLAS' '=' ddMgmtclasKeyValue
	| 'MGMTCLAS' '=' 
	;
	
ddMgmtclasKeyValue
	: '\''? Identifier ('.' Identifier?)? '\''?
	;
	
ddModifyKey
	: 'MODIFY' '=' ddModifyKeyValue
	| 'MODIFY' '=' 
	;
	
ddModifyKeyValue
	: Identifier
	| '(' Identifier (',' Identifier)? ')'
	;
	
ddOutlimKey
	: 'OUTLIM' '=' ddOutlimKeyValue
	| 'OUTLIM' '='
	;
	
ddOutlimKeyValue
	: Identifier
	; 
	
ddOutputKey
	: 'OUTPUT' '=' ddOutputKeyValue
	| 'OUTPUT' '='
	;
	
ddOutputKeyValue
	: '*' '.' Identifier '.'? Identifier? '.'? Identifier?
	| '(' '*' '.' Identifier '.'? Identifier? '.'? Identifier? 
	   (',' '*' '.' Identifier '.'? Identifier? '.'? Identifier? )* ')'
	;
	
ddPathKey
	: 'PATH' '=' ddPathKeyValue
	| 'PATH' '='
	;
	
ddPathKeyValue
	/*
	 * Type) PATH=''/export/userdata/efssftp/JPDRPF_P198_OUT''
	 */
	: '\'' '\''? ('/' (Identifier (('.'|'_') Identifier)*))+ '\''? '\''
	;
	
ddPathDispKey
	: 'PATHDISP' '=' ddPathDispKeyValue
	| 'PATHDISP' '='
	;
	
ddPathDispKeyValue
	: Identifier
	| '(' (Identifier|reserve)? (',' (Identifier|reserve))? ')'
	;
	
ddPathModeKey
	: 'PATHMODE' '=' ddPathModeKeyValue
	| 'PATHMODE' '='  
	;
	
ddPathModeKeyValue
	: '('? Identifier (',' Identifier)* ')'?
	;
	
ddPathOptsKey
	: 'PATHOPTS' '=' ddPathOptsKeyValue
	| 'PATHOPTS' '=' 
	;
	
ddPathOptsKeyValue
	: '('? Identifier (',' Identifier)* ')'?
	;
	
ddProtectKey
	: 'PROTECT' '=' ddProtectKeyValue
	| 'PROTECT' '='
	;
	
ddProtectKeyValue
	: Identifier
	;
	
ddQnameKey
	: 'QNAME' '=' ddQnameKeyValue
	| 'QNAME' '='
	;
	
ddQnameKeyValue
	: Identifier ('.' Identifier)?
	;

ddRecfmKey
	: 'RECFM' '=' ddRecfmKeyValue
	| 'RECFM' '='
	;
	
ddRecfmKeyValue
	: Identifier
	;
	
ddRecorgKey
	: 'RECORG' '=' ddRecorgKeyValue
	| 'RECORG' '='
	;
	
ddRecorgKeyValue
	: Identifier
	;
	
ddRefddKey
	: 'REFDD' '=' ddRefddKeyValue
	| 'REFDD' '='
	;
	
ddRefddKeyValue
	: '*' ('.'Identifier)+
	;
	
ddRetpdKey
	: 'RETPD' '=' ddRetpdKeyValue
	| 'RETPD' '='
	;
	
ddRetpdKeyValue
	: Identifier
	;
	
ddRlsKey
	: 'RLS' '=' ddRlsKeyValue
	| 'RLS' '='
	;
	
ddRlsKeyValue
	: Identifier
	;
	
ddSecModelKey
	: 'SECMODEL' '=' ddSecModelKeyValue
	| 'SECMODEL' '='
	;
	
ddSecModelKeyValue
	: '(' (Identifier|'*') ('.' (Identifier|'*'))*
	      (',' (Identifier|'*') ('.' (Identifier|'*'))*)* ')'
	;
	
ddSegmentKey
	: 'SEGMENT' '=' ddSegmentKeyValue
	| 'SEGMENT' '='
	;
	
ddSegmentKeyValue
	: Identifier
	;
	
ddSpaceKey
	: 'SPACE' '=' ddSpaceKeyValue
	| 'SPACE' '=' 
	;
	
ddSpaceKeyValue
	: '(' Identifier ',' '(' Identifier (',' Identifier?)+ ')' ')'
	| '(' Identifier ',' '(' Identifier (',' Identifier?)+ ')' ',' Identifier ')'
	| '(' Identifier (',' ('(' Identifier ')' | Identifier)? )+ ')'
	| '(' Identifier (',' ('(' Identifier ('.' Identifier?)* (',' Identifier ('.' Identifier?)*)+ ')' | Identifier)? )+ ')'
	| '(' Identifier? (',' Identifier?)+ ')' 
	| '(' (Identifier|'\''|Identifier '=' '\'') (',' (Identifier|'\''|Identifier '=' '\''))* ')'
	;
	
ddSpinKey
	: 'SPIN' '=' ddSpinKeyValue
	| 'SPIN' '='
	;
	
ddSpinKeyValue
	: Identifier
	;
	
ddStorClasKey
	: 'STORCLAS' '=' ddStorClasKeyValue
	| 'STORCLAS' '='
	;
	
ddStorClasKeyValue
	: Identifier
	;
	
ddSubsysKey
	: 'SUBSYS' '=' ddSubsysKeyValue
	| 'SUBSYS' '='
	;
	
ddSubsysKeyValue
	: '(' ddSubsysKeySubValue (',' ddSubsysKeySubValue)* ')'
	;
	
ddSubsysKeySubValue
	: ('\''Identifier'='Identifier'\'' | '\''Identifier'\'')+
	| '\''? ddKeyParameter '\''?
	| Identifier
	;
	
ddSysOutKey
	: 'SYSOUT' '=' ddSysOutKeyValue
	// no grammar rule, mvsana permit this.
	| 'SYSOUT' '='
	;
	
ddSysOutKeyValue
	: '(' (Identifier|'*') ',' (Identifier|reserve)? ',' (Identifier|reserve)? ')'
	| '(' (Identifier|reserve)? (',' ((Identifier|reserve)('.' (Identifier|reserve))*)? )* ')'
	| '(' '*' ','? (Identifier|reserve) ?')'
	| '\'' '(' (Identifier|reserve) ',' (Identifier|reserve) ')' '\''
	| '\'' (Identifier|reserve) '\''
	| '\'' '*' '\''
	| Identifier
	| reserve
	| '*'
	;
	
ddTermKey
	: 'TERM' '=' ddTermKeyValue
	| 'TERM' '='
	;
	
ddTermKeyValue
	: Identifier
	;

ddUcsKey
	: 'UCS' '=' ddUcsKeyValue
	| 'UCS' '='
	;
	
ddUcsKeyValue
	: '('? Identifier (','? Identifier)? (',' Identifier)? ')'?
	;
	
ddUnitKey
	: 'UNIT' '=' ddUnitKeyValue
	| 'UNIT' '=' 
	;
	
ddUnitKeyValue
	: Identifier
	| Identifier '=' Identifier
	| '(' '/'? Identifier? (',' Identifier?)? (',' Identifier)? ')'
	| '('  Identifier? (',' Identifier '=' Identifier)+ ')' //15.05.31 added
	;
	
ddVolumeKey
	: 'VOLUME' '=' ddVolumeKeyValue
	| 'VOLUME' '='
	| 'VOL' '=' ddVolumeKeyValue
	| 'VOL' '='
	;   

ddVolumeKeyValue
	: Identifier '=' Identifier
	| Identifier '=' '(' Identifier (',' Identifier)* ')'
	/*
	 * VOL=(,RETAIN,REF=*.STEP004.SYSUT2),
	 */
	| '(' Identifier? (',' (Identifier|(Identifier '=' ((Identifier|'*') ('.' Identifier)*)))?)* ')'  
	| '(' Identifier? (',' Identifier?)* ')'
	// ex) VOL=REF=*.T2
	| Identifier '=' '*' ('.' Identifier)+ 
	
	// ex) (,,,6)
	| '(' Identifier? (',' Identifier? )* ')'
	| (reserve|Identifier)+
	;
	
ddBufNoKey
	: 'BUFNO' '=' ddBufNoKeyValue
	| 'BUFNO' '='
	;
	
ddBufNoKeyValue
	: Identifier
	;
	
ddTrtchKey
	: 'TRTCH' '=' ddTrtchKeyValue
	| 'TRTCH' '='
	;
	
ddTrtchKeyValue
	: Identifier
	;

/*
 * CData
 */

cData
	: data (','? data)* 
	;
	
data
	: 'InsData' 's[' 'EXEC'? (Identifier|reserve|'DUMMY'|Unicode|'='|'<'|'>'|'^'|'{'|'}'|'.'|'%'|'('|')'|','|'?'
	   |';'|'\''|'-'|'*'|'_'|'\\'|'/'|'|'|'#'|'<='|'=>'|'/c'|'ABEND' |':'| 'JOBNAME' | 'EXEC' |'/*'|']'|'['
	   |'//'|'JOB'|'THEN'|'MSGCLASS'|'RC' | '=<' | '>=' | '&' | 'SYSIN' | '!' | 'JOBLIB' | 'JOBCAT' 
	   |'IMAGECAT' | 'DATA' )+ 'e]' 
	; //15.05.28 'ABEND' , ':' , 'JOBNAME' , 'EXEC' , '/*' , '>=' , '<=' added
	// 15.05.30 '[',']' added
		   
//----------Data Control Block Subparameter----------//

dcbSubparameter
	//: '(' (Identifier| reserve) '=' Identifier ',' (Identifier| reserve) '=' Identifier ')'
	//;
	: dcbBfaln
	| dcbBftek
	| dcbBlockSize
	| dcbBufIn
	| dcbBufL
	| dcbBufMax
	| dcbBufNo
	| dcbBufOff
	| dcbBufOut
	| dcbBufSize
	| dcbCpri
	| dcbCylofl
	| dcbDen
	| dcbDiagns
	| dcbDsorg
	| dcbEropt
	| dcbFunc
	| dcbGncp
	| dcbIntvl
	| dcbIpltxId
	| dcbKeyLen
	| dcbLimCt
	| dcbLreCl
	| dcbMode
	| dcbNcp
	| dcbNtm
	| dcbOptCd
	| dcbPci
	| dcbPrtSp
	| dcbReCfm
	| dcbReserve
	| dcbRkp
	| dcbStack
	| dcbThresh
	| dcbTrtCh
	;



dcbBfaln
	: 'BFALN' '=' Identifier
	| 'BFALN' '='
	;

dcbBftek
	: 'BFTEK' '=' Identifier
	| 'BFTEK' '=' 
	;
	
dcbBlockSize
	: 'BLKSIZE' '=' Identifier
	| 'BLKSIZE' '='
	;
	
dcbBufIn
	: 'BUFIN' '=' Identifier
	| 'BUFIN' '=' 
	;
	
dcbBufL
	: 'BUFL' '=' Identifier
	| 'BUFL' '=' 
	;
	
dcbBufMax
	: 'BUFMAX' '=' Identifier
	| 'BUFMAX' '='  
	;
		
dcbBufNo
	: 'BUFNO' '=' Identifier
	| 'BUFNO' '=' 
	;
	
dcbBufOff
	: 'BUFOFF' '=' Identifier
	| 'BUFOFF' '=' 
	;
	
dcbBufOut
	: 'BUFOUT' '=' Identifier
	| 'BUFOUT' '='  
	;
		
dcbBufSize
	: 'BUFSIZE' '=' Identifier
	| 'BUFSIZE' '=' 
	;

dcbCpri
	: 'CPRI' '=' Identifier
	| 'CPRI' '=' 
	;
	
dcbCylofl
	: 'CYLOFL' '=' Identifier
	| 'CYLOFL' '=' 
	;
	
dcbDen
	: 'DEN' '=' Identifier
	| 'DEN' '=' 
	;
	
dcbDiagns
	: 'DIAGNS' '=' Identifier
	| 'DIAGNS' '=' 
	;
	
dcbDsorg
	: 'DSORG' '=' Identifier
	| 'DSORG' '=' 
	;
	
dcbEropt
	: 'EROPT' '=' Identifier
	| 'EROPT' '=' 
	;
	
dcbFunc
	: 'FUNC' '=' Identifier
	| 'FUNC' '=' 
	;
	
dcbGncp
	: 'GNCP' '=' Identifier
	| 'GNCP' '=' 
	;
	
dcbIntvl
	: 'INTVL' '=' Identifier
	| 'INTVL' '=' 
	;
	
dcbIpltxId
	: 'IPLTXID' '=' Identifier
	| 'IPLTXID' '=' 
	;

dcbKeyLen
	: 'KEYLEN' '=' Identifier
	| 'KEYLEN' '=' 
	;
	
dcbLimCt
	: 'LIMCT' '=' Identifier
	| 'LIMCT' '=' 
	;
	
dcbLreCl
	: 'LRECL' '=' Identifier
	| 'LRECL' '=' '\\'+
	| 'LRECL' '=' 
	;
	
dcbMode
	: 'MODE' '=' Identifier
	| 'MODE' '=' 
	;
	 
dcbNcp
	: 'NCP' '=' Identifier
	| 'NCP' '=' 
	;
	
dcbNtm
	: 'NTM' '=' Identifier
	| 'NTM' '=' 
	;

dcbOptCd
	: 'OPTCD' '=' Identifier
	| 'OPTCD' '=' 
	;
	
dcbPci
	: 'PCI' '=' dcbPciValue
	| 'PCI' '='
	;

dcbPciValue
	: Identifier
	| '(' Identifier (',' Identifier) ')'
	;

dcbPrtSp
	: 'PRTSP' '=' Identifier
	| 'PRTSP' '=' 
	;
	
dcbReCfm
	: 'RECFM' '=' Identifier
	| 'RECFM' '=' 
	;
	
dcbReserve
	: 'RESERVE' '=' '(' Identifier ',' Identifier ')'
	| 'RESERVE' '='
	;
	
dcbRkp
	: 'RKP' '=' Identifier
	| 'RKP' '=' 
	;
	
dcbStack
	: 'STACK' '=' Identifier
	| 'STACK' '=' 
	;
		
dcbThresh
	: 'THRESH' '=' Identifier
	| 'THRESH' '='
	;

dcbTrtCh
	: 'TRTCH' '=' Identifier
	| 'TRTCH' '=' 
	;


//----------Command Statement----------//	 
commandStatement
	: '//' commandStatementID? 'COMMAND' '\'' command commandPositionParameters?
	','? commandKeyParameters? '\'' 
	;

commandStatementID
	: Identifier
	;

command
	: Identifier
	;


//----------Command Statement Parameters----------//	
commandPositionParameters
	: commandPositionParameter (',' commandPositionParameter)*
	;

commandPositionParameter
	: Identifier
	;
	
commandKeyParameters
	: commandKeyParameter (',' commandKeyParameter)*
	;
	
commandKeyParameter
	: Identifier '=' Identifier
	| Identifier '=' '\'' Identifier (',' Identifier)* '\''
	;


//----------JCL Command Statement----------//
jclCommandStatement
	: '//' jclCommand jclCommandPositionParameters? ',' jclCommandKeyParameters?  
	;
	
jclCommand
	: Identifier
	;

jclCommandPositionParameters
	: jclCommandPositionParameter (',' jclCommandPositionParameter)*
	;
	
jclCommandPositionParameter
	: Identifier
	;
	
jclCommandKeyParameters
	: jclCommandKeyParameter (',' jclCommandKeyParameter)*
	;
	
jclCommandKeyParameter
	: Identifier '=' Identifier
	//jclCommandParameter '=' jclCommandParameterValue
	;
/*	
jclCommandParameter
	: Identifier
	;
	
jclCommandParameterValue
	: Identifier
	;
 */
//----------Include Statement----------//
includeStatement returns [int id, String include_name, int jcl_id, int job_id, String member]
	:'//' includeStatementID? 'INCLUDE' includeKeyParameter cData?
	;
	
includeStatementID
	: (Identifier|reserve)('.'(Identifier|reserve))*
	| 'INCLUDE'
	| 'JOBLIB'
	| 'INCLPMS'
	;

includeKeyParameter
	: 'MEMBER' '=' '\'' Identifier ('.' Identifier)* '\'' 
	| 'MEMBER' '=' Identifier ('.' Identifier)* 
	| 'MEMBER' '=' Identifier '#' Identifier
	// because of this, parsing is slow.
	| 'MEMBER' '=' '\'' Identifier ('.' Identifier)* '\'' Identifier
	// because of this, parsing is slow.
	| 'MEMBER' '=' '\'' Identifier ('.' Identifier)* '\'' Identifier ('.' Identifier)
	| 'MEMBER' '=' 'DUMMY'
	;


//----------If Statement----------//
ifCx
	: ifThenStatement conditionGroup? elseStatement? conditionGroup? endIfStatement '/*'*
	;

ifThenStatement
	: '//' ifThenStatementID? 'IF' 
		'('? relationExpression (('AND'|'OR'|'&'|'|'|Identifier) relationExpression)* ')'? 'THEN'
	; 
	// '|' // 15.05.28 added '|'
	
ifThenStatementID
	: Identifier
	;

elseStatement
	: elseStatementID? 'ELSE'
	;
	
elseStatementID
	: Identifier
	;
	
endIfStatement
	: '//' endIfStatementID? 'ENDIF'
	;
	
endIfStatementID
	: Identifier
	| reserve
	;	

conditionGroup
	: conditionStatement+
	;
	
conditionStatement
	: ifCx						
	| includeStatement
	| '/c' executionStatement
	| '//i' executionStatement		
	| executionStatement	
	| ddStatement				
	| outputStatement			
	| controlCx					
	| setStatement				
	| procedureCx
	| delimeterStatement	//15.06.02 revised by david			
	;
	
relationExpression
	: relationExpressionKey comp_op Identifier
	| '(' relationExpressionKey comp_op Identifier ')'
	| '(' relationExpression (('&'|'|'|'AND'|'OR') relationExpression)* ')'
	| relationExpressionKey
	| '(' relationExpression ')'
	| Identifier '.' 'ABEND'
	| Identifier '.' 'ABENDCC'
	| Identifier '.' 'RUN'
	| 'ABEND' ('=' Identifier)?
	| 'ABENDCC' ('=' Identifier)?
	| 'RUN' ('=' Identifier)?
	;
	// 15.05.28 relationExpressionKey added
	
relationExpressionKey
	: Identifier
	| Identifier ('.' Identifier)* '.' 'RC'
	| 'RC'

	;
/*

relationExpressionKeySw
	: AbendSw
	| RunSw
	; 
*/	

comp_op
	: '>'
	| '<'
	| '>='
	| '<='
	| '='
	| '^='
	| '~='
	//14.11.10
	| 'EQ'
	| 'LT'
	| 'NE'
	| 'LE'
	| 'GE'
	;
	
//----------Procedure Statement Parameters----------//
procedureCx
	: procedureStatement outStepGroup? jobSteps? 'PEND'
	;
	
procedureStatement returns [int id, String proc_name, String proc_type, int jcl_id, int job_id]
	: '//' procedureStatementID? 'PROC' procKeyParameters? 
	;

procedureStatementID
	: Identifier
	;

procKeyParameters
	: procKeyParameter ( ','  procKeyParameter)*
	;
	
procKeyParameter
	: (Identifier|reserve) '=' procKeyParameterValue?
	| 'SYSOUT' '=' procKeyParameterValue
	| 'SYSIN' '=' procKeyParameterValue
	;
	
//procKeyParameterValue
	//: '\'' Identifier ('.' (Identifier|reserve))* '\''
//	: '\'' Identifier* '\''
//	| Identifier ('.' Identifier)*
	//| Identifier ('.' Identifier?)*
//	| '\''? '*' '\''?
//	;
	
procKeyParameterValue
	: '\'' Identifier ('.' (Identifier|reserve))* '\''
	| '\'' Identifier+ '\''
	| Identifier ('.' Identifier)*
	| Identifier ('.' Identifier?)*
	| '\''? '*' '\''?
	;


//----------Pend Statement----------//	
pendStatement
	: '//' pendStatementID? 'PEND' 
	;
	
pendStatementID
	: Identifier
	;


//----------Set Statement----------//	
setStatement returns [int id, String set_name, int jcl_id, int job_id, String parm]
	: '//' setStatementID? 'SET' setKeyParameters 
	;

setStatementID
	: Identifier
	;

setKeyParameters
	: setKeyParameter (',' setKeyParameter)*
	| setKeyParameter+
	;
	
setKeyParameter
	: (Identifier|reserve) '=' ('\'' Identifier? '\'')+
	| Identifier '=' ('\'' Identifier '\'' | Identifier) ('.'('\'' Identifier '\'' | Identifier))* '(' (Identifier)+ ')'
	| Identifier '=' '\''? (Identifier|reserve) (('.'|',') (Identifier|reserve))* '\''?
	| Identifier '=' '\'' '(' Identifier ')' '\''
	| (Identifier|reserve) '=' '\''?  (Identifier|reserve|ddDispKeyValue|'-'|'*')+  '\''?
	| Identifier '=' (('\'' Identifier '\'') | Identifier)+
	| Identifier '=' '\'' ddKeyParameter (',' (ddKeyParameter|'DSN' '='))* '\''
	| Identifier '='
	| execKeyParameter
	;


//----------Control Statement----------//
controlCx
	: controlStatement controlGroup? endControlStatement
	;
	
controlStatement
	: '//' controlStatementID 'CNTL' 
	;
	
controlStatementID
	: Identifier
	;	
	
controlGroup
	: programControlStatement+
	;
	
programControlStatement
	: '//' programControlID 'PRINTDEV' programControlPositionParameters?
	;

programControlID
	: Identifier
	;
	

programControlPositionParameters
	: programControlPositionParameter (',' programControlPositionParameter)*
	;

programControlPositionParameter
	: Identifier '=' Identifier
	;

endControlStatement
	: '//' endControlStatementID? 'ENDCNTL' 
	;
	
endControlStatementID
	: Identifier
	;


//----------JCLLIB Statement----------//
jclLibStatement returns [int id, String jcllib_name, int jcl_id, int job_id, String order]
	: '//' jclLibStatementID? 'JCLLIB' jclLibKeyParameter
	;
	
jclLibStatementID
	: Identifier
	;
	
jclLibKeyParameter
	: 'ORDER' '=' '(' ( (Identifier|reserve) ('.' (Identifier|reserve))+ ) 
				      (',' ( (Identifier|reserve) ('.' (Identifier|reserve))+ ) )* ')'
	| 'ORDER' '=' (Identifier|reserve) ('.' (Identifier|reserve))+
	| 'ORDER' '=' '\'' (Identifier|reserve) ('.' (Identifier|reserve))+ '\''
	;


//----------OUTPUT Statement----------//
outputStatement returns [int id, String output_name, int jcl_id, int job_id, String parm]
	: '//' outputStatementID 'OUTPUT' outputKeyParameters
	;
	
outputStatementID
	: Identifier
	;	

outputKeyParameters
	: outputKeyParameter (',' outputKeyParameter)*
	;
	
outputKeyParameter
	: outputKeyParmKey '=' outputKeyParmValue
	| outputKeyParmKey '='
	;

outputKeyParmKey
	: Identifier
	| reserve
	;
	
outputKeyParmValue
	: '(' '\''Identifier((','|'.')?Identifier)*'\'' (',' '\''Identifier((','|'.')?Identifier)*'\'')* ')'
	| '(' Identifier? ',' '('Identifier(','Identifier)*')' ')'
	| '\'' Identifier '\''
	| '(' Identifier('.'Identifier)? (',' Identifier('.'Identifier)?)* ')'
	| '(' Identifier(('.'|',')Identifier)* ')'
	| '\'' '<'Identifier'>'':''<'Identifier'>'':''<'Identifier'>''\''
	| Identifier('.'Identifier)*
	| Identifier
	| '*'
	;



//----------XMIT Statement----------//	
xmitCx
	: xmitStatement data
	;
	
xmitStatement
	: '//' xmitStatementID? 'XMIT' xmitKeyParameter (',' xmitKeyParameter)*
	;

xmitStatementID
	: Identifier
	;
	
xmitKeyParameter
	: Identifier
	;

jobScheduleIdStatement
	: '#JI' ',' 'ID' '=' jobScheduleId
	| '#JO' ',' 'ID' '=' jobScheduleId
	;
	
jobScheduleId
	: Identifier
	| '(' (Identifier|'-')* (',' (Identifier|'-')*)* ')'
	| '(' Identifier '-' Identifier ')'
	| '(' Identifier (',' Identifier)* ')'
	;
	
jobScheduleEndStatement
	: '#JEND'
	;

//----------NULL Statement----------//
delimeterStatement
	: '/*' 
	;
	
error
	: Identifier
	;

jes2CommandStatement
	: '/*' jes2Command jcommPositionParameter
	;
	
jes2Command
	: '$' Identifier
	;
	
jcommPositionParameter
	: Identifier
	;
	
jes2JobParameterStatement
	: '/*' 'JOBPARM' jJobParamKeyParameter (',' jJobParamKeyParameter)*
	;
	
jJobParamKeyParameter
	: Identifier '=' Identifier
	| Identifier '=' '*'
	| Identifier '=' '(' '*' ',' Identifier ')'
	| Identifier '=' '(' Identifier (',' Identifier)* ')'
	;
	
jes2LogonIdStatement
	: '/*' 'LOGONID' jLogonIdPositionParameter*
	;
	
jLogonIdPositionParameter
	: Identifier
	;
	
jes2MessageStatement
	: '/*' 'MESSAGE' jMessagePositionParameter+
	;
	
jMessagePositionParameter
	: '\'' (Identifier|reserve|'.'|','|'('|')'|'-'|'*'|'/'|'='|'_'|';')* '\''
	| (Identifier|reserve|'.'|','|'('|')'|'-'|'*'|'/'|'='|'_'|';')+
	| Identifier
	;
	
jes2NetAccountStatement
	: '/*' 'NETACCOUNT' jNetAcctPositionParameter
	;
	
jNetAcctPositionParameter
	: Identifier
	;
	
jes2NotifyStatement
	: '/*' 'NOTIFY' jNotifyPositionParameter+
	;
	
jNotifyPositionParameter
	: Identifier('.' Identifier)
	| Identifier(':' Identifier)
	| Identifier('/' Identifier)
	| Identifier('(' Identifier ')')
	| Identifier
	;
	
jes2OutputStatement
	: '/*' 'OUTPUT' jOutputPositionParameter* (jOutputKeyParameter(',' jOutputKeyParameter)*)?
	;

jOutputPositionParameter
	: Identifier
	| reserve
	;
	
jOutputKeyParameter
	: '('(Identifier|reserve)'='(Identifier|reserve)')'
	| '\''(Identifier|reserve)'='(Identifier|reserve)'\'' 
	| (Identifier|reserve) '=' '('? (Identifier('.'Identifier)+|Identifier|reserve)
	(','(Identifier('.'Identifier)|Identifier|reserve))* ')'?
	| (Identifier|reserve) ('.' (Identifier|reserve))+
	;
	
jes2PasswordStatement
	: '/*' 'PASSWORD' jPasswordPositionParameter
	;
	
jPasswordPositionParameter
	: Identifier+
	;
	
jes2PriorityStatement
	: '/*' 'PRIORITY' jPriorityPositionParameter
	;
	
jPriorityPositionParameter
	: Identifier
	;
	
jes2RouteStatement
	: '/*' 'ROUTE' Identifier jRoutePositionParameter*
	;
	
jRoutePositionParameter
	: Identifier('.' Identifier)*
	| Identifier(':' Identifier)+
	| Identifier('/' Identifier)+
	| Identifier('(' Identifier ')')
	;
	
jes2SetupStatement
	: '/*' 'SETUP' jSetupPositionParameter (',' jSetupPositionParameter)*
	;

jSetupPositionParameter
	: Identifier
	;
	
jes2SignOffStatement
	: '/*' 'SIGNOFF'
	;
	
jes2SignOnStatement
	: '/*' 'SIGNON' Identifier jSignonPositionParameter*
	;
	
jSignonPositionParameter
	: Identifier
	;
	
jes2XeqStatement
	: '/*' 'XEQ' jXeqPositionParameter
	| '/*' 'ROUTE' 'XEQ' jXeqPositionParameter 
	;
	
jXeqPositionParameter
	: Identifier ('.' Identifier)*
	;
	
	
jes2XmitStatement
	: '/*' 'XMIT' jXmitPositionParameter jXmitKeyParameter?
	;

jXmitPositionParameter
	:  Identifier
	;
	
jXmitKeyParameter
	: (Identifier|reserve) '=' Identifier
	;
	
jes2UnknownStatement
	: '/*' 'UNKNOWN' jUnknownPositionParameter
	;
	
jUnknownPositionParameter
	: Identifier
	;


//*******************************************************//
//***********************  LEXER  ***********************//
//*******************************************************//

Identifier
	: [a-zA-Z0-9$%@"&:+#]+ //15.06.02 ! revised by david
	;

	
Unicode
	: '\u00C0'..'\u00D6'
	| '\u00D8'..'\u00F6'
    | '\u00F8'..'\u02FF'
    | '\u0370'..'\u037D'
    | '\u037F'..'\u1FFF'
    | '\u200C'..'\u200D'
    | '\u2070'..'\u218F'
    | '\u2190'..'\u2b9F' // 15.05.30 added (-) special char for Shift-JIS 
    | '\u2C00'..'\u2FEF'
    | '\u3001'..'\uD7FF'
    | '\uF900'..'\uFDCF'
    | '\uFDF0'..'\uFFFD'
    | '\u3000' // 15.05.28 added Shift-JIS space
    | '\u0000' // 15.05.28 added Shift-JIS space (decimal : 0)
    | '\u001E' // 15.05.28 added Shift-JIS space (decimal : 30)
    | '\u2212' // 15.05.30 added (-)
    | '\u0010'
    | '\u003C'
    | '\uFF7F'
    ;

	
reserve
	: 'ACCODE'	| 'AMP'			| 'AVGREC'	| 'BLKSIZE'		| 'BLKSZLIM'	| 'BURST'		| 'CCSID'	| 'SYSTEM'
	| 'CHARS'	| 'CHKPT'		| 'CNTL'	| 'COPIES'		| 'DATACLAS'	| 'DCB'			| 'DDNAME'	| 'MSGLEVEL'
	| 'DEST'	| 'DISP'		| 'DLM'		| 'DSID'		| 'DSNTYPE'		| 'EXPDT' 		| 'FCB'		| 'MEMBER'
	| 'FREE'	| 'HOLD' 		| 'KEYLEN' 	| 'KEYOFF' 		| 'LABEL' 		| 'LGSTREAM'	| 'LIKE' 	| 'ID'
	| 'LRECL'	| 'MGMTCLAS'	| 'MODIFY'	| 'FILEDATA'	| 'BINARY' 		| 'TEXT' 		| 'TRACE'	| 'SYSOUT'
	| 'BFALN'	| 'BFTEK'		| 'BLKSIZE' | 'BUFIN'		| 'BUFL'		| 'BUFMAX'		| 'BUFNO'	| 'BUFOFF'
	| 'BUFOUT'	| 'BUFSIZE'		| 'CPRI'	| 'CYLOFL'		| 'DEN'			| 'DIAGNS'		| 'DSORG' 	| 'EROPT'
	| 'FUNC' 	| 'GNCP' 		| 'INTVL' 	| 'IPLTXID' 	| 'LIMCT' 		| 'LRECL' 		| 'MODE' 	| 'NCP' 
	| 'OPTCD' 	| 'PCI' 		| 'PRTSP' 	| 'RECFM' 		| 'RESERVE' 	| 'RKP' 		| 'STACK' 	| 'THRESH'
	| 'COMMAND' | 'INCLUDE'		| 'PROC' 	| 'SET' 		| 'CNTL' 		| 'PRINTDEV' 	| 'TRTCH' 	| 'NTM'
	| 'ENDCNTL' | 'JCLLIB' 		| 'ORDER'	| 'OUTPUT' 		| 'ACCT'		| 'SEGMENT' 	| 'GE' 		| 'RESTART'
	| 'XMIT' 	| 'COND' 		| 'END' 	| 'JOB'			| 'DATA' 		| 'TIME' 		| 'PARM'	| 'TERM'
	| 'SORT' 	| 'DELETE' 		| 'MERGE' 	| 'CLUSTER' 	| 'DEFINE' 		| 'REPRO' 		| 'IX' 		| 'IMAGELIB'
	| 'JOBCAT' 	| 'OR' 			| 'AND' 	| 'REGION' 		| 'EQ' 			| 'LT' 			| 'RUN' 	| 'INCLPMS' 
	| 'NE' 		| 'USER'		| 'CLASS'	| 'PGM'			| 'WARNING' 	| 'DUMP'		| 'UNIT' 	| 'ORG' 
	| 'GROUP' 	| 'DD'			| 'NOTIFY' 	| 'COPS' 		| 'CLAS' 		| 'LE' 			| 'GE'		| 'PRIORITY'
	| 'SPACE'	| 'DSN'			| 'RETPD'	| 'LINES'		| 'IF'			| 'THEN'		| 'VOLUME'	| 'DSNAME'
	| 'ELSE'	| 'SIGNON'		| 'UNKNOWN'	| 'SIGNOFF'		| 'PASSWORD'	| 'SETUP'		| 'MESSAGE'	| 'JOBPARM'
	| 'PATH'	| 'CANCEL'		| 'UID'		| 'ORG'			| 'PLIB'		| 'UTPROC'		| 'VOL'		| 'BYTES'
	;
	
//relationExpressionKeySw
/* AbendSw
	: 'ABENDSW'
	;
	
RunSw
	: 'RUNSW'
	;
*/
	
// Define whitespace rule, toss it out
WS  :   [ \t\r\n]+ -> skip ;

ErrorCharacter : . ;
