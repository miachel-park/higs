package com.tmax.ofminer.mvsjcl;

import org.antlr.v4.runtime.misc.NotNull;

import com.tmax.ofminer.mvsjcl.MvsjclParser.DdDCBKeyContext;
import com.tmax.ofminer.mvsjcl.MvsjclParser.DdDSORGKeyContext;
import com.tmax.ofminer.mvsjcl.MvsjclParser.DdDispKeyValueContext;
import com.tmax.ofminer.mvsjcl.MvsjclParser.DdDsnameKeyValueContext;
import com.tmax.ofminer.mvsjcl.MvsjclParser.DdRecfmKeyContext;
import com.tmax.ofminer.mvsjcl.MvsjclParser.DdStatementIDContext;
import com.tmax.ofminer.mvsjcl.MvsjclParser.ExecPgmKeyValueContext;
import com.tmax.ofminer.mvsjcl.MvsjclParser.ExecutionStatementContext;
import com.tmax.ofminer.mvsjcl.MvsjclParser.JobStatementIDContext;
import com.tmax.ofminer.mvsjcl.MvsjclParser.StepNameContext;

public class MvsjclTestListenerImpl extends MvsjclBaseListener {

	@Override
	public void exitJobStatementID(JobStatementIDContext ctx)
	{
		System.out.println("JOBNAME=" + ctx.getText());
	}
	
	@Override
	public void enterExecutionStatement(ExecutionStatementContext ctx)
	{
		// check if proc is set
		if ( ctx.execPositionParameter() != null ) {
			System.out.println("\t\tPROCNAME=" + ctx.execPositionParameter().Identifier().getText());
		}
	}
	
	@Override
	public void exitStepName(StepNameContext ctx)
	{
		if ( ctx.getText() != null )
			System.out.println("\tSTEPNAME=" + ctx.getText());
	}
	
	@Override
	public void exitExecPgmKeyValue(ExecPgmKeyValueContext ctx) 
	{
		System.out.println("\t\tPGM=" + ctx.getText());
	}
	
	@Override
	public void exitDdStatementID(DdStatementIDContext ctx)
	{
		System.out.println("\t\tDD=" + ctx.getText());
	}
	
	@Override
	public void exitDdDsnameKeyValue(DdDsnameKeyValueContext ctx)
	{
		System.out.println("\t\t\tDSN=" + ctx.getText());
	}
	
	@Override
	public void exitDdDSORGKey(DdDSORGKeyContext ctx)
	{
		System.out.println("\t\t\tDSORG=" + ctx.getText());
	}
	
	@Override
	public void exitDdRecfmKey(DdRecfmKeyContext ctx)
	{
		System.out.println("\t\t\tRECFM=" + ctx.getText());
	}
	
	@Override
	public void exitDdDCBKey(DdDCBKeyContext ctx)
	{
		System.out.println("\t\t\t" + ctx.getText());
	}
	
	@Override
	public void exitDdDispKeyValue(DdDispKeyValueContext ctx)
	{
		System.out.println("\t\t\tDISP=" + ctx.getText());
	}
}
