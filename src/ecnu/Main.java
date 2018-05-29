package ecnu;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class Main {

    public static void main(String[] args) {
        ProductionFactory factory = new ProductionFactory();
        List<Production> productions = factory.fromFile(new File("C:\\Users\\kuang\\Desktop\\a.txt"));
        System.out.println(productions);
        LLParser parser = new LLParser(productions,factory.getStartSymbol());
        MTable table = parser.getMTable();
        System.out.println(table);
        first(parser,"program");
        try {
            SymbolTreeNode node = parser.llParse("C:\\Users\\kuang\\Desktop\\test.txt");
            System.out.println(node);
        }catch (LLParser.ParserException e){
            e.printStackTrace();
        }
    }

    public static void first(LLParser parser,String m){
        System.out.println(parser.first(new Symbol(m)));
    }

    public static void follow(LLParser parser,String m){
        System.out.println(parser.follow(new Symbol(m)));
    }
}
