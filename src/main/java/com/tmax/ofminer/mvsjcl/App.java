package com.tmax.ofminer.mvsjcl;

import java.io.File;
import java.io.FileInputStream;

import org.antlr.v4.gui.TestRig;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import com.tmax.ofminer.mvsjcl.MvsjclParser.ExecutionStatementContext;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( String[] args ) throws Exception
    {
        System.out.println( "Hello World!" );
        
        // create a CharStream that reads from standard input
        File file = new File(args[0]);
        FileInputStream in = new FileInputStream(file);
        ANTLRInputStream input = new ANTLRInputStream(in);
      
        
        // create a lexer that feeds off of input CharStream
        MvsjclLexer lexer = new MvsjclLexer(input);
        
        // create a buffer of tokens pulled from the lexer
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        
        // create a parser that feeds off the tokens buffer
        MvsjclParser parser = new MvsjclParser(tokens);
        
        ParseTree tree = parser.jclUnit(); // begin parsing at jclUnit rule
        System.out.println(tree.toStringTree(parser)); // print LISP-style tree
//        
//        // create a standard ANTLR parse tree walker
//        ParseTreeWalker walker = new ParseTreeWalker();
//        // create listener then feed to walker
//        MvsjclTestListenerImpl loader = new MvsjclTestListenerImpl();
//        walker.walk(loader, tree);
    }
}
