// ILedBarLightService.aidl
package com.zebra.ledbarlightservice;

interface ILedBarLightService {
    /**
     * Sets the identified LED to the specified color.
     *
     * @param ledId is identity of the LED to control.
     * @param color is color value to set for the identified LED.
     */
    void setLight(int ledId, int color);

    /**
     * Turns OFF the LED.
     */
    void setLedOff();

    /**
     * Sets the identified LED to alternate between two specified colors for the given duration.
     */
    void setLightSequence(int ledId, int color1, int period1, int color2, int period2);

    /**
     * Sets the LED sequence to OFF and displays the specified color. 
     * If a color is not specified, turns OFF the LED.
     */
    void setLedSequenceOff(int ledId, int color);
}