package com.circuskitchens.flutter_datawedge

import com.circuskitchens.flutter_datawedge.pigeon.LabelType


fun convertLabelType(input: String): LabelType{

    return when (input){

        "LABEL-TYPE-CODE39" -> LabelType.CODE39
        "LABEL-TYPE-CODABAR" ->   LabelType.CODABAR
        "LABEL-TYPE-CODE128" ->   LabelType.CODE128
        "LABEL-TYPE-D2OF5" ->   LabelType.D2OF5
        "LABEL-TYPE-IATA2OF5" ->   LabelType.IATA2OF5
        "LABEL-TYPE-I2OF5" ->   LabelType.I2OF5
        "LABEL-TYPE-CODE93" ->   LabelType.CODE93
        "LABEL-TYPE-UPCA" ->   LabelType.UPCA
        "LABEL-TYPE-UPCE0" ->   LabelType.UPCE0
        "LABEL-TYPE-UPCE1" ->   LabelType.UPCE1
        "LABEL-TYPE-EAN8" ->   LabelType.EAN8
        "LABEL-TYPE-EAN13" ->   LabelType.EAN13
        "LABEL-TYPE-MSI" ->   LabelType.MSI
        "LABEL-TYPE-EAN128" ->   LabelType.EAN128
        "LABEL-TYPE-TRIOPTIC39" ->   LabelType.TRIOPTIC39
        "LABEL-TYPE-BOOKLAND" ->   LabelType.BOOKLAND
        "LABEL-TYPE-COUPON" ->   LabelType.COUPON
        "LABEL-TYPE-DATABAR-COUPON" ->   LabelType.DATABAR_COUPON
        "LABEL-TYPE-ISBT128" ->   LabelType.ISBT128
        "LABEL-TYPE-CODE32" ->   LabelType.CODE32
        "LABEL-TYPE-PDF417" ->   LabelType.PDF417
        "LABEL-TYPE-MICROPDF" ->   LabelType.MICROPDF
        "LABEL-TYPE-TLC39" ->   LabelType.TLC39
        "LABEL-TYPE-CODE11" ->   LabelType.CODE11
        "LABEL-TYPE-MAXICODE" ->   LabelType.MAXICODE
        "LABEL-TYPE-DATAMATRIX" ->   LabelType.DATAMATRIX
        "LABEL-TYPE-QRCODE" ->   LabelType.QRCODE
        "LABEL-TYPE-GS1-DATABAR" ->   LabelType.GS1DATABAR
        "LABEL-TYPE-GS1-DATABAR-LIM" ->   LabelType.GS1DATABAR_LIM
        "LABEL-TYPE-GS1-DATABAR-EXP" ->   LabelType.GS1DATABAR_EXP
        "LABEL-TYPE-USPOSTNET" ->   LabelType.USPOSTNET
        "LABEL-TYPE-USPLANET" ->   LabelType.USPLANET
        "LABEL-TYPE-UKPOSTAL" ->   LabelType.UKPOSTAL
        "LABEL-TYPE-JAPPOSTAL" ->   LabelType.JAPPOSTAL
        "LABEL-TYPE-AUSPOSTAL" ->   LabelType.AUSPOSTAL
        "LABEL-TYPE-DUTCHPOSTAL" ->   LabelType.DUTCHPOSTAL
        "LABEL-TYPE-FINNISHPOSTAL-4S" ->   LabelType.FINNISHPOSTAL4S
        "LABEL-TYPE-CANPOSTAL" ->   LabelType.CANPOSTAL
        "LABEL-TYPE-CHINESE-2OF5" ->   LabelType.CHINESE2OF5
        "LABEL-TYPE-AZTEC" ->   LabelType.AZTEC
        "LABEL-TYPE-MICROQR" ->   LabelType.MICROQR
        "LABEL-TYPE-US4STATE" ->   LabelType.US4STATE
        "LABEL-TYPE-US4STATE-FICS" ->   LabelType.US4STATE_FICS
        "LABEL-TYPE-COMPOSITE-AB" ->   LabelType.COMPOSITE_AB
        "LABEL-TYPE-COMPOSITE-C" ->   LabelType.COMPOSITE_C
        "LABEL-TYPE-WEBCODE" ->   LabelType.WEBCODE
        "LABEL-TYPE-SIGNATURE" ->   LabelType.SIGNATURE
        "LABEL-TYPE-KOREAN-3OF5" ->   LabelType.KOREAN3OF5
        "LABEL-TYPE-MATRIX-2OF5" ->   LabelType.MATRIX2OF5
        "LABEL-TYPE-OCR" ->   LabelType.OCR
        "LABEL-TYPE-HANXIN" ->   LabelType.HANXIN
        "LABEL-TYPE-MAILMARK" ->   LabelType.MAILMARK
        "MULTICODE-DATA-FORMAT" ->   LabelType.FORMAT
        "LABEL-TYPE-GS1-DATAMATRIX" ->   LabelType.GS1DATAMATRIX
        "LABEL-TYPE-GS1-QRCODE" ->   LabelType.GS1QRCODE
        "LABEL-TYPE-DOTCODE" ->   LabelType.DOTCODE
        "LABEL-TYPE-GRIDMATRIX" ->   LabelType.GRIDMATRIX
        else ->   LabelType.UNDEFINED
    }

}