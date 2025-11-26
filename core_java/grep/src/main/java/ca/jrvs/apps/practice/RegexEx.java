package ca.jrvs.apps.practice;

public class RegexEx {

    public boolean matchJpeg(String filename) {
        return filename.matches(".*\\.(?i)jpe?g$");
    }

    public boolean matchIp(String ip) {
        return ip.matches(
                "^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
                        "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
                        "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
                        "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
        );
    }

    public boolean isEmptyLine(String line) {
        return line.matches("^\\s*$");
    }

}
