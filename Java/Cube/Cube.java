//package com.majorityof1.www.shapes;
/*
 *   The following example consists of both reference and primitive
 *   types. Reference variables start with uppercase and usually
 *   share the same name as their associated primitive types. 
 *   
 *    When we convert from primitive types to reference types,
 *   we call it "Autoboxing".
 *   
 *    e.x. double -> Double, byte -> Byte,  int -> Integer
 *    
 *    When we convert from reference types to primitive types,
 *   we call it "Unboxing". 
 *   
 *   e.x. Integer -> int, Float -> float, String->char
 *   
 *   H.W.: Add in Javadoc comments and make sure they work
 *   (only send me the source file with your annotations).
 *   Annotations should include return types, parameters, comments
 *   for all methods and classes.
 *   
 */

    /**
    * This class will create a Cube object.
    */

public class Cube {
    
    /**
    * Cube sets the sides of the cube equal to 
    * the value of the parameter passed.
    *
    * @param s length of the sides of the cube.
    *
    * Uses the setSide(s) function to set the
    * length of the side equal to s.
    */ 

    Cube(double s){
        setSide(s);
    }

    /**
    * getSide returns the side of the cube.
    *
    * @return returns the value of the side of the cube.
    */
     
    public double getSide(){
        return side;
    }

    /**
    * setSide sets the side of the cube
    * equal to the value of the parameter passed.
    *
    * @param s - length of side.
    */     

    public void setSide(double s) {
        side = s;
    }

    /**
    * calcVolume  calculates the volume of the cube.
    *
    * @return returns a side cubed.
    */
     
    public double calcVolume(){
        return side*side*side;
    }
     
    /**
    * calcSurfArea calculates the
    * surface area of the cube.
    *
    * @return multiplies a squared side by 6.
    */

    public double calcSurfArea(){
        return 6*side*side;
    }

    /**
    * Creates a private variable, side, 
    * of Cube object.
    */
    
    private Double side;
 
}
