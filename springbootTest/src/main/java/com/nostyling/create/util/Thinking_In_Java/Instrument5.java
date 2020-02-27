package com.nostyling.create.util.Thinking_In_Java;

/**
 * @program: Sleepless-tonight.github.io
 * @author: shiliang
 * @create: 2020-02-25 14:57
 * @description:
 **/
interface Instrument5 {
    // Compile-time constant:
    int i = 5; // static & final
    // Cannot have method definitions:
    void play(); // Automatically public
    String what();
    void adjust();
}
class Wind5 implements Instrument5 {
    public void play() {
        System.out.println("Wind5.play()");
    }
    public String what() { return "Wind5"; }
    public void adjust() {}
}
