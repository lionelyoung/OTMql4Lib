// -*-mode: c; c-style: stroustrup; c-basic-offset: 4; coding: utf-8-dos -*-

/*

This is the replacement for what should be Eval in Mt4:
take a string expression and evaluate it.

I know this is verbose and could be done more compactly,
but it's clean and robust so I'll leave it like this for now.

If you want to extend this for your own functions you have declared in Mql4,
look at how OTLibProcessCmd.mq4 calls zMt4LibProcessCmd and then 
goes on and handles it if zMt4LibProcessCmd didn't.

 */

#property copyright "Copyright 2013 OpenTrading"
#property link      "https://github.com/OpenTrading/"
#property library

#include <stdlib.mqh>
#include <stderror.mqh>
#include <OTMql4/OTLibLog.mqh>
#include <OTMql4/OTLibStrings.mqh>
#include <OTMql4/OTLibSimpleFormatCmd.mqh>

string zOTLibSimpleFormatCmd(string uType, string uChartId, int iIgnore, string uMark, string uCmd) {
    string uRetval;
    /* uType is cmd or exec
    Both will be handled by ProcessCmd, but
    cmd commands will be put back on the wire as a retval.
    If  uType is not cmd or exec then "" is returned to signal failure.
    */
    if (uType != "cmd" && uType != "exec") {
        return "";
    }
    // FixMe: sBAR
    uRetval = StringFormat("%s|%s|%d|%s|%s", uType, uChartId, 0, uMark, uCmd);
    return(uRetval);
}

string zOTLibSimpleFormatBar(string uType, string uChartId, int iIgnore, string uMark, string uInfo) {
    string uRetval;
    /* uType should be one of: bar
    Both will be put on the wire as a their type topics.
    If  uType is not tick timer or bar, then "" is returned to signal failure.
    */
    if (uType != "bar") {
        return "";
    }
    uInfo = Bid +sBAR +Ask +sBAR +uInfo;
    //? uInfo  = iACCNUM +sBAR +uInfo;
    // FixMe: sBAR
    uRetval = StringFormat("%s|%s|%d|%s|%s", uType, uChartId, 0, uMark, uInfo);
    return(uRetval);
}

string zOTLibSimpleFormatTick(string uType, string uChartId, int iIgnore, string uMark, string uInfo) {
    string uRetval;
    /* uType should be one of: tick or timer
    Both will be put on the wire as a their type topics.
    If  uType is not tick timer or bar, then "" is returned to signal failure.
    */
    if (uType != "tick" && uType != "timer") {
        return "";
    }
    uInfo = Bid +sBAR +Ask +sBAR +uInfo;
    //? uInfo  = iACCNUM +sBAR +uInfo;
    // FixMe: sBAR
    uRetval = StringFormat("%s|%s|%d|%s|%s", uType, uChartId, 0, uMark, uInfo);
    return(uRetval);
}

string zOTLibSimpleFormatRetval(string uType, string uChartId, int iIgnore, string uMark, string uInfo) {
    string uRetval;
    /* uType should be one of: retval
    Will be put on the wire as a its type topic.
    If  uType is not retval, then "" is returned to signal failure.
    */
    if (uType != "retval") {
        return "";
    }
    // FixMe: sBAR
    uRetval = StringFormat("%s|%s|%d|%s|%s", uType, uChartId, 0, uMark, uInfo);
    return(uRetval);
}

string eOTLibSimpleUnformatCmd(string& aArrayAsList[]) {
    /*
     */
    string uType, uChartId, uIgnore, uMark, uCmd;
    string uArg1="";
    string uArg2="";
    string uArg3="";
    string uArg4="";
    string uArg5="";
    int iLen;
    string eRetval;
    
    iLen = ArraySize(aArrayAsList);
    if (iLen < 1) {
        eRetval = "eOTLibSimpleUnformatCmd iLen=0: split failed with " +sBAR;
        return(eRetval);
    }
    uType = StringTrimRight(aArrayAsList[0]);
    
    if (iLen < 2) {
        eRetval = "eOTLibSimpleUnformatCmd: split failed on field 2 ";
        return(eRetval);
    }
    uChartId = StringTrimRight(aArrayAsList[1]);

    if (iLen < 3) {
        eRetval = "eOTLibSimpleUnformatCmd: split failed on field 3 ";
        return(eRetval);
    }
    uIgnore = StringTrimRight(aArrayAsList[2]);
    
    if (iLen < 4) {
        eRetval = "eOTLibSimpleUnformatCmd: split failed on field 4 ";
        return(eRetval);
    }
    uMark = StringTrimRight(aArrayAsList[3]);
    if (StringLen(uMark) < 6) {
        eRetval = "eOTLibSimpleUnformatCmd uMark: too short " +uMark;
        return(eRetval);
    }
    if (iLen <= 4) {
        eRetval = "eOTLibSimpleUnformatCmd: split failed on field 5 ";
        return(eRetval);
    }
    uCmd = StringTrimRight(aArrayAsList[4]);
    
    if (iLen > 5) {
        uArg1 = StringTrimRight(aArrayAsList[5]);
        if (iLen > 6) {
            uArg2 = StringTrimRight(aArrayAsList[6]);
            if (iLen > 7) {
                uArg3 = StringTrimRight(aArrayAsList[7]);
                if (iLen > 8) {
                    uArg4 = StringTrimRight(aArrayAsList[8]);
                    if (iLen > 9) {
                        uArg5 = StringTrimRight(aArrayAsList[9]);
                    }
                }
            }
        }
    }
    ArrayResize(aArrayAsList, 10);
    aArrayAsList[0] = uType;
    aArrayAsList[1] = uChartId;
    aArrayAsList[2] = uIgnore;
    aArrayAsList[3] = uMark;
    aArrayAsList[4] = uCmd;
    aArrayAsList[5] = uArg1;
    aArrayAsList[6] = uArg2;
    aArrayAsList[7] = uArg3;
    aArrayAsList[8] = uArg4;
    aArrayAsList[9] = uArg5;
    return("");
}
