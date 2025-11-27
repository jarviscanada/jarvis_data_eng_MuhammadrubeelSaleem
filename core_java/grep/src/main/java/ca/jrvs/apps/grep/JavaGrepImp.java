package ca.jrvs.apps.grep;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.log4j.BasicConfigurator;

import java.io.OutputStreamWriter;
import java.io.FileOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.nio.charset.StandardCharsets;




public class JavaGrepImp {

    final Logger logger = LoggerFactory.getLogger(JavaGrepImp.class);

    private String regex;
    private String rootPath;
    private String outFile;
    private Pattern pattern;


    public static void main(String[] args)
    {
        if (args.length != 3)
        {
            throw new IllegalArgumentException("USAGE: JavaGrep regex rootPath outFile");
        }

        BasicConfigurator.configure();

        JavaGrepImp javaGrepImp = new JavaGrepImp();
        javaGrepImp.setRegex(args[0]);
        javaGrepImp.setRootPath(args[1]);
        javaGrepImp.setOutFile(args[2]);

        try
        {
            javaGrepImp.process();
        }
        catch (Exception ex)
        {
            javaGrepImp.logger.error("Error: Unable to process", ex);
        }
    }


    public void process() throws IOException
    {
        List<String> matchedLines = new ArrayList<>();
        for (File file : listFiles(this.rootPath))
        {
            for (String line : readLines(file))
            {
                if (containsPattern(line))
                {
                    matchedLines.add(line);
                }
            }
        }
        writeToFile(matchedLines);
    }


    public List<File> listFiles(String rootDir)
    {
        List<File> files = new ArrayList<>();
        File dir = new File(rootDir);

        if (!dir.isDirectory())
        {
            throw new IllegalArgumentException(rootDir + " is not a directory");
        }

        File[] children = dir.listFiles();
        if (children == null) return files;

        for (File child : children)
        {
            if (child.isDirectory())
            {
                files.addAll(listFiles(child.getAbsolutePath()));
            }
            else
            {
                files.add(child);
            }
        }
        return files;
    }

    public List<String> readLines(File inputFile)
    {
        if (!inputFile.isFile())
        {
            throw new IllegalArgumentException("Not a file: " + inputFile.getPath());
        }

        List<String> lines = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(new FileInputStream(inputFile), StandardCharsets.UTF_8))) {

            String line;
            while ((line = reader.readLine()) != null)
            {
                lines.add(line);
            }

        } catch (IOException e) {
            logger.error("Failed to read file: " + inputFile.getAbsolutePath(), e);
        }

        return lines;
    }

    public boolean containsPattern(String line)
    {
        return Pattern.compile(regex).matcher(line).find();
    }

    public void writeToFile(List<String> lines) throws IOException
    {
        File output = new File(outFile);

        try (BufferedWriter writer = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(output), StandardCharsets.UTF_8))) {

            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }

        } catch (IOException e) {
            logger.error("Error writing to output file", e);
            throw e;
        }
    }



    //Setters and Getters

    public String getRootPath() {
        return rootPath;
    }


    public void setRootPath(String rootPath) {
        this.rootPath = rootPath;
    }


    public String getRegex() {
        return regex;
    }


    public void setRegex(String regex) {
        this.regex = regex;
    }


    public String getOutFile() {
        return outFile;
    }


    public void setOutFile(String outFile) {
        this.outFile = outFile;
    }



}
