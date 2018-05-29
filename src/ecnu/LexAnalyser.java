package ecnu;

import java.io.*;
import java.util.*;

public class LexAnalyser {
    private static final String mExePath = "lexa.exe";
    private File mFile;
    public LexAnalyser(String filePath){
        mFile = new File(filePath);
        if(!mFile.exists()){
            throw new RuntimeException("File not found.");
        }
    }
    private String mErrorMessage="";
    private boolean mHasError = false;

    public boolean hasError() {
        return mHasError;
    }

    public String getErrorMessage() {
        return mErrorMessage;
    }

    public List<TokenItem> analyse(){
        ArrayList<TokenItem> arrayList = new ArrayList<>();
        try{
            FileReader reader = new FileReader(mFile);
            Process process = Runtime.getRuntime().exec(mExePath);
            OutputStream os = process.getOutputStream();
            int b;
            while ((b=reader.read())!=-1){
                os.write(b);
            }
            os.flush();
            os.close();
            InputStream is = process.getInputStream();
            Scanner scanner = new Scanner(is);
            while (scanner.hasNext()){
                String type = scanner.next();
                String value = scanner.next();
                int row = scanner.nextInt();
                int column = scanner.nextInt();
                TokenItem item = new TokenItem(new Token(type),value,row,column);
                arrayList.add(item);
            }
            Scanner errorScanner = new Scanner(process.getErrorStream());
            StringBuilder errorMsg = new StringBuilder();
            while (errorScanner.hasNextLine()){
                errorMsg.append(errorScanner.nextLine());
                errorMsg.append('\n');
            }
            process.waitFor();
            if(process.exitValue()!=0){
                mHasError=true;
                mErrorMessage = errorMsg.toString();
            }else {
                mHasError = false;
            }
            return arrayList;
        }catch (Exception e){
            throw new RuntimeException(e);
        }
    }

}
